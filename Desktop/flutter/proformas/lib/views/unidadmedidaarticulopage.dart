import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proformas/models/unidad.dart';
import 'package:proformas/models/unidadmedida.dart';
import 'package:proformas/services/helperservice.dart';
import 'package:proformas/viewmodels/articuloviewmodel.dart';

class UnidadMedidaArticuloPage extends StatefulWidget { 
  const UnidadMedidaArticuloPage({Key? key, this.model }) : super(key: key);

  final ArticuloViewModel? model ;

  @override
  State<UnidadMedidaArticuloPage> createState() => _UnidadMedidaArticuloPageState();
}

class _UnidadMedidaArticuloPageState extends State<UnidadMedidaArticuloPage> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const  EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min ,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
          DropdownSearch<Unidad>(
            onChanged: (value){
              widget.model?.articulo?.unidadEmpaque = value?.unidad ;
              widget.model?.nL();
            },
            enabled: true,
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Unidad almacenaje",
                )
            ),
            compareFn: (i, s) => i.descripcion!.contains(s.descripcion!),
            popupProps: const PopupPropsMultiSelection.dialog(
              isFilterOnline: true,
              showSelectedItems: true,
              showSearchBox: true,
            ),
            items: widget.model?.ud ?? [],
            selectedItem: widget.model?.articulo != null  ? widget.model?.getUnidadByCodigo( widget.model?.articulo?.unidadEmpaque ) : null ,
            itemAsString: (item) => item.descripcion ?? '',
          ),
          const SizedBox(height: 10,),
          DropdownSearch<Unidad>(
            onChanged: (value){
              widget.model?.articulo?.unidadVenta = value?.unidad ;
              widget.model?.nL();
            },
            enabled: true,
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Unidad venta",
                )
            ),
            compareFn: (i, s) => i.descripcion!.contains(s.descripcion!),
            popupProps: const PopupPropsMultiSelection.dialog(
              isFilterOnline: true,
              showSelectedItems: true,
              showSearchBox: true,
            ),
            items: widget.model?.ud ?? [],
            selectedItem: widget.model?.articulo != null  ? widget.model?.getUnidadByCodigo( widget.model?.articulo?.unidadVenta ) : null ,
            itemAsString: (item) => item.descripcion ?? '',
          ),
          const SizedBox(height: 10,),
          DropdownSearch<Unidad>(
            onChanged: (value){
              widget.model?.articulo?.unidadCompra = value?.unidad ;
              widget.model?.nL();
            },
            enabled: true,
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Unidad compra",
                )
            ),
            compareFn: (i, s) => i.descripcion!.contains(s.descripcion!),
            popupProps: const PopupPropsMultiSelection.dialog(
              isFilterOnline: true,
              showSelectedItems: true,
              showSearchBox: true,
            ),
            items: widget.model?.ud ?? [],
            selectedItem: widget.model?.articulo != null  ? widget.model?.getUnidadByCodigo( widget.model?.articulo?.unidadCompra ) : null ,
            itemAsString: (item) => item.descripcion ?? '',
          ),
          const SizedBox(height: 10,),
          DropdownSearch<UnidadMedida>(
            onChanged: (value){
              widget.model?.articulo?.unidadMedida = value?.unidadMedida ;
              widget.model?.nL();
            },
            enabled: true,
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Unidad medida",
                )
            ),
            compareFn: (i, s) => i.descripcion!.contains(s.descripcion!),
            popupProps: const PopupPropsMultiSelection.dialog(
              isFilterOnline: true,
              showSelectedItems: true,
              showSearchBox: true,
            ),
            items: widget.model?.um ?? [],
            selectedItem: widget.model?.articulo != null  ? widget.model?.getUnidadMedidaByCodigo( widget.model?.articulo?.unidadMedida ) : null ,
            itemAsString: (item) => item.descripcion ?? '',
          ),
          const SizedBox( height: 10, ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextField(
                  onTap: () async {

                    HelperService.selectText( widget.model?.volumenController );
                  },
                  onChanged: ( value ){
                    if ( value.isEmpty ){
                    widget.model?.volumenController.text = '0';
                    widget.model?.volumenController.selection =  TextSelection(
                      baseOffset: 0, 
                      extentOffset: widget.model?.volumenController.text.length ?? 0,
                    );
                    }
                    var format = NumberFormat.decimalPattern('es');
                    double valorDecimal = value.isEmpty ? 0 : format.parse(value).toDouble();
                    
                    if ( widget.model?.articulo != null ) {
                      widget.model?.articulo?.volumen = valorDecimal;
                    }
                  },
                  controller: widget.model?.volumenController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Volumen (cm3)'
                  ),
                )
              ),
              const SizedBox( width: 10,),
              Expanded(
                child: TextField(
                  onTap: () {
                    HelperService.selectText( widget.model?.pesoController );
                  },
                  onChanged: ( value ){
                    if ( value.isEmpty ){
                    widget.model?.pesoController.text = '0';
                    widget.model?.pesoController.selection =  TextSelection(
                      baseOffset: 0, 
                      extentOffset: widget.model?.pesoController.text.length ?? 0,
                    );
                    }
                    var format = NumberFormat.decimalPattern('es');
                    double valorDecimal = value.isEmpty ? 0 : format.parse(value).toDouble();
                    
                    if ( widget.model?.articulo != null ) {
                      widget.model?.articulo?.peso = valorDecimal;
                    }
                  },
                  controller: widget.model?.pesoController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Peso (g)'
                  ),
                )
              )
            ],
          ),
          const SizedBox( height: 10, ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: TextField(
                  onTap: () {
                    HelperService.selectText( widget.model?.factorUnidadMedidaController );
                  },
                  onChanged: ( value ){
                    if ( value.isEmpty ){
                    widget.model?.factorUnidadMedidaController.text = '0';
                    widget.model?.factorUnidadMedidaController.selection =  TextSelection(
                      baseOffset: 0, 
                      extentOffset: widget.model?.factorUnidadMedidaController.text.length ?? 0,
                    );
                    }
                    var format = NumberFormat.decimalPattern('es');
                    double valorDecimal = value.isEmpty ? 0 : format.parse(value).toDouble();
                    
                    if ( widget.model?.articulo != null ) {
                      widget.model?.articulo?.factorMedida = valorDecimal;
                    }
                  },
                  controller: widget.model?.factorUnidadMedidaController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Factor unidad medida'
                  ),
                ),
              ),
              const Expanded(
                flex: 1,
                child: SizedBox(),
              )
            ],
          ),
        ],
      ),
    );
  }
}