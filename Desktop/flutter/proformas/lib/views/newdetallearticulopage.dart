import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:proformas/models/cabys.dart';
import 'package:proformas/models/familia.dart';
import 'package:proformas/models/impuesto.dart';
import 'package:proformas/models/marca.dart';
import 'package:proformas/services/helperservice.dart';
import 'package:proformas/viewmodels/newarticuloviewmodel.dart';
import 'package:proformas/views/cabysview.dart';

class NewDetalleArticuloPage extends StatelessWidget {
  const NewDetalleArticuloPage({Key? key, this.model }) : super(key: key);

  final NewArticuloViewModel? model ;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column( 
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextField(
            onChanged: ( value ){
              model?.articulo?.codArticulo = value;
            },
            controller: model?.codigoController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Código'
            ),
          ),
          const SizedBox(height: 10,),
          TextField(
            onChanged: ( value ){
              model?.articulo?.descripcion = value;
            },
            controller: model?.descripcionController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Descripción'
            ),
          ),
          const SizedBox(height: 10,),
          DropdownSearch<Familia>(
            onChanged: ( value ){
              model?.articulo?.codFamilia = value?.codFamilia;
              model?.articulo?.familia = value;
            },
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Familia",
                )
            ),
            compareFn: (i, s) => i.descripcion!.contains(s.descripcion!),
            popupProps: const PopupPropsMultiSelection.dialog(
              isFilterOnline: true,
              showSelectedItems: true,
              showSearchBox: true,
            ),
            items: model?.familias?? [],
            selectedItem: model?.articulo != null &&  model?.articulo?.familia != null ? model?.articulo?.familia : null ,
            itemAsString: (item) => item.descripcion ?? '',
          ),
          const SizedBox(height: 10,),
          DropdownSearch<Marca>(
            onChanged: ( value ){
              model?.articulo?.codMarca = value?.codMarca;
              model?.articulo?.marca = value;
            },
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Marca",
                )
            ),
            compareFn: (i, s) => i.descripcion!.contains(s.descripcion!),
            popupProps: const PopupPropsMultiSelection.dialog(
              isFilterOnline: true,
              showSelectedItems: true,
              showSearchBox: true,
            ),
            items: model?.marcas ?? [],
            selectedItem: model?.articulo != null &&  model?.articulo?.marca != null ? model?.articulo?.marca : null ,
            itemAsString: (item) => item.descripcion ?? '',
          ),
          const SizedBox(height: 10,),
          TextField(
            readOnly: true,
            controller: model?.cabysController,
            decoration:  InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Cabys',
              labelText: 'Cabys',
              suffixIcon: IconButton(onPressed:() async {

                Caby? caby = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: ( context ) => const CabysView()
                  )
                );

                if ( caby != null ){
                  if ( model?.articulo != null ){
                    model?.articulo?.codCabys = caby.codigo;
                    model?.cabysController.text = caby.codigo ?? '';
                    model?.setCodigoImpuestoCabysByImp( caby.impuesto );
                  }
                }

              },
              icon: const Icon(Icons.search)
            )
            ),
          ),
          const SizedBox(height: 10,),
          DropdownSearch<Impuesto>(
            onChanged: ( value ) {
              model?.articulo?.codImpuestoCabys = value?.codImpuesto;
            },
            enabled: false,
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Impuesto cabys",
                )
            ),
            compareFn: (i, s) => i.descripcion!.contains(s.descripcion!),
            popupProps: const PopupPropsMultiSelection.dialog(
              isFilterOnline: true,
              showSelectedItems: true,
              showSearchBox: true,
            ),
            items: model?.impuestos ?? [],
            selectedItem: model?.articulo != null  ? model?.getImpuestoByCodigo( model?.articulo?.codImpuestoCabys ) : null ,
            itemAsString: (item) => item.descripcion ?? '',
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Aplica inventario'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: model?.articulo != null ? HelperService.charToBool(model?.articulo?.aplicaInventario): false, 
                        onChanged: (value){
                          if ( model?.articulo != null ){
                            model?.articulo?.aplicaInventario = HelperService.boolToChar(value);
                            model?.nL();
                          }
                        }
                      )
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Artículo a granel'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: model?.articulo != null ? HelperService.charToBool( model?.articulo?.artGranel ) : false, 
                        onChanged: (value){
                          if ( model?.articulo != null ){
                            model?.articulo?.artGranel = HelperService.boolToChar(value);
                            model?.nL();
                          }
                        }
                      )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Habilita cambio de precio'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: model?.articulo != null ? HelperService.charToBool( model?.articulo?.habilitarCambiarPrecio ) : false, 
                        onChanged: (value){
                          if ( model?.articulo != null ){
                            model?.articulo?.habilitarCambiarPrecio = HelperService.boolToChar(value);
                            model?.nL();
                          }
                        }
                      )
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Artículo de control'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: model?.articulo != null ? HelperService.charToBool( model?.articulo?.artControl ) : false, 
                        onChanged: (value){
                          if ( model?.articulo != null ){
                            model?.articulo?.artControl = HelperService.boolToChar(value);
                            model?.nL();
                          }
                        }
                      )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Permite venta unitaria'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: model?.articulo != null ? HelperService.charToBool( model?.articulo?.permiteVentaUnitaria ) : false, 
                        onChanged: (value){
                          if ( model?.articulo != null ){
                            model?.articulo?.permiteVentaUnitaria = HelperService.boolToChar(value);
                            model?.nL();
                          }
                        }
                      )
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Artículo de romana'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: model?.articulo != null ? HelperService.charToBool( model?.articulo?.articuloRomana ) : false, 
                        onChanged: (value){
                          if ( model?.articulo != null ){
                            model?.articulo?.articuloRomana = HelperService.boolToChar(value);
                            model?.nL();
                          }
                        }
                      )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Articulo pesado automatico'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: model?.articulo != null ? HelperService.charToBool( model?.articulo?.pesadoAutomatico ) : false, 
                        onChanged: (value){
                          if ( model?.articulo != null ){
                            model?.articulo?.pesadoAutomatico = HelperService.boolToChar(value);
                            model?.nL();
                          }
                        }
                      )
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Venta libre'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: model?.articulo != null ? HelperService.charToBool( model?.articulo?.ventaLibre ) : false, 
                        onChanged: (value){
                          if ( model?.articulo != null ){
                            model?.articulo?.ventaLibre = HelperService.boolToChar(value);
                            model?.nL();
                          }
                        }
                      )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Servicio de salud'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: model?.articulo != null ? HelperService.charToBool( model?.articulo?.servicioSalud ) : false, 
                        onChanged: (value){
                          if ( model?.articulo != null ){
                            model?.articulo?.servicioSalud = HelperService.boolToChar(value);
                            model?.nL();
                          }
                        }
                      )
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Bonificación'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: model?.articulo != null ? HelperService.charToBool( model?.articulo?.bonificacion ) : false, 
                        onChanged: (value){
                          if ( model?.articulo != null ){
                            model?.articulo?.bonificacion = HelperService.boolToChar(value);
                            model?.nL();
                          }
                        }
                      )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Artículos relacionados activos'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: model?.articulo != null ? HelperService.charToBool( model?.articulo?.activarArticulosRelacionados ) : false, 
                        onChanged: (value){
                          if ( model?.articulo != null ){
                            model?.articulo?.activarArticulosRelacionados = HelperService.boolToChar(value);
                            model?.nL();
                          }
                        }
                      )
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Genera comandas'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: model?.articulo != null ? HelperService.charToBool( model?.articulo?.aplicaComandas ) : false, 
                        onChanged: (value){
                          if ( model?.articulo != null ){
                            model?.articulo?.aplicaComandas = HelperService.boolToChar(value);
                            model?.nL();
                          }
                        }
                      )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Artículo relacionado agrupado'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: model?.articulo != null ? HelperService.charToBool( model?.articulo?.articuloRelacionadoAgrupador ) : false, 
                        onChanged: (value){
                          if ( model?.articulo != null ){
                            model?.articulo?.articuloRelacionadoAgrupador = HelperService.boolToChar(value);
                            model?.nL();
                          }
                        }
                      )
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Aplica timbre odontológico'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: model?.articulo != null ? HelperService.charToBool( model?.articulo?.aplicaTimbreOdontologico ) : false, 
                        onChanged: (value){
                          if ( model?.articulo != null ){
                            model?.articulo?.aplicaTimbreOdontologico = HelperService.boolToChar(value);
                            model?.nL();
                          }
                        }
                      )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Artículo e-commerce'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: model?.articulo != null ? false : false, //No lo encontre
                        onChanged: (value){
                          if ( model?.articulo != null ){
                            //model.articulo.habilitarCambiarPrecio = model.boolToChar(value);
                            //model.nL();
                          }
                        }
                      )
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Solicita N.serie'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: model?.articulo != null ? HelperService.charToBool( model?.articulo?.articuloConSerie ) : false, 
                        onChanged: (value){
                          if ( model?.articulo != null ){
                            model?.articulo?.articuloConSerie = HelperService.boolToChar(value);
                            model?.nL();
                          }
                        }
                      )
                    ),
                  ],
                ),
                ],
              )
            ),
          )
        ],
      ),
    );
  }
}