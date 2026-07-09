import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:proformas/services/helperservice.dart';
import 'package:proformas/viewmodels/articuloviewmodel.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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
        (model?.useBroadCast ?? false) && model?.receiver != null ?  BroadCastStreamBuilder(model: model,) : const SizedBox(),
      ],
    );
  }
}

class BroadCastStreamBuilder extends StatefulWidget {
  const BroadCastStreamBuilder({
    super.key,
    this.model
  });
  final ArticuloViewModel? model ;

  @override
  State<BroadCastStreamBuilder> createState() => _BroadCastStreamBuilderState();
}

class _BroadCastStreamBuilderState extends State<BroadCastStreamBuilder> {

  @override
  void initState() {
    widget.model?.receiver?.start();
    widget.model?.receiver?.messages.listen((data){

    });
    super.initState();
  }

  @override
  void dispose() {
    widget.model?.receiver?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BroadcastMessage>(
      initialData: null,
      stream: widget.model?.receiver?.messages,
      builder: ((context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            widget.model?.codigoController.text = snapshot.data?.data?['data'];
            widget.model?.findItem();
            return const SizedBox();

          case ConnectionState.none:
          case ConnectionState.done:
          case ConnectionState.waiting:
          return const SizedBox();
        }
      })
    );
  }
}