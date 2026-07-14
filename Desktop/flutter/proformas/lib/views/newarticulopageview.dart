import 'package:flutter/material.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/viewmodels/newarticuloviewmodel.dart';
import 'package:proformas/views/newdetallearticulopage.dart';
import 'package:proformas/views/newpreciosarticulopage.dart';
import 'package:proformas/views/newunidadmedidaarticulopage.dart';
import 'package:proformas/widgets/loadingwidget.dart';
import 'package:proformas/widgets/modelready.dart';
import 'package:provider/provider.dart';

class NewArticuloPageView extends StatefulWidget {
  const NewArticuloPageView({super.key,this.codigo });

  final String? codigo ;
  
  @override
  State<NewArticuloPageView> createState() => _NewArticuloPageViewState();
}

class _NewArticuloPageViewState extends State<NewArticuloPageView> with TickerProviderStateMixin{
  TabController? tabController ;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return ChangeNotifierProvider(
      create: (_) => NewArticuloViewModel(),
      child: ModelReady<NewArticuloViewModel>(
        onModelReady: (NewArticuloViewModel model)async {
          model.init(context, widget.codigo);
        },
        child: Consumer<NewArticuloViewModel>(builder:(context, model, child) {
          return Scaffold(
            appBar: AppBar(
              key: scaffoldKey,
              title: const Text('Nuevo artículo'),
              elevation: 0,
              bottom: TabBar(
                controller: tabController,
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
                ]
              ),
              actions: [
                Visibility(
                  visible: model.loadingContent == false,
                  child: IconButton(onPressed: () async {
                    await model.insertArticulo().onError((error, stackTrace){
                      if (context.mounted){
                        Dlg.showError(context, error.toString());
                      }
                    }).then((value) {
                      switch (value['statusCode']) {
                        case 201:
                          // En caso de que el articulo exista
                          Dlg.showInfo(context, value['message']);
                          break;
                        case 200:
                          // Si el articulo existe cerramos la ventana
                          Navigator.of(context).pop(model.articulo);
                          break;
                        default: return;
                      }
                    });
                  },
                  icon: const Icon(Icons.save_outlined)
                  ),
                )
              ],
            ),
            body: model.loadingContent == true ?  LoadingWidget( msj: model.msjLoading, ) :
            TabBarView(
              controller: tabController,
              children: [
                NewDetalleArticuloPage(  model: model,),
                NewUnidadMedidaArticuloPage( model: model,),
                NewPreciosArticuloPage(  model: model )
              ]
            ),
          );
          
        } ,), 
      ),
    );
  }
}