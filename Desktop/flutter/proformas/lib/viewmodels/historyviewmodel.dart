

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:proformas/models/appupdate.dart';
import 'package:proformas/models/bodega.dart';
import 'package:proformas/models/compania.dart';
import 'package:proformas/models/preproforma.dart';
import 'package:proformas/models/preproformadetalle.dart';
import 'package:proformas/models/usuario.dart';
import 'package:proformas/repositories/emailrepository.dart';
import 'package:proformas/repositories/preproformarepository.dart';
import 'package:proformas/repositories/proformarepository.dart';
import 'package:proformas/repositories/updaterepository.dart';
import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/emailservice.dart';
import 'package:proformas/services/helperservice.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/services/preproformaservice.dart';
import 'package:proformas/services/proformaservice.dart';
import 'package:proformas/services/updateservice.dart';
import 'package:proformas/views/actualizarappview.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

enum Phone{
  phone1,
  phone2,
  none,
  both
}

class HistoryViewModel extends ChangeNotifier {
  final PreProformaRepository _repository = PreProformaRepository(PreProformaService(), ConfigService()); 
  final ProformaRepository _proformaRepository = ProformaRepository(ProformaService(), ConfigService()); 
  final EmailRepository _emailRepository = EmailRepository(EmailService(), ConfigService()); 
  final UpdateRepository _updateRepository = UpdateRepository(UpdateService());
  Compania? compania;
  DateTime date  = DateTime.now();
  DateTime from = DateTime.now();
  List<PreProforma> preproformas = [];
  BuildContext? context ;
  bool? isLoading = false ;
  bool? mounted ;
  bool? sendingEmail = false;

  void init(BuildContext context, Compania? compania, bool? mounted) async {
    this.context = context ;
    this.compania = compania ;
    this.mounted = mounted ;
    from = HelperService.firstDayOfMonth(date);

    await ConfigService().toConfig().then(((value) async {
      if ( value ){
        Navigator.of(context).pushReplacementNamed('config');
      } else {
        await checkForUpdates().onError((error, stackTrace) {
          if (!context.mounted) return;
            Dlg.showError( context, error.toString());
        });
        await getPreProformasByDate().onError((error, stackTrace) {
          if (!context.mounted) return;
            Dlg.showError( context, error.toString()) ;
        });
      }
    }));
  }

  Future<void> getPreProformas() async {
    isLoading = true ;
    notifyListeners();
    preproformas = await _repository.getPreProformas();
    isLoading = false ;
    notifyListeners();
  }

  Future<void> getPreProformasByDate() async {
    isLoading = true ;
    notifyListeners();
    preproformas = await _repository.getPreProformasByDate( from, date );
    isLoading = false ;
    notifyListeners();
  }

  Future<dynamic> addPreProforma( PreProforma preProforma ) async {
    final PreProforma result = await _repository.addPreProforma(preProforma);
    preproformas.insert( 0, result);
    notifyListeners();
    return result ;
  }

  Future<void> addProforma( int index, Usuario usuario, Bodega bodega ) async {
    PreProforma preProforma = preproformas[index];
    PreProforma preProformaCloned = PreProforma.clone(preProforma);
    preProformaCloned = getPreProformaTotalSinDescuento(preProformaCloned);

    final List<PreProformaDetalle> preproformadetalle = await _repository.getPreproformaDetalleById( preProforma.id! );
    //final List<PreProformaDetalle> preproformadetalleSinDescuento = getPreProformaDetalleSinDescuento(  preproformadetalle );

    final Map<String, dynamic> result = await _proformaRepository.addProforma( preProformaCloned, preproformadetalle, usuario, bodega );

    if ( result['statusCode'] == 200 ) {

      preproformas[index].refproforma = result['cod_factura'].toDouble();
      preproformas[index].enviada = true;

    }

    notifyListeners();

  }

  Future<Map<String,dynamic>?> sendEmail( int index ) async {
   
    PreProforma preProforma = preproformas[index];
    PreProforma preProformaCloned = PreProforma.clone(preProforma);
    preProformaCloned = getPreProformaSubTotalSinDescuento(preProformaCloned);

    final List<PreProformaDetalle> preproformadetalle = await _repository.getPreproformaDetalleById( preProforma.id! );
    final Map<String, dynamic>? result = await _emailRepository.sendEmail( preProformaCloned, preproformadetalle, compania! );

    return result ;
  }

