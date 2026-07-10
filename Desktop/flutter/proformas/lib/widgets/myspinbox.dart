import 'package:flutter/material.dart';
import 'package:proformas/services/helperservice.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/viewmodels/preproformaviewmodel.dart';

class MySpinBox extends StatelessWidget {
  const  MySpinBox({
    super.key, 
    required this.model,
    required this.widht, 
    required this.height, 
    required this.border, 
    required this.index,
    this.focusNode,
    required this.send
  });

  final PreProformaViewModel? model ;
  final double? widht;
  final double? height;
  final bool? border;
  final int? index; // -1 to ignore list and use value to put a new row
  final FocusNode? focusNode;
  final bool? send ;

  @override
  Widget build(BuildContext context) {
    TextEditingController txtController = TextEditingController(text: index == -1 ? model?.cantidad.toString(): model?.preProformaDetalle[index!].cantidad.toString() );
    return SizedBox(
      width: widht,
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: FocusScope(
              onFocusChange: (focus) {
                HelperService.selectTextNoTime(txtController);
              },
              child: TextField(
                controller:txtController,
                focusNode: focusNode,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onTap: () {
                  HelperService.selectTextNoTime(txtController);
                },
                onSubmitted: (value) async{

                  if ( index ==-1 ){

                    if (model?.enviadaQupos() ?? false){
                      Dlg.showWarningSnackbar(context, 'Esta pre-proforma ya fue enviada a Qupos');
                      return;
                    }

                    if (!(model?.isInList( model?.txtCodigoController.text ) ?? false)){
                      model?.setCantidad( double.parse(value) );
                      //insert item 
                      await model?.insertItem(model!.cantidad!, model!.txtCodigoController.text )
                      .then((value) {
                        if ( value['statusCode'] == 201 ){
                          if (context.mounted){
                            Dlg.showInfo(context, value['message']);
                          }
                        } else if ( value['statusCode'] == 202 ){
                          if (context.mounted){
                            Dlg.showWarning(context, value['message']);
                          }
                        }
                      })
                      .onError((error, stackTrace) {
                        if (context.mounted){
                           Dlg.showError(context, error.toString());
                        }
                      });

                      model?.txtCodigoController.text = '';
                        if ( !(model?.useBroadCast ?? false) ){
                          model?.focusNode.requestFocus();
                        }
                      model?.setCantidad(1); 
                    } else {
                      //update row
                      await model?.updateItemCont( double.parse( txtController.text ) , model!.txtCodigoController.text )
                        .then((resp) {
                          if ( resp['statusCode'] == 202 ){
                            if (context.mounted){
                              Dlg.showWarning(context, resp['message']);
                            }
                          }
                        }).onError((error, stackTrace) {
                          if (context.mounted){
                             Dlg.showError(context, error.toString());
                          }
                        });
                    
                      model?.txtCodigoController.text = '';
                      if ( !(model?.useBroadCast ?? false) ){
                        model?.focusNode.requestFocus();
                      }
                      model?.setCantidad(1);
                    }     

                  } else {

                    if (model?.enviadaQupos() ?? false){
                      Dlg.showWarningSnackbar(context, 'Esta pre-proforma ya fue enviada a Qupos');
                      txtController.text = model?.preProformaDetalle[index!].cantidad.toString() ?? '';
                      return;
                    }

                    await model?.updateRow( model!.preProformaDetalle[index!].id!, double.parse(value) ).then((value) {
                      if ( value['statusCode'] == 202 ){
                        if (context.mounted){
                          Dlg.showWarning(context, value['message']);
                          txtController.text = model?.preProformaDetalle[index!].cantidad.toString() ?? '';
                        }
                      }
                    }).onError((error, stackTrace) {
                      if (context.mounted){
                        Dlg.showError(context, error.toString());
                      }
                    });
                  }
                },
                decoration:  InputDecoration(
                  border: !(border ?? false) ?  InputBorder.none : const UnderlineInputBorder(),
                  prefixIcon: IconButton(
                    onPressed: () async{

                      if (model?.enviadaQupos() ?? false){
                        Dlg.showWarningSnackbar(context, 'Esta pre-proforma ya fue enviada a Qupos');
                        return;
                      }

                      if ( index==-1 ){
                        model?.setCantidad( model!.cantidad = model!.cantidad! - 1 );
                      } else {
                        await model?.updateRow( model!.preProformaDetalle[index!].id!, model!.preProformaDetalle[index!].cantidad = model!.preProformaDetalle[index!].cantidad! - 1 );
                      }
                    }, 
                    icon: const Icon(Icons.remove)
                  ),
                  suffixIcon: IconButton(
                    onPressed: ()async{

                      if (model?.enviadaQupos() ?? false){
                        Dlg.showWarningSnackbar(context, 'Esta pre-proforma ya fue enviada a Qupos');
                        return;
                      }

                      if ( index==-1 ){
                        model?.setCantidad( model!.cantidad! + model!.cantidad! +1 );
                      } else {
                        await model?.updateRow( model!.preProformaDetalle[index!].id!, model!.preProformaDetalle[index!].cantidad = model!.preProformaDetalle[index!].cantidad! + 1 );
                      }
                    }, 
                    icon: const Icon(Icons.add)
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: send ?? false,
            child: IconButton(onPressed: () async {

              if (model?.txtCodigoController == null ) return;
              if ( model!.txtCodigoController.text.isEmpty) return ;
              if ( txtController.text == '' ) return;

              if (model?.enviadaQupos() ?? false){
                Dlg.showWarningSnackbar(context, 'Esta pre-proforma ya fue enviada a Qupos');
                return;
              }
            
              if ( model?.isInList( model?.txtCodigoController.text ) ?? false){
            
               await model?.updateItemCont( double.parse( txtController.text ) , model?.txtCodigoController.text )
                .then((resp) {
                  if ( resp['statusCode'] == 202 ){
                    if (context.mounted){
                      Dlg.showWarning(context, resp['message']);
                    }
                  }
                }).onError((error, stackTrace) {
                  if (context.mounted){
                   Dlg.showError(context, error.toString());
                  }
                });
            
                model?.txtCodigoController.text = '';
                    if ( !(model?.useBroadCast ?? false) ){
                      model?.focusNode.requestFocus();
                    }
                    model?.setCantidad(1);
              
              } else {
            
                final Map<String, dynamic> resp = await model?.insertItem( double.parse( txtController.text ), model!.txtCodigoController.text ).onError((error, stackTrace) {
                   if (context.mounted){
                    Dlg.showError(context, error.toString());
                   }
                });
            
                if ( resp['statusCode'] == 201 ){
            
                  // ignore: use_build_context_synchronously
                  Dlg.showInfo(context, resp['message']);
                
                } else if ( resp['statusCode'] == 202 ){
                  
                  // ignore: use_build_context_synchronously
                  Dlg.showWarning(context, resp['message']);
                }
            
                  model?.txtCodigoController.text = '';
                    if ( !(model?.useBroadCast ?? false) ){
                      model?.focusNode.requestFocus();
                    }
                    model?.setCantidad(1);
              
              }
            
            }, icon: const Icon(Icons.send),  color: Colors.grey),
          ),
        ],
      ),
    );
  }
}