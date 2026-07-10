import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proformas/models/preproforma.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/viewmodels/preproformaviewmodel.dart';
import 'package:proformas/views/clienteview.dart';
import 'package:proformas/views/filtroarticuloview.dart';
import 'package:proformas/views/scannerpage.dart';
import 'package:proformas/widgets/modelready.dart';
import 'package:proformas/widgets/myspinbox.dart';
import 'package:provider/provider.dart';


class NewPreProforma extends StatefulWidget {
  const NewPreProforma({super.key, this.preProforma });
  final PreProforma? preProforma ;

  @override
  State<NewPreProforma> createState() => _NewPreProformaState();
}

class _NewPreProformaState extends State<NewPreProforma> {

    @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PreProformaViewModel(),
      child: ModelReady<PreProformaViewModel>(
        onModelReady: (PreProformaViewModel model) async {
            model.init(widget.preProforma, context);
        },
        child: Consumer<PreProformaViewModel>(builder: (context, model, child) {
        return Scaffold(
          appBar:  AppBar(
            title:  Text( model.preProforma != null ? 'Pre-proforma #${model.preProforma!.id}' : ''),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, widget.preProforma);
              },
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  
                  if (model.enviadaQupos() ?? false){
                    Dlg.showWarningSnackbar(context, 'Esta pre-proforma ya fue enviada a Qupos');
                    return;
                  }
        
                  final cliente = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ( context ) => const ClienteView()                    )
                  );
                  
                  if ( cliente != null ){
                    await model.setClienteToPreproforma( cliente ).onError((error, stackTrace) {
                      if (context.mounted){
                         Dlg.showError(context, error.toString());
                      }
                    });
                    if ( model.preProformaDetalle.isNotEmpty ){
                      await model.aplicarDescuentos().onError((error, stackTrace) {
                        if (context.mounted){
                           Dlg.showError(context, error.toString());
                        }
                      });
                    }
                  }
                },
                icon: const Icon(Icons.person_search),
                tooltip: 'Buscar cliente' ,
              )
            ],
          ),
          body:  PopScope(
            onPopInvokedWithResult: (didPop, result){
              if (didPop) return;
              Navigator.pop(context, model.preProforma);
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: model.preProforma?.razonSocial != null,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text( 
                              model.preProforma?.razonSocial != null ?  'Cliente: ${model.preProforma?.razonSocial}' : '' ,
                              style: const TextStyle(color: Colors.white),
                            ),
                            Visibility(
                              visible: model.preProforma?.exento == '1' ,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text( model.preProforma?.exento == '1' ? 'Cliente exonerado, tarifa reducida ${ NumberFormat.decimalPatternDigits().format(model.preProforma?.porcentajeImpuestoTarifaReducida) } %' : '',
                                 style: const TextStyle(color: Colors.cyanAccent)),
                              )
                            ),
                          ],
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          color: Colors.red ,
                          onPressed: () async {
        
                            if (model.enviadaQupos() ?? false){
                              Dlg.showWarningSnackbar(context, 'Esta pre-proforma ya fue enviada a Qupos');
                              return;
                            }
        
                            bool setCurrentPricesToList = false ;
        
                            if ( model.preProforma?.exento != null ){
                              if ( model.preProforma?.exento == '1' ){
                                setCurrentPricesToList = true ;
                              }
                            }
                            await model.removeClienteToPreproforma().onError((error, stackTrace) {
                              if (context.mounted){
                                Dlg.showError(context, error.toString());
                              }
                            });
                            
                            if ( model.preProformaDetalle.isNotEmpty ){
                              //Descuentos en cero
                              await  model.descuentosEnCero().onError((error, stackTrace) {
                                if (context.mounted){
                                   Dlg.showError(context, error.toString());
                                }
                              }) ;
                              //si es cliente exonerado actualiza al impuesto real
                              //Si es cliente exonerado no afecta a los descuentos ya que los clientes exonerados no se les aplica descuento
                              if ( !setCurrentPricesToList ) return ;
                              await model.realPriceToList().onError((error, stackTrace) {
                                if (context.mounted){
                                  Dlg.showError(context, error.toString());
                                }
                                
                              });
                              
                            }
        
                          },
                          icon: const Icon(Icons.remove_circle_outline, )
                        )
                      ],
                    )
                  )
                ),
                Body( model: model,),
                ToolsWidget(model: model, codigoFocus: model.focusNode, txtCodigoController: model.txtCodigoController, mounted: mounted),
                TotalesWidget(model: model),
              ],
            ),
          ),
        );
          
        },), 
      ),
    );
  }
}

