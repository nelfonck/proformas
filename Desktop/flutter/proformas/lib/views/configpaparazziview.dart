import 'package:flutter/material.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/viewmodels/configpaparazziviewmodel.dart';
import 'package:proformas/widgets/modelready.dart';
import 'package:provider/provider.dart';

class ConfigPaparazziView extends StatelessWidget {
  const ConfigPaparazziView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConfigPaparazziviewModel(),
      child: ModelReady<ConfigPaparazziviewModel>(
        onModelReady: (ConfigPaparazziviewModel model) async {
          await model.init();
        },
        child: Consumer<ConfigPaparazziviewModel>(builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Paparazzi parameters'),
              actions: [
                IconButton(
                  onPressed: ()async{
                    bool? guardar = await model.saveParameters();
                    if (guardar??false){
                      if (context.mounted){
                        Dlg.showSnackbar(context, 'Parametros guardados!!');
                      }
                    }
                  }, 
                  icon: Icon(Icons.save)
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    const SizedBox(height: 20,),
                    TextField(
                      controller: model.routeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ruta de alojamiento de facturas xml',
                        hint: Text('Ej: \\\\10.147.18.3\\FacturasPendientes')
                      ),
                    ),
                  ]
                ),
              ),
            )
          );
        },
        ), 
      ),
    );
  }
}