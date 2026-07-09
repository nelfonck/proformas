import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proformas/models/bodega.dart';
import 'package:proformas/models/compania.dart';
import 'package:proformas/models/preproforma.dart';
import 'package:proformas/models/usuario.dart';
import 'package:proformas/providers/bodegaprovider.dart';
import 'package:proformas/providers/userprovider.dart';
import 'package:proformas/services/helperservice.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/viewmodels/historyviewmodel.dart';
import 'package:proformas/views/newpreproforma.dart';
import 'package:proformas/widgets/menudrawer.dart';
import 'package:proformas/widgets/modelready.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key, this.compania}) : super(key: key);

  final Compania? compania;

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  Widget build(BuildContext context)  {

    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    BodegaProvider bodegaProvider = Provider.of<BodegaProvider>(context, listen: false);
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return ChangeNotifierProvider(
      create: (_) => HistoryViewModel(),
      child: ModelReady<HistoryViewModel>(
        onModelReady: (HistoryViewModel model) async{
          model.init(context, widget.compania, mounted);
        },
        child: Consumer<HistoryViewModel>(builder: (context, model, child) {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: false, // Oculta el botón de retroceso
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pre proformas'),
                  Text( model.compania?.razonSocial ?? '' )
                ],
              ),
              elevation: 0,
              leading:  IconButton(
                onPressed: (){
                  scaffoldKey.currentState?.openDrawer();
                },
                icon: const Icon(Icons.menu)
              ),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: Colors.grey,
                  height: 1,
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  height: 50,
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.lightBlue
                        ),
                        onPressed: ()async{
                        DateTime? date = await HelperService.selectDate(context, model.from);
                            if ( date != null ){
                              model.setFromDate( date );
                              await model.getPreProformasByDate();
                            }
                        }, 
                        child: Text(DateFormat('dd-MM-yyyy').format( model.from ), style: const TextStyle(color: Colors.white),)
                      ),
                      const SizedBox(width: 20,),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.lightBlue
                        ),
                        onPressed: ()async{
                        DateTime? date = await HelperService.selectDate(context, model.date);
                          if ( date != null ){
                            model.setToDate( date );
                            await model.getPreProformasByDate();
                          }
                        }, 
                        child: Text(DateFormat('dd-MM-yyyy').format( model.date ), style: const TextStyle(color: Colors.white),)
                      ),
                    ]
                  ),
                ),
                model.isLoading ?? false ? 
                const Expanded(child:  Center(child: CircularProgressIndicator(),)) : 
                model.preproformas.isEmpty ?
                const Expanded(child:  Center(child:  Text('No data to display'),)) :
                Body(model: model, usuario: userProvider.getUsuario()!, bodega: bodegaProvider.getBodega()!,),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
                PreProforma preProforma = await model.addPreProforma(PreProforma(nombre:currentDate )).onError((error, stackTrace) {
                  if (context.mounted){
                    Dlg.showError(context, error.toString());
                  }
                });
                if (!context.mounted) return;
                final preproforma = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  NewPreProforma( preProforma: preProforma, ))
                );
                if (preproforma!=null){
                  model.setPreProforma( 0, preProforma );
                }
              },
              child: const Icon(Icons.add),
            ),
            drawer:  const MenuDrawer(),
          );
          
        },), 
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    Key? key,
    required this.model,
    required this.usuario,
    required this.bodega
  }) : super(key: key);

  final HistoryViewModel model ;
  final Usuario usuario;
  final Bodega bodega;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: model.preproformas.length,
        itemBuilder: ((context, index) {
          return  
          GestureDetector(
            onTap: () async {
              final PreProforma? preProforma = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  NewPreProforma( preProforma: model.preproformas[index], ))
                );
              if ( preProforma != null ){
                model.setPreProforma( index, preProforma );
              }
            },
            child: Dismissible(
              confirmDismiss: (direction) async {
                return await Dlg.confirm(context, 'Seguro de eliminar? Pre-proforma #${model.preproformas[index].id}');
              },
              direction: DismissDirection.startToEnd,
              onDismissed: (direction) async {
                await model.deletePreProforma(index).onError((error, stackTrace) {
                  if (context.mounted){
                    Dlg.showError(context, error.toString());

                  }
                });
              },
              key: Key(model.preproformas[index].id.toString()),
              child:ListItem(model: model, usuario: usuario, bodega: bodega, index: index,)
               
            ),
          );
        })
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    Key? key,
    required this.model,
    required this.usuario,
    required this.bodega,
    required  this.index
  }) : super(key: key);

  final HistoryViewModel model;
  final Usuario usuario;
  final Bodega bodega;
  final int index ;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 20,),
                    Text( DateFormat('yyyy-MM-dd').format(model.preproformas[index].fecha!),
                    style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),),
                    Text(
                      'Pre-proforma #${model.preproformas[index].id}',
                      style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
                    ),
            
                    Visibility(
                      visible: model.preproformas[index].refproforma != null,
                      child: Text(
                        'Proforma #${ model.preproformas[index].refproforma != null ? NumberFormat.decimalPattern().format( model.preproformas[index].refproforma) : '' }',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                    Row(
                      children: [
                        Visibility(
                          visible: model.preproformas[index].codCliente != null,
                          child: IconButton(
                            onPressed: () async {
                  
                              await model.sendEmail( index ).onError((error, stackTrace) {
                                if (context.mounted){
                                 Dlg.showError(context, error.toString());
                                }
                              }).then((result) {
                  
                                  if ( result['statusCode'] == 200 ){
                                    if (context.mounted){
                                      Dlg.showSnackbar(context, result['message']);
                                    }
                                  }
                              });
                            
                            },
                            icon: const Icon(Icons.email, color: Colors.red,)
                          ),
                        ),
                        Visibility(
                          visible: model.preproformas[index].codCliente != null,
                          child: IconButton(
                            onPressed: () async {
                              await model.shareFile(model.preproformas[index], index);
                            },
                            icon: const Icon(FontAwesomeIcons.squareWhatsapp, color: Colors.green,)
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                !model.preproformas[index].enviada! ?
                IconButton(
                  onPressed: () async { 
                    await model.addProforma(index, usuario, bodega).onError((error, stackTrace) {
                      if (context.mounted){
                       Dlg.showError(context, error.toString());
                      }
                    });
                  },
                  icon: const Icon(Icons.send, color: Colors.blue,)
                ) :
                const SizedBox(child: Text('Enviada a Qpos', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),)
              ],
            ),
            Visibility(
              visible: model.preproformas[index].codCliente != null,
              child: Text(
                'Cliente: ${model.preproformas[index].razonSocial}',
                style: const TextStyle(color: Colors.blueGrey),
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Text('Monto IV ₡${NumberFormat.decimalPattern().format(model.preproformas[index].montoIvColones)}', style: const TextStyle(color: Colors.blueGrey)),
                Text('Exento ₡${NumberFormat.decimalPattern().format(model.preproformas[index].subTotalExento)}', style: const TextStyle(color: Colors.blueGrey)),
                Text('Gravado ₡${NumberFormat.decimalPattern().format(model.preproformas[index].subTotalGravado)}', style:  const TextStyle(color: Colors.blueGrey)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Text('Sub Total ₡${NumberFormat.decimalPattern().format(model.preproformas[index].subTotal)}', style: const TextStyle(color: Colors.blueGrey)),
                Text('Desc. ${NumberFormat.decimalPattern().format(model.preproformas[index].porcDescuento)}%', style: const TextStyle(color: Colors.blueGrey)),
                Text('Total ₡${NumberFormat.decimalPattern().format(model.preproformas[index].total)}', style:  TextStyle(color: Colors.cyan[900])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}