import 'package:flutter/material.dart';
import 'package:proformas/providers/userprovider.dart';
import 'package:provider/provider.dart';
import 'package:proformas/models/cliente.dart';
import 'package:proformas/models/preproforma.dart';
import 'package:proformas/models/preproformadetalle.dart';
import 'package:proformas/repositories/preproformarepository.dart';
import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/services/preproformaservice.dart';

class PreProformaViewModel extends ChangeNotifier {
  final ConfigService _configService = ConfigService();

  final PreProformaRepository _repository = PreProformaRepository(PreProformaService(), ConfigService()); 
  PreProforma? preProforma ; 
  List<PreProformaDetalle> preProformaDetalle = [];
  BuildContext? context ;
  bool? mostrarTeclado = false ;
  bool? readOnly = true ;
  bool? useBroadCast = false ;
  double? cantidad = 1 ;
  TextEditingController txtCodigoController = TextEditingController();
  FocusNode focusNode = FocusNode();

  void init(PreProforma? preProforma, BuildContext context) async {
    this.context = context ;
    this.preProforma = preProforma ;
    await _configService.toConfig().then(((value) {
      if ( value ){
        Navigator.of(context).pushReplacementNamed('config');
      } else {
        useBroadCast = _configService.getUseBroadcast();
  
        getPreproformaDetalleById().onError((error, stackTrace) {
          if (context.mounted){
            Dlg.showError(context, error.toString());
          }
        });
      }
    }));
  }

  bool? enviadaQupos(){
    return preProforma?.enviada;
  }



  void setCantidad( double?  newCount ) {
    cantidad = newCount ;
    notifyListeners();
  }

  Future<void> getPreproformaDetalleById() async {
    preProformaDetalle = await _repository.getPreproformaDetalleById(preProforma!.id!);
    setTotales();
  }

  void insertItemFromBroadCast(String codigo) async {
      codigo = codigo.replaceAll(' ', '');
      codigo = codigo.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
          //Toda la logica aqui
      if ( isInList( codigo ) ){
   
        await updateItemCont( cantidad!, codigo ).onError((error, stackTrace) => Dlg.showError(context!, error.toString()));
        
      } else {
 
        await insertItem(cantidad!, codigo ).onError((error, stackTrace) => Dlg.showError(context!, error.toString())).then((value) {
          final Map<String, dynamic> resp = value ;

          if ( resp['statusCode'] == 201 ){

              if ( !context!.mounted ) return;
              Dlg.showInfo(context!, resp['message']);
          
          } 
        });
      }
  }

  Future<dynamic> insertItem(double cantidad, String codigo) async {
    final UserProvider user = Provider.of(context!, listen: false);

    final Map<String, dynamic> data  = {
      'codigo' : codigo,
      'cantidad' : cantidad,
      'preproforma_id' : preProforma!.id ,
      'tope_descuento': user.getUsuario()!.topeDescuento,
      'porc_descuento': preProforma?.porcDescuento ?? 0
    };

    final Map<String, dynamic> result =  await _repository.insertItem(data) ;
    
    if ( result['statusCode']  == 200 ){

      PreProformaDetalle item = PreProformaDetalle.fromMap(result['item']);

      if ( preProforma?.exento == '1' ){

        item = exonerarLinea( item );
        List<PreProformaDetalle> lista = [item];
        await _repository.exonerarLista( lista );
        
      }

      preProformaDetalle.insert(0, item );
      setTotales();

    } 

    return result ;
  }

  Future<dynamic> updateItemCont( double cantidad, String? codigo) async {

    PreProformaDetalle item = getItem(codigo);
    final double newCount = cantidad + item.cantidad! ;
    final double newTotal = newCount * item.venta! ;

    final Map<String, dynamic> result = await _repository.updateItemCount( item.id! ,codigo!, newCount, newTotal );

    if ( result['statusCode'] == 200 ){

      final int index = preProformaDetalle.indexWhere((element) => element.id == item.id);
      preProformaDetalle[index].cantidad = newCount ;
      preProformaDetalle[index].total = newTotal ;
      setTotales();
      
    }

    return result;
  }

