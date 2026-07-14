import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proformas/models/impuesto.dart';
import 'package:proformas/services/helperservice.dart';
import 'package:proformas/viewmodels/newarticuloviewmodel.dart';

class NewPreciosArticuloPage extends StatelessWidget {
  const NewPreciosArticuloPage({super.key, this.model });

  final NewArticuloViewModel? model ;

  @override
  Widget build(BuildContext context) { 
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  onTap: () {
                    HelperService.selectText( model?.costoController );
                  },
                  onChanged: ( value ){
                    if ( value.isEmpty ){
                     model?.costoController.text = '0';
                     model?.costoController.selection =  TextSelection(
                      baseOffset: 0, 
                      extentOffset: model?.costoController.text.length ?? 0,
                     );
                    }
                    var format = NumberFormat.decimalPattern('es');
                    double valorDecimal = value.isEmpty ? 0 : format.parse(value).toDouble();
                    model?.articulo?.costo = valorDecimal;
                    model?.setVenta( valorDecimal ,  model?.articulo?.porcentajeUtilidad ?? 0 , model?.articulo?.impuesto?.porcentaje ?? 0 );
                  },
                  controller: model?.costoController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Costo'
                  ),
                )
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: TextField(
                  onTap: () {
                   HelperService.selectText( model?.utilidadController );
                  },
                  onChanged: ( value ){
                    if ( value.isEmpty ){
                     model?.utilidadController.text = '0';
                     model?.utilidadController.selection =  TextSelection(
                      baseOffset: 0, 
                      extentOffset: model?.utilidadController.text.length ?? 0,
                     );
                    }
                    var format = NumberFormat.decimalPattern('es');
                    double valorDecimal = value.isEmpty ? 0 : format.parse(value).toDouble();
                    model?.articulo?.porcentajeUtilidad = valorDecimal;
                    model?.setVenta( model?.articulo?.costo ?? 0, valorDecimal, model?.articulo?.impuesto?.porcentaje ?? 0 );
                  },
                  controller: model?.utilidadController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Utilidad'
                  ),
                )
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: DropdownSearch<Impuesto>(
                    onChanged:(value) {
                      model?.articulo?.codImpuesto = value?.codImpuesto;
                      model?.articulo?.impuesto = value ;
                      model?.setVenta( model?.articulo?.costo ?? 0 , model?.articulo?.porcentajeUtilidad ?? 0, model?.articulo?.impuesto?.porcentaje ?? 0 );
                    },
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Impuesto",
                        )
                    ),
                    compareFn: (i, s) => i.descripcion!.contains(s.descripcion!),
                    popupProps: const PopupPropsMultiSelection.dialog(
                      isFilterOnline: true,
                      showSelectedItems: true,
                      showSearchBox: true,
                    ),
                    items: model?.impuestos ?? [],
                    selectedItem: model?.articulo != null &&  model?.articulo?.impuesto != null ? model?.articulo?.impuesto : null ,
                    itemAsString: (item) => item.descripcion ?? '',
                  ),
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: TextField(
                  onTap: () {
                    HelperService.selectText( model?.ventaController );
                  },
                  onChanged: (value){
                    if ( value.isEmpty ){
                     model?.ventaController.text = '0';
                     model?.ventaController.selection =  TextSelection(
                      baseOffset: 0, 
                      extentOffset: model?.ventaController.text.length ?? 0,
                     );
                    }
                    var format = NumberFormat.decimalPattern('es');
                    double valorDecimal = value.isEmpty ? 0 : format.parse(value).toDouble();
                    model?.articulo?.venta = valorDecimal;
                    model?.setUtilidad( model?.articulo?.costo ?? 0 , valorDecimal, model?.articulo?.impuesto?.porcentaje ?? 0);
                  },
                  controller: model?.ventaController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Venta'
                  ),
                )
              )
            ],
          ),
          const SizedBox( height: 20.0, ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onTap: () {
                    HelperService.selectText( model?.topeDescuento1Controller );
                  },
                  onChanged: (value){
                    if ( value.isEmpty ){
                     model?.topeDescuento1Controller.text = '0';
                     model?.topeDescuento1Controller.selection =  TextSelection(
                      baseOffset: 0, 
                      extentOffset: model?.topeDescuento1Controller.text.length ?? 0,
                     );
                    }
                    var format = NumberFormat.decimalPattern('es');
                    double valorDecimal = value.isEmpty ? 0 : format.parse(value).toDouble();
                    model?.articulo?.porcTopeDescuento1 = valorDecimal;
                  },
                  controller: model?.topeDescuento1Controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tope desc 1'
                  ),
                )
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: TextField(
                  onTap: () {
                    HelperService.selectText( model?.topeDescuento2Controller );
                  },
                  onChanged: (value){
                    if ( value.isEmpty ){
                     model?.topeDescuento2Controller.text = '0';
                     model?.topeDescuento2Controller.selection =  TextSelection(
                      baseOffset: 0, 
                      extentOffset: model?.topeDescuento2Controller.text.length ?? 0,
                     );
                    }
                    var format = NumberFormat.decimalPattern('es');
                    double valorDecimal = value.isEmpty ? 0 : format.parse(value).toDouble();
                    model?.articulo?.porcTopeDescuento2 = valorDecimal;
                  },
                  controller: model?.topeDescuento2Controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tope desc 2'
                  ),
                )
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: TextField(
                  onTap: () {
                    HelperService.selectText( model?.topeDescuento3Controller );
                  },
                  onChanged: (value){
                    if ( value.isEmpty ){
                     model?.topeDescuento3Controller.text = '0';
                     model?.topeDescuento3Controller.selection =  TextSelection(
                      baseOffset: 0, 
                      extentOffset: model?.topeDescuento3Controller.text.length ?? 0,
                     );
                    }
                    var format = NumberFormat.decimalPattern('es');
                    double valorDecimal = value.isEmpty ? 0 : format.parse(value).toDouble();
                    model?.articulo?.porcTopeDescuento3 = valorDecimal;
                  },
                  controller: model?.topeDescuento3Controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tope desc 3'
                  ),
                )
              ),
            ],
          )
        ],
      ),
    );
  }
}