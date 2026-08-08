import 'package:flutter/material.dart';
import 'package:proformas/models/proveedor.dart';
import 'package:proformas/viewmodels/paparazziviewmodel.dart';
import 'package:proformas/views/buscarproveedorview.dart';
import 'package:proformas/views/scanner_factura_view.dart';
import 'package:proformas/widgets/modelready.dart';
import 'package:provider/provider.dart';

class ResultadoScannerView extends StatefulWidget {
  const ResultadoScannerView({super.key});

  @override
  State<ResultadoScannerView> createState() => _ResultadoScannerViewState();
}

class _ResultadoScannerViewState extends State<ResultadoScannerView> {

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
              appBar: AppBar(
                title: Text('Paparazzi'),
                actions: [
                
                  IconButton(
                    icon: const Icon(Icons.one_k),
                    onPressed: ()  {

                      model.setMostrarProductoEncontrado(true);
                    
                    },
                  ),
                ],
              ),
              body: 
              Column(
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
                    
                ],
              )
            
            );
            
          })
        )
      ),
    );
    
    
  }
}