  Future<void> deleteItem(int? id) async {
    final bool result = await _repository.deleteItem(id);
    if ( result ){
      final int index = preProformaDetalle.indexWhere((element) => element.id == id);
      preProformaDetalle.removeAt(index);
      setTotales();
    }
  }

  PreProformaDetalle getItem(String? codigo){
    final int index = preProformaDetalle.indexWhere((element) => element.codigo == codigo);
    return preProformaDetalle[index];
  }

  bool isInList(String? codigo){

    final int index = preProformaDetalle.indexWhere((element) => element.codigo == codigo);

    if ( index > -1 ) {
      return true ;
    } else {
      return false ;
    }
  }

  Future<dynamic> updateRow( int id, double cantidad ) async {
    final int index = preProformaDetalle.indexWhere((element) => element.id == id);
    double total = preProformaDetalle[index].venta! * cantidad ;

    final Map<String, dynamic> result  = await _repository.updateItemCount( id, preProformaDetalle[index].codigo!, cantidad, total );

    if ( result['statusCode'] == 200 ) {
      preProformaDetalle[index].cantidad = cantidad ;
      preProformaDetalle[index].total = total ;
      setTotales();
    }

    return result;
  } 

  Future<void> setClienteToPreproforma( Cliente cliente ) async {
    preProforma?.codCliente = cliente.codCliente;
    preProforma?.razonSocial = cliente.razonSocial;
    preProforma?.razonComercial = cliente.razonComercial;
    preProforma?.email = cliente.email;
    preProforma?.telefono1 = cliente.telefono1;
    preProforma?.telefono2 = cliente.telefono2;
    preProforma?.porcDescuento = cliente.porcDescuento;
    preProforma?.exento = cliente.exento;
    preProforma?.tipoDocumentoExo = cliente.tipoDocumentoExo;
    preProforma?.numeroDocumentoExo = cliente.numeroDocumentoExo;
    preProforma?.nombreInstitucionExo = cliente.nombreInstitucionExo;
    preProforma?.fechaEmisionExo = cliente.fechaEmisionExo;
    preProforma?.fechaFinExo = cliente.fechaFinExo;
    preProforma?.codigoImpuestoTarifaReducida = cliente.codigoImpuestoTarifaReducida;
    preProforma?.porcentajeImpuestoTarifaReducida = cliente.porcentajeImpuestoTarifaReducida;

    if ( cliente.exento == '1' ){
      exonerarLista();
    }
    setTotales();

    await _repository.setClienteToPreproforma(preProforma!);
  }

  Future<void> removeClienteToPreproforma() async {
    preProforma?.codCliente = null;
    preProforma?.razonSocial = null;
    preProforma?.razonComercial = null ;
    preProforma?.porcDescuento = 0 ;
    preProforma?.exento = null;
    preProforma?.tipoDocumentoExo = null;
    preProforma?.numeroDocumentoExo = null;
    preProforma?.nombreInstitucionExo = null;
    preProforma?.fechaEmisionExo = null;
    preProforma?.fechaFinExo = null;
    preProforma?.codigoImpuestoTarifaReducida = null;
    preProforma?.porcentajeImpuestoTarifaReducida = 0;
    setTotales();

    await _repository.setClienteToPreproforma(preProforma!);
  }

