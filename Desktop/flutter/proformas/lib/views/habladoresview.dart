import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:proformas/models/articulobloquemodel.dart';
import 'package:proformas/providers/userprovider.dart';
import 'package:proformas/services/helperservice.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/viewmodels/habladoresviewmodel.dart';
import 'package:proformas/views/scannerpage.dart';
import 'package:proformas/widgets/menudrawer.dart';
import 'package:proformas/widgets/modelready.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HabladoresView extends StatelessWidget {
  final List<ArticuloBloque>? articulosBloque;
  const HabladoresView({super.key,this.articulosBloque,});

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    NumberFormat format = NumberFormat.decimalPattern('es');

    return ChangeNotifierProvider(
      create: (_) => HabladoresViewModel(),
      child: ModelReady<HabladoresViewModel>(
        onModelReady: (HabladoresViewModel model) async {
          model.init(context, userProvider,articulosBloque);
        },
        child: Consumer<HabladoresViewModel>(builder: (context, model, child) {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: const Text('Habladores'),
              elevation: 0,
              leading: IconButton(
                  onPressed: (){
                    scaffoldKey.currentState?.openDrawer();
                  },
                  icon: const Icon(Icons.menu)
                ),
              actions: [
                IconButton(
                  onPressed: (){
                    model.getHabladoresHH();
                  },
                  icon: const Icon(Icons.refresh)
                ),
                IconButton(
                  onPressed: ()async{
                    if(model.habladores.isEmpty){
                      Dlg.showWarningSnackbar(context, 'No hay habladores para enviar a qupos');
                      return;
                    }
                    bool sendToQupos = await Dlg.confirm(context, 'Desea enviar esta lista a qupos ahora?');
                    if(!sendToQupos) return;
                    await model.moveListToQupos().then((value) {
                      if (value['statusCode']==200){
                        if (context.mounted){
                          Dlg.showSnackbar(context, value['message']);
                        }
                      }
                    }).onError((error, stackTrace){
                      if (context.mounted){
                        Dlg.showError(context, error.toString());
                      }
                    
                    });
                  },
                  icon: const Icon(Icons.send)
                ),
              ],
            ),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: model.habladores.length,
                    itemBuilder: ((context, index) {
                      return Dismissible(
                        key: Key(model.habladores[index].id.toString()) ,
                        direction: DismissDirection.startToEnd,
                        onDismissed: (DismissDirection direction) async {
                          if (DismissDirection.startToEnd == direction){
                            await model.deleteHablador(index).onError((error, stackTrace) {
                              if (context.mounted){
                                Dlg.showError(context, error.toString());
                              }
                            });
                          }
                        },
                        child: Card(
                          elevation: 1,
                          margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text( model.habladores[index].descripcion ?? '' )
                                      ),
                                    Text ('₡ ${format.format(model.habladores[index].venta)}')  
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: BarCodeW(model: model,)
                    )
                  )
                ],
              ),
            ),
            drawer: const MenuDrawer(),
          );
          
        },), 
      ),
    );
  }
}

class BarCodeW extends StatelessWidget {
  const BarCodeW({Key? key, this.model}) : super(key: key);
  final HabladoresViewModel? model;

  @override
  Widget build(BuildContext context) {
    return  Column(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: TextField(
                focusNode: model?.focusNode,
                keyboardType: TextInputType.number,
                onTap: () {
                  HelperService.selectText( model?.codigoController ); 
                },
                onSubmitted: (value) async {
                  if ( model!.codigoController!.text.isEmpty ) return ;
                  Dlg.showLoading(context, 'Obteniendo datos del articulo');
                  await model?.getArticulo( model!.codigoController!.text )
                  .onError((error, stackTrace) {
                    if (context.mounted){
                      Dlg.showError(context, error.toString());
                    }
                  })
                  .then(( resp ) async {
                    if (context.mounted){
                    Navigator.of(context).pop();
                      if ( resp['statusCode'] == 201 ){
                        Dlg.showWarning(context, resp['message']);
                      }
                    }
                  });
                  HelperService.selectText( model?.codigoController );
                },
                controller: model?.codigoController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Código',
                  suffixIcon: IconButton(
                    onPressed:() async {
                      if ( model!.codigoController!.text.isEmpty ) return ;
                      Dlg.showLoading(context, 'Obteniendo datos del articulo');
                      await model?.getArticulo( model?.codigoController?.text )
                      .onError((error, stackTrace) {
                        if (context.mounted){
                         Dlg.showError(context, error.toString());
                        }
                      })
                      .then(( resp ) async {
                        if (context.mounted){
                          Navigator.of(context).pop();
                          if ( resp['statusCode'] == 201 ){
                            await Dlg.showWarning(context, '${resp['message']}');
                          }
                        }
                      });
                      HelperService.selectText( model?.codigoController );
                    }, 
                  icon: const Icon( Icons.arrow_circle_right )),
                ),
              ),
            ),
            IconButton(
              onPressed:() async {
                var res = await Navigator.of(context).push<String>(
                  MaterialPageRoute(
                    builder: ( context ) => const ScannerPage()
                  )
                );
                if ( res is String ){
                  if ( res.isEmpty ) return ;
                  if ( res == '-1' ) return ;
      
                  model?.codigoController?.text = res ;
                  // ignore: use_build_context_synchronously
                  Dlg.showLoading(context, 'Obteniendo datos del articulo');
                  await model?.getArticulo( model?.codigoController?.text )
                  .onError((error, stackTrace) {
                    if (context.mounted){
                     Dlg.showError(context, error.toString());
                    }
                  })
                  .then(( resp ) async{
                    if (context.mounted){
                      Navigator.of(context).pop();
                      if ( resp['statusCode'] == 201 ){
                        await Dlg.showWarning(context, '${resp['message']}');
                      }
                    }
                  });
                }
              }, 
              icon: const Icon( Icons.qr_code)
            ),
          ],
        ),
      ),
      model!.useBroadCast! && model?.receiver != null ?  BroadCastStreamBuilder(model: model,) : const SizedBox(),
    ],
    );
  }
}

class BroadCastStreamBuilder extends StatefulWidget {
  const BroadCastStreamBuilder({
    Key? key,
    this.model
  }) : super(key: key);
  final HabladoresViewModel? model ;

  @override
  State<BroadCastStreamBuilder> createState() => _BroadCastStreamBuilderState();
}

class _BroadCastStreamBuilderState extends State<BroadCastStreamBuilder> {

  @override
  void initState() {
    widget.model?.receiver?.start();
    widget.model?.receiver?.messages.listen((data){

    });
    super.initState();
  }

  @override
  void dispose() {
    widget.model?.receiver?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BroadcastMessage>(
      initialData: null,
      stream: widget.model?.receiver?.messages,
      builder: ((context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            widget.model?.codigoController?.text = snapshot.data?.data?['data'];
            Dlg.showLoading(context, 'Obteniendo datos del articulo');
              widget.model?.getArticulo( widget.model?.codigoController?.text )
              .onError((error, stackTrace) {
                if (context.mounted){
                  Dlg.showError(context, error.toString());
                }
              })
              .then(( resp ) async {
                if (context.mounted){
                  Navigator.of(context).pop();
                  if ( resp['statusCode'] == 201 ){
                    Dlg.showWarning(context, '${resp['message']}');
                  }
                }
              });
              HelperService.selectText( widget.model?.codigoController );
            return const SizedBox();

          case ConnectionState.none:
          case ConnectionState.done:
          case ConnectionState.waiting:
          return const SizedBox();
        }
      })
    );
  }
}

