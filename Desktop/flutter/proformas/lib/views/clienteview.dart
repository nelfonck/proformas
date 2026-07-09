import 'package:flutter/material.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/viewmodels/clienteviewmodel.dart';
import 'package:proformas/widgets/modelready.dart';
import 'package:provider/provider.dart';

class ClienteView extends StatelessWidget {
  const ClienteView({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController txtClienteController = TextEditingController();

    return ChangeNotifierProvider(
      create: (_) => ClienteViewModel(),
      child: ModelReady<ClienteViewModel>(
        onModelReady: (ClienteViewModel model) async{
          model.init(context);
        },
        child: Consumer<ClienteViewModel>(
          builder: ((context, model, child) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: const Text('Clientes'),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: txtClienteController,
                      decoration:  InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Buscar cliente',
                        suffixIcon: IconButton(
                          onPressed: () async {
                            await model.getClientesByRazonSocial( txtClienteController.text ).onError((error, stackTrace) {
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
                  const Divider(),
                  Body(model: model,),
                ],
              ),
            );
          })
        ), 
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    Key? key,
    required this.model
  }) : super(key: key);

  final ClienteViewModel model ;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: model.clientes.length,
        itemBuilder: ((context, index) {
          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(top: 3), 
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: (){
                  Navigator.of(context).pop(model.clientes[index]);
                },
                contentPadding: const EdgeInsets.only(left: 0),
                dense: true,
                title: Text( model.clientes[index].razonSocial ?? '' )  ,
              ),
            ),
          );
        })
      ),
    );
  }
}