  void setSendingEmail(bool? value){
    sendingEmail = value;
    if (context?.mounted ??false ){
      notifyListeners();
    }
  }

  void setPreProforma( int index, PreProforma preProforma ) {
    preproformas[index] = preProforma ;
    notifyListeners();
  }

  Future<void> deletePreProforma( int index) async {
    final int id = preproformas[index].id!;
    final Map<String, dynamic> result = await _repository.deletePreProforma(id);

    if ( result['deleted'] ){
      preproformas.removeAt( index );
      notifyListeners();
    }
  }

  void setToDate( DateTime date ){
    this.date = date ;
    notifyListeners();
  }

  void setFromDate( DateTime date ){
    from = date ;
    notifyListeners();
  }

  
  Future<void> checkForUpdates() async {
          
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    String buildNumber = packageInfo.buildNumber;

     List<AppsUpdate> appsUpdate = await _updateRepository.checkForUpdate();

    for (var element in appsUpdate) {
      if ((element.versionCode! > int.parse(buildNumber)) &&
          (element.packageName == packageName)) {

          final actualizar = await Dlg.confirmUpdate(element.versionName!, element.features!) ;

          if (!actualizar!) return ;
          if (!mounted!) return;

          Navigator.of(context!).push(
            MaterialPageRoute(
              builder: ( context ) =>  ActualizarAppView(appUrl: element.dodwnloadUrl!, versionName: element.versionName!)
            ));
        
        break;
      }
    }
  }

  List<PreProformaDetalle> getPreProformaDetalleSinDescuento(List<PreProformaDetalle> preproformadetalle) { 

    final List<PreProformaDetalle> cloned = preproformadetalle.map((e) => PreProformaDetalle.clone(e)).toList();

    for (int x = 0; x <= cloned.length -1; x++){
      cloned[x].venta = ((cloned[x].venta! * 100) / (100 - cloned[x].porcDescuento! )) ;
      cloned[x].total = cloned[x].venta! * cloned[x].cantidad!;
    }

    return cloned;
    
  }

  PreProforma getPreProformaTotalSinDescuento( PreProforma preProforma ){
    final double porcDescuentoAplicado = despejarPorcDesc( preProforma.total! , preProforma.subTotal!);
    
    preProforma.total = (( preProforma.total! * 100 ) / ( 100 - porcDescuentoAplicado ));
    return preProforma;
  }

  PreProforma getPreProformaSubTotalSinDescuento( PreProforma preProforma ){
    final double porcDescuentoAplicado = despejarPorcDesc( preProforma.total! , preProforma.subTotal!);
    
    preProforma.subTotal = (( preProforma.total! * 100 ) / ( 100 - porcDescuentoAplicado ));
    return preProforma;
  }

  double despejarPorcDesc( double montoConDescuento, double montoSinDescuento ) {
    if ( montoConDescuento > 0  && montoSinDescuento > 0 ){
      return 100 - (( montoConDescuento * 100 ) / montoSinDescuento) ;
    } else {
      return 0;
    }
  }

  Future<List<PreProformaDetalle>> getPreproformaDetalleById(int id) async {
    return await _repository.getPreproformaDetalleById(id);
  }