class TotalesWidget extends StatelessWidget {
  const TotalesWidget({
    super.key,
    this.model
  });

  final PreProformaViewModel? model ;
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.lightGreenAccent, fontSize: 18),
      child: Container(
        width: double.infinity,
        color: Colors.blueGrey,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                 Text('PorcDesc. ${NumberFormat.decimalPattern().format(model?.preProforma?.porcDescuento ?? 0)}%'),
                 Text('Desc.₡${NumberFormat.decimalPattern().format(model?.preProforma?.descuento ?? 0)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                 Text('SubTotal ₡${NumberFormat.decimalPattern().format(model?.preProforma?.subTotal ?? 0)}'),
                 Text('Total. ₡${NumberFormat.decimalPattern().format(model?.preProforma?.total ?? 0)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ToolsWidget extends StatelessWidget {
  const ToolsWidget({
    super.key,
    required this.model,
    required this.codigoFocus,
    required this.txtCodigoController,
    required this.mounted,
 
  });
  final PreProformaViewModel model ;
  final FocusNode codigoFocus;
  final TextEditingController txtCodigoController;
  final bool mounted;


  @override
  Widget build(BuildContext context) {
    final FocusNode countFocusNode = FocusNode();

    return Container(
      height: 60,
      padding: const EdgeInsets.all(8.0),
      child:   Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children:  [
            Expanded(
            child:  TextField(
              onSubmitted: (value) {
                if ( txtCodigoController.text.isEmpty) return ;
                countFocusNode.requestFocus();
              },
              keyboardType: TextInputType.number,
              showCursor: true,
              focusNode:  codigoFocus,
              autofocus: false,
              controller: txtCodigoController,
              decoration:  InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () async {
                  var res = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScannerPage(),
                    ));
                              
                    if (res is String) {
                      if ( res.isEmpty) return ;
                      if (res == '-1') return ;

                      txtCodigoController.text = res;
                      countFocusNode.requestFocus();
                      
                    }
                              
                  },
                  
                  icon: const Icon(Icons.qr_code)
                ),
                hintText: 'Código',
                prefixIcon: IconButton(
                  onPressed: () async {
                    String? code = await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const FiltroArticuloView())
                    );
                    if (code!=null){
                      model.txtCodigoController.text = code;
                      countFocusNode.requestFocus();
                    }
                  }, 
                  icon: const Icon(Icons.search)
                )
              ),
            ),
          ),
          const SizedBox(width: 5,), 
          MySpinBox(
            index: -1,
            widht: 200,
            height: 100,
            border: true,
            model: model,
            focusNode: countFocusNode,
            send: true,
          ),
        ],
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
    this.model
  });
  
  final PreProformaViewModel? model ;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: model?.preProformaDetalle.length,
        itemBuilder: ((context, index) {
          return  Dismissible(
            key: Key(model!.preProformaDetalle[index].id.toString()) ,
            direction: model?.enviadaQupos() ?? false ? DismissDirection.none : DismissDirection.startToEnd,
            confirmDismiss: (DismissDirection direction) async {
              return await Dlg.confirm(context, "Está seguro de eliminar este articulo? \n${model?.preProformaDetalle[index].descripcion}");
            },
            onDismissed: (direction) async {
              await model?.deleteItem(model?.preProformaDetalle[index].id).onError((error, stackTrace) {
                if (context.mounted){
                   Dlg.showError(context, error.toString());
                }
              });
            },
            child: Card(
              elevation: 1,
              margin: const EdgeInsets.only(top: 3), 
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.only(left: 0),
                  dense: true,
                  title: Text( model?.preProformaDetalle[index].descripcion ?? '' )  ,
                  leading: SizedBox(
                    width: 150,
                    child: MySpinBox(
                      index: index,
                      model: model, 
                      widht: 150, 
                      height: 100, 
                      border: false,
                      send: false
                    )
                  ) ,
                  trailing: Text( '₡ ${NumberFormat.decimalPattern().format( model?.preProformaDetalle[index].total ?? 0)}' ),
                ),
              ),
            ),
          );
        })
      ),
    );
  }
}
