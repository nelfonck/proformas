import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proformas/models/compania.dart';
import 'package:proformas/models/proveedor.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/viewmodels/paparazziviewmodel.dart';
import 'package:proformas/views/buscarproveedorview.dart';
import 'package:proformas/views/configpaparazziview.dart';
import 'package:proformas/views/scanner_factura_view.dart';
import 'package:proformas/widgets/menudrawer.dart';
import 'package:proformas/widgets/modelready.dart';
import 'package:provider/provider.dart';

class PaparazziView extends StatefulWidget {
  const PaparazziView({super.key,required this.compania});

  final Compania compania;

  @override
  State<PaparazziView> createState() => _ResultadoScannerViewState();
}

class _ResultadoScannerViewState extends State<PaparazziView> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaparazziViewModel(),
      child: ModelReady<PaparazziViewModel>(
        onModelReady: (PaparazziViewModel model) async{

        },
        child: Consumer<PaparazziViewModel>(
          builder: ((context, model, child) {
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text('Escanear compra'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: ()  {

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ConfigPaparazziView()
                        )
                      );
                    
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear_all),
                    onPressed: () async{
                      bool confirmado = await Dlg.confirm(context, 'Desea para proceder con una nueva compra?');
                      if (confirmado){
                        model.clearAll();
                      }
                    },
                  ),
                ],
              ),
              body:Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text( model.selectedProveedor?.razsocial ?? 'CLICK AQUI PARA BUSCAR PROVEDOR'),
                      ),
                      onPressed: () async{ 
                        Proveedor? selected = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BuscarProveedorView()
                          )
                        );
                        if (selected!=null){
                          model.setSelectedProveedor(selected);
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    readOnly: model.bloquearCampo,
                    controller: model.consecutivoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Consecutivo factura'),
                      prefixIcon: IconButton(
                        onPressed: (){

                            model.setBloquearCampo(!model.bloquearCampo);
                  
                        }, 
                        icon: Icon( model.bloquearCampo ? Icons.lock : Icons.lock_open,)
                      ),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          final resultado = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ScannerFacturaView(),
                            ),
                          );
                          if (resultado!=null && resultado is String){

                            model.consecutivoController.text = resultado ;

                          }

                          model.setBloquearCampo(true);

                        }, 
                        icon: Icon(Icons.camera_alt)
                      )
                    ),
                  ),
                ),
                //fotos
                Expanded(
                  child: model.fotos.isEmpty
                  ? const Center(
                      child: Text('No hay fotos tomadas'),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: model.fotos.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                model.fotos[index],
                                fit: BoxFit.cover,
                              ),
                            ),
          
                          ],
                        );
                      },
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    onSubmitted: (value) async{
                      await checkCodeMethod(model, context);
                    },
                    controller: model.codigoController,
                    focusNode: model.codigoFocus,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hint: const Text('Código de barras'),
                      suffixIcon: IconButton(
                        onPressed: ()async{
                          await checkCodeMethod(model, context);
                        }, 
                        icon: Icon(Icons.send)
                      )
                    ),
                  ),
                )
                ],
              ),
              drawer:   MenuDrawer(compania: widget.compania,),
            );
            
          })
        )
      ),
    );
    
    
  }

  Future<void> checkCodeMethod(PaparazziViewModel model, BuildContext context) async {
    try {
      if (model.codigoController.text.isEmpty) return;
      final resp = await model.checkCode();
      if (resp!=null){
        if (resp['statusCode']==200){
          if (resp['tomar-foto']==true){
            await model.subirImagen();
          }else if (resp['tomar-foto']==false){
            if (context.mounted){
              model.cleanAndRequest();
              Dlg.showSnackbarDuration(context, '✅ Ok!!', 500);
            }
          }
        }
      }
    } catch (e) {
    
      if (e is String) {
        final data = jsonDecode(e);
    
        if (data['statusCode'] == 404) {
          if (context.mounted) {
            model.subirImagen();
          }
          return;
        }
      }
      if (context.mounted){
        Dlg.showError(
          context,
          e.toString().replaceFirst('Exception: ', ''),
        );
        
      }
    }
  }
}