  Future<void> setTotales(  ) async {
    double tempSubTotal = 0;
    double tempTotal = 0;
    double montoIvColones = 0;
    double subTotalExento = 0;
    double subTotalGravado = 0;
    
    for (int x = 0; x <= preProformaDetalle.length -1; x++){
      
      double ventaSinDescuento = (preProformaDetalle[x].venta! * 100 ) / ( 100 - preProformaDetalle[x].porcDescuento! );

      tempSubTotal+=  ventaSinDescuento * preProformaDetalle[x].cantidad! ;
      tempTotal+= preProformaDetalle[x].venta! * preProformaDetalle[x].cantidad! ;

      if ( preProformaDetalle[x].porcImpuesto! > 0 ){

        montoIvColones+= ( preProformaDetalle[x].venta! * preProformaDetalle[x].cantidad! ) * ( preProformaDetalle[x].porcImpuesto! / 100 ) ;
        subTotalGravado+= preProformaDetalle[x].venta! * preProformaDetalle[x].cantidad!;

      } else if ( preProformaDetalle[x].porcImpuesto == 0){

        subTotalExento+= preProformaDetalle[x].venta! * preProformaDetalle[x].cantidad! ;

      }
    }

    preProforma?.subTotal = tempSubTotal ;
    preProforma?.total = tempTotal ;
    //preProforma.porcDescuento = ( tempTotal == 0 && tempSubTotal == 0 ) ? 0 : 100 - ( ( tempTotal * 100 ) / tempSubTotal );
    preProforma?.descuento = tempSubTotal - tempTotal;
    preProforma?.montoIvColones = montoIvColones ;
    preProforma?.subTotalExento = subTotalExento ;
    preProforma?.subTotalGravado = subTotalGravado;
    notifyListeners();

    await _repository.setTotales( preProforma! );
  }

  Future<void> exonerarLista( ) async {
    if ( preProforma?.exento == '1' ){
      for ( int x = 0; x <= preProformaDetalle.length -1; x++ ){
        preProformaDetalle[x]  = exonerarLinea(preProformaDetalle[x]);
      }
      notifyListeners();
      await _repository.exonerarLista(preProformaDetalle);
    }
  }

  PreProformaDetalle exonerarLinea( PreProformaDetalle preProformaDetalle ) {
    if ( preProforma?.exento == '1' ){
        //si el porcentaje de impuesto actual es menor al porcentaje impuesto de la tarifa reducida retornamos tal y como esta
        if ( preProformaDetalle.porcImpuesto! < preProforma!.porcentajeImpuestoTarifaReducida! ){
          return preProformaDetalle;
        }
        //Despejar el precio sin el impuesto actual
        double precioSinImpuesto = (preProformaDetalle.venta! * 100) / (100 + preProformaDetalle.porcImpuesto!);
        //ajustar el porcentaje impuesto al impuesto de la tarifa reducida
        preProformaDetalle.porcImpuesto = preProforma?.porcentajeImpuestoTarifaReducida;
        //ajustar el precio con el porcentaje impuesto de la tarifa reducida
        preProformaDetalle.venta = (precioSinImpuesto * (100 + preProforma!.porcentajeImpuestoTarifaReducida!)) / 100 ;
        //ajustar el total
        preProformaDetalle.total = preProformaDetalle.venta! * preProformaDetalle.cantidad!;
        //retornar la linea exonerada
        return preProformaDetalle ;
    }
    return preProformaDetalle;
  }

  //back to real price
  Future<void> realPriceToList() async {
    final Map<String, dynamic> result  = await _repository.realPriceToList( preProformaDetalle );

    if ( result['statusCode'] == 200 ){

      final decodedList = result['lista'];
      preProformaDetalle = decodedList.map<PreProformaDetalle>((e) => PreProformaDetalle.fromMap(e)).toList();
      setTotales();

    }

  }

  Future<void> aplicarDescuentos() async {

    final UserProvider user = Provider.of(context!, listen: false);

    final Map<String, dynamic> params = {
      'tope_descuento': user.getUsuario()?.topeDescuento,
      'porc_descuento': preProforma?.porcDescuento,
      'lista': preProformaDetalle.map((e) => e.toMap()).toList()
    };

    final Map<String, dynamic> result = await _repository.aplicarDescuentos( params );

    if ( result['statusCode'] == 200 ){

      final decodedList = result['lista'];
      preProformaDetalle = decodedList.map<PreProformaDetalle>((e) => PreProformaDetalle.fromMap(e)).toList();
      setTotales();
    }
  }

  Future<void> descuentosEnCero() async {

    final Map<String, dynamic> params = {
      'lista': preProformaDetalle.map((e) => e.toMap()).toList()
    };

    final Map<String, dynamic> result = await _repository.descuentosEnCero( params );

    if ( result['statusCode'] == 200 ){

      final decodedList = result['lista'];
      preProformaDetalle = decodedList.map<PreProformaDetalle>((e) => PreProformaDetalle.fromMap(e)).toList();
      setTotales();

    }
  }


}
