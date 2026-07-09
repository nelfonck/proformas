import 'package:flutter/material.dart';
import 'package:proformas/services/helperservice.dart';
import 'package:proformas/viewmodels/articuloviewmodel.dart';
import 'package:proformas/views/scannerpage.dart';

class BarcodeWidget extends StatelessWidget {
  const BarcodeWidget({
    super.key,
    this.model
  });

  final ArticuloViewModel? model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: TextField(
                  focusNode: model?.codigoFocusNode,
                  onTap: () {
                    HelperService.selectTextNoTime( model?.codigoController ); 
                  },
                  onSubmitted: (value) async {
                    model?.findItem();
                  },
                  controller: model?.codigoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Código',
                    suffixIcon: IconButton(
                      onPressed:() async {
                        model?.findItem();
                      }, 
                    icon: const Icon( Icons.arrow_circle_right )),
                  ),
                ),
              ),
              IconButton(
                onPressed:() async {
                  var res = await Navigator.of(context).push<String>(
                    MaterialPageRoute(
                      builder: ( context ) => const ScannerPage()
                    )
                  );
                  if ( res is String ){
                    if ( res.isEmpty ) return ;
                    if ( res == '-1' ) return ;
        
                    model?.codigoController.text = res ;
                    model?.findItem();
                  }
                }, 
                icon: const Icon( Icons.qr_code)
              ),
            ],
          ),
        ),
      ],
    );
  }
}
