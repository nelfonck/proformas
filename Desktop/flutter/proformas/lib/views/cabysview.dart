import 'package:flutter/material.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/viewmodels/cabyviewmodel.dart';
import 'package:proformas/widgets/modelready.dart';
import 'package:provider/provider.dart';

class CabysView extends StatelessWidget {
  const CabysView({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CabyViewModel(),
      child: ModelReady<CabyViewModel>(
        onModelReady: (CabyViewModel model) async{
          model.init();
        },
        child: Consumer<CabyViewModel>(
          builder: ((context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Buscar codigos cabys'),
              leading: IconButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back)
              ),
              elevation: 0,
            ),
            body: Container(
              padding: const EdgeInsets.symmetric( horizontal: 5.0, vertical: 10.0 ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextField(
                    controller: model.cabysController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Palabra clave',
                      labelText: 'Cabys',
                      suffixIcon: IconButton(
                        onPressed: () async {
                          if ( model.cabysController.text.isEmpty ){
                            Dlg.showWarning(context, 'Debe digitar una palabra a buscar');
                            return ;
                          }
                          Dlg.showLoading(context, 'Obteniendo codigos cabys');
                          await model.getCabys( model.cabysController.text ).onError((error, stackTrace) {
                            //Close the loading Dialog
                            if (context.mounted){
                              Navigator.of(context).pop();
                              Dlg.showError(context, error.toString());
                            }
                          }).then((value) {
                            if (context.mounted){
                              Navigator.of(context).pop();
                            }
                          });
                        },
                        icon: const Icon(Icons.search)
                      )
                    ),
                  ),
                  const SizedBox( height: 5, ),
                  Expanded(
                    child:  model.cabys.cabys?.isEmpty ?? false ?
                    const Center(
                      child:  Text('No data to display'),
                    ):
                    ListView.builder(
                      itemCount: model.cabys.cabys?.length,
                      itemBuilder: ( (context, index) {
                        return GestureDetector(
                          onTap: (){
                            Navigator.of(context).pop( model.cabys.cabys![index] );
                          },
                          child: Card(
                            elevation: 0.5,
                            margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.symmetric( horizontal: 10, vertical: 15 ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text( model.cabys.cabys?[index].codigo ?? '' ),
                                    const SizedBox(width: 10),
                                    Text( model.cabys.cabys?[index].descripcion ?? '' ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                    ),
                  )
                ],
              ),
            ),
          );

          }),
        ), 
      ),
    );
  }
}