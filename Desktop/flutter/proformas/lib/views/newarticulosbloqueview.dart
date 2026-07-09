import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proformas/data/exceptions/api_exception.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/viewmodels/articulosbloqueviewmodel.dart';
import 'package:proformas/views/habladoresview.dart';
import 'package:proformas/widgets/modelready.dart';
import 'package:provider/provider.dart';

class NewArticulosBloqueView extends StatefulWidget {
  const NewArticulosBloqueView({Key? key, }) : super(key: key);

  @override
  State<NewArticulosBloqueView> createState() => _NewArticulosBloqueViewState();
}

class _NewArticulosBloqueViewState extends State<NewArticulosBloqueView> {
  @override
  Widget build(BuildContext context) {
    NumberFormat format = NumberFormat.decimalPattern('es');
    
    return ChangeNotifierProvider(
      create: (_) => ArticulosBloqueViewModel(),
      child: ModelReady(
        onModelReady: (ArticulosBloqueViewModel model) async {
          model.init(context);
        },
        child: Consumer<ArticulosBloqueViewModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Ingresar en bloque') ,
            elevation: 0,
            actions: [
              Visibility(
                visible: model.list.isNotEmpty,
                child: IconButton(
                  onPressed: (){
                    if (model.listaIngresadaEnQupos()){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HabladoresView(
                            articulosBloque: model.list,
                          ),
                        ),
                      );    
                    }else{
                      Dlg.showWarning(context, 'Hay articulos para ingresar \nhaz click en ingresar todo antes de continuar con su impresion..');
                    }
                  }, 
                  icon: const Icon(Icons.print)
                ),
              ),
              Visibility(
                visible: model.list.isNotEmpty,
                child: IconButton(
                  onPressed: ()async{
                    if (model.list.isEmpty){
                      Dlg.showWarningSnackbar(context, 'La lista está vacia');
                      return;
                    } else if (!model.listaIngresadaEnQupos()){
                      bool resp = await Dlg.confirm(context, 'Hay articulos para ingresar, \n seguro(a) que desea limpiar la lista?');
                      if (resp){
                        if(context.mounted){
                          model.clearList(context);
                        }
                      }
                    } else if (model.listaIngresadaEnQupos()){
                      model.clearList(context);
                    }
                  }, 
                  icon: const Icon(Icons.clear_all)
                ),
              ),
              Visibility(
                visible: model.list.isNotEmpty,
                child: IconButton(
                  icon: Icon(!model.listaIngresadaEnQupos() ? Icons.playlist_add : Icons.playlist_add_check),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async{
                    try {
                      if (!model.listaIngresadaEnQupos()){
                        final data = await model.ingresarListaEnQupos(context);
                      
                        if (!mounted) return;
                        if (data['statusCode']==200){
                          if (context.mounted){
                            Dlg.showInfo(context, data['message']);
                          }
                        }
                      }else{
                        Dlg.showSnackbar(context, 'Nada que ingresar por ahora');
                      }
                    } on ApiException catch (e) {
                      if (context.mounted){
                        Dlg.showError(context,"❌ API ERROR ${e.statusCode}: ${e.message}");
                      }
                    } catch (e) {
                      if (context.mounted){
                        Dlg.showError(context,"❌ ERROR GENERAL: $e");
                      }
                    }
                  },
                ),
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(height: 1,),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(5),
                color: Colors.blue,
                child: const Text('Lista de articulos para ingresar',style: TextStyle(color: Colors.white,),)
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: model.list.length,
                  itemBuilder: (((context, index) {
                    return Dismissible(
                      key: Key(model.list[index].codigo.toString()) ,
                      direction: DismissDirection.startToEnd,
                      onDismissed: (DismissDirection direction) async {
                        if (DismissDirection.startToEnd == direction){
                          model.deleteItem(index, context);
                        }
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
                        color: !model.list[index].ingresado! ? Colors.blueGrey : Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: Text(model.list[index].codigo ?? '', style: const TextStyle(color: Colors.white,),)
                              ),
                              const SizedBox(width: 10,),
                              Text(model.list[index].descripcion ?? '' , style:  const TextStyle(color: Colors.white,),),
                              Expanded(child: Container(),),
                              const SizedBox(width: 10,),
                              Text('₡ ${format.format(model.list[index].articuloMla?.venta ?? 0)}' , style: const TextStyle(color: Colors.white,),),
                            ],
                          ),
                        )
                      ),
                    );
                  }))
                )
              ),
              Padding(
                padding:  const EdgeInsets.all(8.0),
                child:  TextField(
                  focusNode: model.codigoFocus,
                  controller: model.txtCodigoController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Inserta el codigo de barras y preciona Enter'
                  ),
                  onSubmitted: (value) async{
                    if (model.estaEnLista(value)){
                      Dlg.showWarningSnackbar(context, 'El artículo ya está en la lista');
                      model.limpiarTxt(); 
                      return;
                    }
                    await model.getArticulo(context,value);
                    model.limpiarTxt();
                  },
                ),
              ),
            ],
          ),
          
        );
          
        },), 
      ),
    );
  }
}