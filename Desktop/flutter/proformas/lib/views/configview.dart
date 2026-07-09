import 'package:flutter/material.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/viewmodels/configviewmodel.dart';
import 'package:proformas/widgets/modelready.dart';
import 'package:provider/provider.dart';

class ConfigView extends StatelessWidget {
  const ConfigView({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController hostController = TextEditingController();
    TextEditingController portController = TextEditingController();
    TextEditingController broadCastLinkController = TextEditingController();

    return ChangeNotifierProvider(
      create: (_) => ConfigViewModel(),
      child: ModelReady<ConfigViewModel>(
        onModelReady: (ConfigViewModel model) async{
          model.init(context, hostController, portController, broadCastLinkController);
        },
        child: Consumer<ConfigViewModel>(builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Configuracion'),
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () async {
                    if ( model.validarText(hostController.text, portController.text) ){
                      await model.setConfig( hostController.text, portController.text, broadCastLinkController.text)
                      .onError((error, stackTrace) {
                        if (context.mounted){
                          Dlg.showError(context, error.toString());
                        }
                      })
                      .then((value) {
                        if (context.mounted){
                          Navigator.of(context).pushReplacementNamed('login');
                        }
                      });
                    } else {
                      Dlg.showError(context, 'Hay campos de textos vacios');
                    }
                  },
                  icon: const Icon(Icons.save)
                )
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  const SizedBox(height: 20,),
                  TextField(
                    controller: hostController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Host'
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                    controller: portController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Port'
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: (){
                            Dlg.showInfo(context, 'Pendiente de implementar');
                      },
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.green)
                      ),
                      child: const Text('Probar conexion', style: TextStyle(color: Colors.white),)
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Usar broadcast'),
                      Switch(
                        value: model.useBroadCast ?? false,
                        onChanged: (value) {
                          model.setUseBroadcast(value);
                        }
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                    autofocus: true,
                    controller: broadCastLinkController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'BroadCastReceiver Link'
                    ),
                  ),
                  const SizedBox(height: 20,),
                ],
              ),
            ),
          );

        },), 
      ),
    );
  }
}