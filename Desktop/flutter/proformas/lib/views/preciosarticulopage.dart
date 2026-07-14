import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proformas/models/impuesto.dart';
import 'package:proformas/services/helperservice.dart';
import 'package:proformas/viewmodels/articuloviewmodel.dart';

class PreciosArticuloPage extends StatefulWidget {
  const PreciosArticuloPage({super.key,this.model });
  final ArticuloViewModel? model ;

  @override
  State<PreciosArticuloPage> createState() => _PreciosArticuloPageState();
}

class _PreciosArticuloPageState extends State<PreciosArticuloPage> {
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  onTap: () {
                    HelperService.selectText( widget.model?.costoController );
                  },
                  onChanged: ( value ){
                    if ( value.isEmpty ){
                    widget.model?.costoController.text = '0';
                    widget.model?.costoController.selection =  TextSelection(
                      baseOffset: 0, 
                      extentOffset: widget.model?.costoController.text.length ?? 0,
                    );
                    }
                    var format = NumberFormat.decimalPattern('es');
                    double valorDecimal = value.isEmpty ? 0 : format.parse(value).toDouble();
                    widget.model?.articulo?.costo = valorDecimal;
                    widget.model?.setVenta( valorDecimal ,  widget.model?.articulo?.porcentajeUtilidad ?? 0 , widget.model?.articulo?.impuesto?.porcentaje ?? 0);
                  },
                  controller: widget.model?.costoController,
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
                  HelperService.selectText( widget.model?.utilidadController );
                  },
                  onChanged: ( value ){
                    if ( value.isEmpty ){
                    widget.model?.utilidadController.text = '0';
                    widget.model?.utilidadController.selection =  TextSelection(
                      baseOffset: 0, 
                      extentOffset: widget.model?.utilidadController.text.length ?? 0,
                    );
                    }
                    var format = NumberFormat.decimalPattern('es');
                    double valorDecimal = value.isEmpty ? 0 : format.parse(value).toDouble();
                    widget.model?.articulo?.porcentajeUtilidad = valorDecimal;
                    widget.model?.setVenta( widget.model?.articulo?.costo ?? 0 , valorDecimal, widget.model?.articulo?.impuesto?.porcentaje ?? 0 );
                  },
                  controller: widget.model?.utilidadController,
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
                      widget.model?.articulo?.codImpuesto = value?.codImpuesto;
                      widget.model?.articulo?.impuesto = value ;
                      widget.model?.setVenta( widget.model?.articulo?.costo ?? 0 , widget.model?.articulo?.porcentajeUtilidad ?? 0, widget.model?.articulo?.impuesto?.porcentaje ?? 0);
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
                    items: widget.model?.impuestos ?? [],
                    selectedItem: widget.model?.articulo != null &&  widget.model?.articulo?.impuesto != null ? widget.model?.articulo?.impuesto : null ,
                    itemAsString: (item) => item.descripcion ?? '',
                  ),
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: TextField(
                  onTap: () {
                    HelperService.selectText( widget.model?.ventaController );
                  },
                  onChanged: (value){
                    if ( value.isEmpty ){
                    widget.model?.ventaController.text = '0';
                    widget.model?.ventaController.selection =  TextSelection(
                      baseOffset: 0, 
                      extentOffset: widget.model?.ventaController.text.length ?? 0,
                    );
                    }
                    var format = NumberFormat.decimalPattern('es');
                    double valorDecimal = value.isEmpty ? 0 : format.parse(value).toDouble();
                    widget.model?.articulo?.venta = valorDecimal;
                    widget.model?.setUtilidad( widget.model?.articulo?.costo ?? 0 , valorDecimal, widget.model?.articulo?.impuesto?.porcentaje ?? 0);
                  },
                  controller: widget.model?.ventaController,
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
                    HelperService.selectText( widget.model?.topeDescuento1Controller );
                  },
                  onChanged: (value){
                    if ( value.isEmpty ){
                    widget.model?.topeDescuento1Controller.text = '0';
                    widget.model?.topeDescuento1Controller.selection =  TextSelection(
                      baseOffset: 0, 
                      extentOffset: widget.model?.topeDescuento1Controller.text.length ?? 0,
                    );
                    }
                    var format = NumberFormat.decimalPattern('es');
                    double valorDecimal = value.isEmpty ? 0 : format.parse(value).toDouble();
                    widget.model?.articulo?.porcTopeDescuento1 = valorDecimal;
                  },
                  controller: widget.model?.topeDescuento1Controller,
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
                    HelperService.selectText( widget.model?.topeDescuento2Controller );
                  },
                  onChanged: (value){
                    if ( value.isEmpty ){
                    widget.model?.topeDescuento2Controller.text = '0';
                    widget.model?.topeDescuento2Controller.selection =  TextSelection(
                      baseOffset: 0, 
                      extentOffset: widget.model?.topeDescuento2Controller.text.length ?? 0,
                    );
                    }
                    var format = NumberFormat.decimalPattern('es');
                    double valorDecimal = value.isEmpty ? 0 : format.parse(value).toDouble();
                    widget.model?.articulo?.porcTopeDescuento2 = valorDecimal;
                  },
                  controller: widget.model?.topeDescuento2Controller,
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
                    HelperService.selectText( widget.model?.topeDescuento3Controller );
                  },
                  onChanged: (value){
                    if ( value.isEmpty ){
                    widget.model?.topeDescuento3Controller.text = '0';
                    widget.model?.topeDescuento3Controller.selection =  TextSelection(
                      baseOffset: 0, 
                      extentOffset: widget.model?.topeDescuento3Controller.text.length ?? 0,
                    );
                    }
                    var format = NumberFormat.decimalPattern('es');
                    double valorDecimal = value.isEmpty ? 0 : format.parse(value).toDouble();
                    widget.model?.articulo?.porcTopeDescuento3 = valorDecimal;
                  },
                  controller: widget.model?.topeDescuento3Controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tope desc 3'
                  ),
                )
              ),
            ],
          ),
        ],
      ),
    );
  }
}