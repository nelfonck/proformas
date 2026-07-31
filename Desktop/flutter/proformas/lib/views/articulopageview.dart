import 'package:flutter/material.dart';
import 'package:proformas/models/compania.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/viewmodels/articuloviewmodel.dart';
import 'package:proformas/views/comparararticulopage.dart';
import 'package:proformas/views/detallearticulopage.dart';
import 'package:proformas/views/preciosarticulopage.dart';
import 'package:proformas/views/unidadmedidaarticulopage.dart';
import 'package:proformas/widgets/barcodewidget.dart';
import 'package:proformas/widgets/menudrawer.dart';
import 'package:proformas/widgets/modelready.dart';
import 'package:provider/provider.dart';

class ArticuloPageView extends StatefulWidget {
  const ArticuloPageView({super.key, required this.compania });
  final  Compania compania;
  @override
  State<ArticuloPageView> createState() => _ArticuloPageViewState();
}

class _ArticuloPageViewState extends State<ArticuloPageView> with TickerProviderStateMixin{
  TabController? tabController ;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    if(tabController!=null){
      tabController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return ChangeNotifierProvider(
        create: (_) => ArticuloViewModel(),
        child: ModelReady<ArticuloViewModel>(
          onModelReady: (ArticuloViewModel model) async{
            model.init( context );
          },
          child: Consumer<ArticuloViewModel>(
            builder: ((context, model, child) {
            return  Scaffold(
              resizeToAvoidBottomInset: true,
              key: scaffoldKey,
              appBar: AppBar(
                title: const Text('Editar artículos'),
                elevation: 0,
                bottom: TabBar(
                  controller: tabController,
                  onTap: (value){
                    if ( model.pageController.hasClients ) {
                      model.pageController.animateToPage(
                        value, 
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut
                      );
                    }
                  },
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.info),
                      child: Text('Detalle'),
                    ),
                    Tab(
                      icon: Icon(Icons.numbers),
                      child: Text('Unidades'),
                    ),
                    Tab(
                      icon: Icon(Icons.price_change_outlined),
                      child: Text('Precios'),
                    ),
                    Tab(
                      icon: Icon(Icons.compare),
                      child: Text('Comparar'),
                    ),
                  ]
                ),
                actions: [
                  /*IconButton(onPressed: () async {
                    Articulo articulo = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: ( context ) => const NewArticuloPageView()
                      )
                    );
              
                    if ( articulo != null ){
                      // ignore: use_build_context_synchronously
                      Dlg.showLoading(context, 'Obteniendo datos del articulo');
                      await model.getArticulo(articulo.codArticulo).onError((error, stackTrace) {
                        Navigator.of(context).pop();
                        Dlg.showError(context, error);
                      }).then((value) => Navigator.of(context).pop());
                    }
                    },
                    icon: const Icon(Icons.add)
                  ),*/
                  IconButton(onPressed: () async {
                    await model.updateArticulo().onError((error, stackTrace) {
                      if (context.mounted){
                      Dlg.showError(context, error.toString());
                      }
                    }).then((value) {
                      if ( value['statusCode'] == 200 ){
                        if (context.mounted){
                          Dlg.showSnackbar(context, value['message']);
                        }
                      }
                      
                    });
                  },
                  icon: const Icon(Icons.save_outlined)
                  ),
                IconButton(onPressed: () async {
                  await model.insertarHablador(model.articulo?.codArticulo).then((value) {
                    if (value != null){
                      if ( value['statusCode'] == 201 ){
                        if (context.mounted){
                          Dlg.showWarningSnackbar(context, value['message']);
                        }
                      } else if ( value['statusCode'] == 200 ){
                        if (context.mounted){
                          Dlg.showSnackbar(context, value['message']);
                        }
                      }
                    }
                  }).onError((error, stackTrace) {
                    if (context.mounted){
                      Dlg.showError(context, error.toString());
                    }
                  });
                },
                icon: const Icon(Icons.print)
                ),
                ],
                leading: IconButton(
                  onPressed: (){
                    scaffoldKey.currentState?.openDrawer();
                  },
                  icon: const Icon(Icons.menu)
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        DetalleArticuloPage(  model: model,),
                        UnidadMedidaArticuloPage( model: model,),
                        PreciosArticuloPage(  model: model ),
                        CompararArticuloPage( model: model, ),
                      ],
                    ),
                  ),
                  BarcodeWidget(model: model,),
                ],
              ),
              drawer: MenuDrawer(compania: widget.compania,),
            );

            }),
          ), 
        ),
      );
  }
}


