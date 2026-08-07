import 'package:flutter/material.dart';
import 'package:proformas/views/scanner_factura_view.dart';
import 'package:proformas/widgets/productoencontradowidget.dart';

class ResultadoScannerView extends StatefulWidget {
  const ResultadoScannerView({super.key});

  @override
  State<ResultadoScannerView> createState() => _ResultadoScannerViewState();
}

class _ResultadoScannerViewState extends State<ResultadoScannerView> {
  TextEditingController  consecutivoController = TextEditingController();
  bool mostrarProductoEncontrado = false; 
  bool bloquearCampo = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paparazzi'),
        actions: [
         
          IconButton(
            icon: const Icon(Icons.one_k),
            onPressed: ()  {

              setState(() {
                mostrarProductoEncontrado = true;
              });
              
            },
          ),
        ],
      ),
      body: 
      Stack(
      children: [
        // Tu pantalla normal
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            readOnly: bloquearCampo,
            controller: consecutivoController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Consecutivo factura'),
              prefixIcon: IconButton(
                onPressed: (){
                  setState(() {
                    bloquearCampo = !bloquearCampo;
                  });
                }, 
                icon: Icon( bloquearCampo ? Icons.lock : Icons.lock_open,)
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

                    consecutivoController.text = resultado ;

                  }
                  setState(() {
                    bloquearCampo = true;
                  });
                }, 
                icon: Icon(Icons.camera_alt)
              )
            ),
          ),
        ),
            
        if (mostrarProductoEncontrado)
          ProductoEncontradoAnimation(
            onFinish: () {
              if (mounted) {
                setState(() {
                  mostrarProductoEncontrado = false;
                });
              }
            },
          ),
        ],
      )
    
    );
  }
}