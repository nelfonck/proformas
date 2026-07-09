import 'package:flutter/material.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/viewmodels/articuloviewmodel.dart';
import 'package:proformas/widgets/modelready.dart';
import 'package:provider/provider.dart';

class FiltroArticuloView extends StatelessWidget {
  const FiltroArticuloView({Key? key, this.model }) : super(key: key);
  final ArticuloViewModel? model ;

  @override
  Widget build(BuildContext context) {
  TextEditingController txtFiltroController = TextEditingController();
    return ChangeNotifierProvider(
      create: (_) => ArticuloViewModel(),
      child: ModelReady<ArticuloViewModel>(
        onModelReady: (ArticuloViewModel model) async{
          model.init(context);
        },
        child: Consumer<ArticuloViewModel>(
          builder: (context, model, child){
            return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: TextField(
                controller: txtFiltroController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  isDense: true,
                  hintText: 'Escribe una palabra a buscar',
                  filled: true,
                  fillColor: Colors.white, 
                  suffixIcon: IconButton(
                    onPressed: () async{
                      await model.getArticulosByDescription(txtFiltroController.text).onError((error, stackTrace) {
                        if (context.mounted){
                          Dlg.showError(context, error.toString());
                        }
                      });
                    }, 
                    icon: const Icon(Icons.search)
                  )
                ),
              ),
              
            ),
            body: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: model.articuloList.length,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(model.articuloList[index].codArticulo);
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
                          Text( model.articuloList[index].descripcion! )
                        ],
                      ),
                    ),
                  ),
                );
              })
            ),
          );
          },
        ), 
      ),
    );
    
  }
}