  Future<Document> createPDF(PreProforma preProforma, List<PreProformaDetalle> preProformaDetalle, int index) async{
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    build: (pw.Context context) => [
      //Logo
      if (compania?.logo != null)
      pw.Image(pw.MemoryImage(compania!.logo!)),
      //title
      pw.Text(
        compania?.razonSocial ?? '',
        style: pw.TextStyle(fontWeight: FontWeight.bold),
      ),
      pw.Text('Cedula: ${compania?.identificacion}'),
      pw.Text('Telefono: ${compania?.telefono}'),
      pw.Text('Dirección: ${compania?.direccion}'),
      pw.SizedBox(height: 10),
      pw.Table(
        border: pw.TableBorder.all(color: PdfColors.grey),
        defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
        columnWidths: {
          0: const pw.FixedColumnWidth(50),   // Cantidad
          1: const pw.FixedColumnWidth(80),   // Código
          2: const pw.FlexColumnWidth(5),     // Descripción
          3: const pw.FixedColumnWidth(70),   // Precio
          4: const pw.FixedColumnWidth(70),
        },
        children: [
            pw.TableRow(
            decoration:  const pw.BoxDecoration(
              color: PdfColors.blue100,
            ),
            children: [
              pw.Padding(
                padding:  const pw.EdgeInsets.all(8),
                child: pw.Text('Cant.')
              ),
              pw.Padding(
                padding:  const pw.EdgeInsets.all(8),
                child: pw.Text('Código')
              ),
              pw.Padding(
                padding:  const pw.EdgeInsets.all(8),
                child: pw.Text('Descripción')
              ),
              pw.Padding(
                padding:  const pw.EdgeInsets.all(8),
                child:  pw.Text('Precio')
              ),
              pw.Padding(
                padding:  const pw.EdgeInsets.all(8),
                child: pw.Text('Total')
              ),
            ]
          ),
          ...List.generate(preProformaDetalle.length, (i) {
            return pw.TableRow(
              children: [
                pw.Padding(
                  padding:  const pw.EdgeInsets.all(8),
                  child: pw.Text(preProformaDetalle[i].cantidad.toString())
                ),
                pw.Padding(
                  padding:  const pw.EdgeInsets.all(8),
                  child: pw.Text(preProformaDetalle[i].codigo.toString())
                ),
                pw.Padding(
                  padding:  const pw.EdgeInsets.all(8),
                  child: pw.Text(preProformaDetalle[i].descripcion ?? '')
                ),
                pw.Padding(
                  padding:  const pw.EdgeInsets.all(8),
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text( NumberFormat.decimalPattern().format(preProformaDetalle[i].venta) 
                  ))
                ),
                pw.Padding(
                  padding:  const pw.EdgeInsets.all(8),
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text( NumberFormat.decimalPattern().format(preProformaDetalle[i].total)
                  ))
                )
              ]
            );
          }),
          pw.TableRow(
            decoration: const pw.BoxDecoration(
              color: PdfColors.grey200,
            ),
            children: [
              pw.SizedBox(),
              pw.SizedBox(),
              pw.SizedBox(),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Sub Total ')
                )
              ),
              pw.Padding(
                padding:  const pw.EdgeInsets.all(8),
                child: pw.Text(NumberFormat.decimalPatternDigits(decimalDigits: 0).format(preproformas[index].subTotal))
              )
            ]
          ),
          pw.TableRow(
            decoration: const pw.BoxDecoration(
              color: PdfColors.grey200,
            ),
            children: [
              pw.SizedBox(),
              pw.SizedBox(),
              pw.SizedBox(),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Excento ')
                )
              ),
              pw.Padding(
                padding:  const pw.EdgeInsets.all(8),
                child: pw.Text(NumberFormat.decimalPatternDigits(decimalDigits: 0).format(preproformas[index].subTotalExento))
              )
            ]
          ),
          pw.TableRow(
            decoration: const pw.BoxDecoration(
              color: PdfColors.grey200,
            ),
            children: [
              pw.SizedBox(),
              pw.SizedBox(),
              pw.SizedBox(),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Gravado ')
                )
              ),
              pw.Padding(
                padding:  const pw.EdgeInsets.all(8),
                child: pw.Text(NumberFormat.decimalPatternDigits(decimalDigits: 0).format(preproformas[index].subTotalGravado))
              )
            ]
          ),
          pw.TableRow(
            decoration: const pw.BoxDecoration(
              color: PdfColors.grey200,
            ),
            children: [
              pw.SizedBox(),
              pw.SizedBox(),
              pw.SizedBox(),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Monto Iv ')
                )
              ),
              pw.Padding(
                padding:  const pw.EdgeInsets.all(8),
                child: pw.Text(NumberFormat.decimalPatternDigits(decimalDigits: 0).format(preproformas[index].montoIvColones))
              )
            ]
          ),
          pw.TableRow(
            decoration: const pw.BoxDecoration(
              color: PdfColors.grey200,
            ),
            children: [
              pw.SizedBox(),
              pw.SizedBox(),
              pw.SizedBox(),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Descuento ')
                )
              ),
              pw.Padding(
                padding:  const pw.EdgeInsets.all(8),
                child: pw.Text('${NumberFormat.decimalPatternDigits(decimalDigits: 0).format(preproformas[index].porcDescuento)}%')
              )
            ]
          ),
          pw.TableRow(
            decoration:  const pw.BoxDecoration(
              color: PdfColors.blue100,
            ),
            children: [
              pw.SizedBox(),
              pw.SizedBox(),
              pw.SizedBox(),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Total ')
                )
              ),
              pw.Padding(
                padding:  const pw.EdgeInsets.all(8),
                child: pw.Text(
                  NumberFormat.decimalPatternDigits(decimalDigits: 0).format(preproformas[index].total),
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold,)
                )
              )
            ]
          ),
        ]
      )
    ])); 
    return pdf;
  }

  Future<String> savePDF(Document pdf) async{
    // On Flutter, use the [path_provider](https://pub.dev/packages/path_provider) library:
    final output = await getTemporaryDirectory();
    final absolutePath = "${output.path}/proforma.pdf";
    final file = File(absolutePath);
    await file.writeAsBytes(await pdf.save());
    return absolutePath;
  }


  Future<void> shareFile(PreProforma preProforma, int index) async {
    //getPreproformaDetalleById
    List<PreProformaDetalle> preProformaDetalle = await getPreproformaDetalleById(preProforma.id!);
    //create pdf
    Document pdf = await createPDF(preProforma, preProformaDetalle, index);
    //save pdf
    String filePath = await savePDF(pdf);
    //share pdf
    File file = File(filePath);
    String fileName = path.basename(filePath);
    XFile xFile = XFile(file.path, name: fileName);

    Phone validPhone = validatePhone(preProforma);
    
    // ignore: use_build_context_synchronously
    String? phone = validPhone == Phone.phone1 ? await HelperService.chooseNumber(context!, [preProforma.telefono1!]) : 
                   // ignore: use_build_context_synchronously
                   validPhone == Phone.phone2 ? await HelperService.chooseNumber(context!, [preProforma.telefono2!]) :
                   validPhone == Phone.none ? null :
                        // ignore: use_build_context_synchronously
                   validPhone == Phone.both ? await HelperService.chooseNumber(context!, [preProforma.telefono1!, preProforma.telefono2!]) : null;

    if (phone == '-1') return;

    if ( phone != null ){
      phone = validatePrefix(phone);
    }

    await SharePlus.instance.share(
      ShareParams(
        files: [
          xFile,
        ],
      ),
    );
  }

  Phone validatePhone(PreProforma preProforma){
    //check nulls
    if (preProforma.telefono1 == null && preProforma.telefono2 == null){
      return Phone.none;
    } else if (preProforma.telefono1 != null && preProforma.telefono2 != null){
      String? a = preProforma.telefono1?.substring(0,1);
      String? b = preProforma.telefono2?.substring(0,1);
      if (a == '2' && b == '2'){
        return Phone.none;
      } else if ( a != '2' && b == '2' ){
        return Phone.phone1;
      } else if ( a == '2' && b != '2' ){
        return Phone.phone2;
      } else if ( a != '2' && b != '2' ){
        return Phone.both;
      }
    } else if ( preProforma.telefono1 != null && preProforma.telefono2 == null ) {
      String? a = preProforma.telefono1?.substring(0,1);
      if ( a != '2'){
        return Phone.phone1;
      } else {
        return Phone.none;
      }
    } else if ( preProforma.telefono1 == null && preProforma.telefono2 != null ){
      String? b = preProforma.telefono2?.substring(0,1);
      if ( b != '2'){
        return Phone.phone2;
      } else {
        return Phone.none;
      }
    }
    return Phone.none;
  }

  String validatePrefix(String phone) {
    String a = phone.substring(0,1);
    String prefix = '+506';
    String completePhone = phone;

    if ( a != '+' ){
      completePhone = '$prefix$phone';
      return completePhone;
    }
    return completePhone;
  }
}