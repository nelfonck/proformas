import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proformas/models/unidad.dart';
import 'package:proformas/models/unidadmedida.dart';
import 'package:proformas/services/helperservice.dart';
import 'package:proformas/viewmodels/newarticuloviewmodel.dart';

class NewUnidadMedidaArticuloPage extends StatelessWidget {
  const NewUnidadMedidaArticuloPage({Key? key, this.model }) : super(key: key);

  final NewArticuloViewModel? model ;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
          DropdownSearch<Unidad>(
            onChanged: (value){
              model?.articulo?.unidadEmpaque = value?.unidad ;
              model?.nL();
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
            items: model?.ud ?? [],
            selectedItem: model?.getLastUnidad() ,
            itemAsString: (item) => item.descripcion ?? '',
          ),
          const SizedBox(height: 10,),
          DropdownSearch<Unidad>(
            onChanged: (value){
              model?.articulo?.unidadVenta = value?.unidad ;
              model?.nL();
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
            items: model?.ud ?? [],
            selectedItem: model?.getLastUnidad() ,
            itemAsString: (item) => item.descripcion ?? '',
          ),
          const SizedBox(height: 10,),
          DropdownSearch<Unidad>(
            onChanged: (value){
              model?.articulo?.unidadCompra = value?.unidad ;
              model?.nL();
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
            items: model?.ud ?? [],
            selectedItem: model?.getLastUnidad(),
            itemAsString: (item) => item.descripcion ?? '',
          ),
          const SizedBox(height: 10,),
          DropdownSearch<UnidadMedida>(
            onChanged: (value){
              model?.articulo?.unidadMedida = value?.unidadMedida ;
              model?.nL();
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
            items: model?.um ?? [],
            selectedItem: model?.getLastUnidadMedida() ,
            itemAsString: (item) => item.descripcion ?? '',
          ),
          const SizedBox( height: 10, ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextField(
                  onTap: () {
                    HelperService.selectText( model?.volumenController );
                  },
                  onChanged: ( value ){
                    if ( value.isEmpty ){
                     model?.volumenController.text = '0';
                     model?.volumenController.selection =  TextSelection(
                      baseOffset: 0, 
                      extentOffset: model?.volumenController.text.length ?? 0,
                     );
                    }
                    var format = NumberFormat.decimalPattern('es');
                    double valorDecimal = value.isEmpty ? 0 : format.parse(value).toDouble();
                    
                    if ( model?.articulo != null ) {
                      model?.articulo?.volumen = valorDecimal;
                    }
                  },
                  controller: model?.volumenController,
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
                    HelperService.selectText( model?.pesoController );
                  },
                  onChanged: ( value ){
                    if ( value.isEmpty ){
                     model?.pesoController.text = '0';
                     model?.pesoController.selection =  TextSelection(
                      baseOffset: 0, 
                      extentOffset: model?.pesoController.text.length ?? 0,
                     );
                    }
                    var format = NumberFormat.decimalPattern('es');
                    double valorDecimal = value.isEmpty ? 0 : format.parse(value).toDouble();
                    
                    if ( model?.articulo != null ) {
                      model?.articulo?.peso = valorDecimal;
                    }
                  },
                  controller: model?.pesoController,
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
                    HelperService.selectText( model?.factorUnidadMedidaController );
                  },
                  onChanged: ( value ){
                    if ( value.isEmpty ){
                     model?.factorUnidadMedidaController.text = '0';
                     model?.factorUnidadMedidaController.selection =  TextSelection(
                      baseOffset: 0, 
                      extentOffset: model?.factorUnidadMedidaController.text.length ?? 0,
                     );
                    }
                    var format = NumberFormat.decimalPattern('es');
                    double valorDecimal = value.isEmpty ? 0 : format.parse(value).toDouble();
                    
                    if ( model?.articulo != null ) {
                      model?.articulo?.factorMedida = valorDecimal;
                    }
                  },
                  controller: model?.factorUnidadMedidaController,
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
          )
        ],
      ),
    );
  }
}