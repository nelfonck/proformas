import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:proformas/helpers/helpers.dart';
import 'package:proformas/models/articulo.dart';
import 'package:proformas/models/articulobloquemodel.dart';
import 'package:proformas/repositories/articulobloquerepository.dart';
import 'package:proformas/repositories/articulorepository.dart';
import 'package:proformas/services/articulosbloqueservice.dart';
import 'package:proformas/services/articuloservice.dart';
import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/notificationservice.dart';

class ArticulosBloqueViewModel extends ChangeNotifier{
  bool _isDisposed = false;
  List<ArticuloBloque> list = [] ;
  TextEditingController txtCodigoController = TextEditingController();
  FocusNode codigoFocus = FocusNode();

  final ArticuloRepository _repository = ArticuloRepository(ArticuloService(), ConfigService()); 
  final ArticuloBloqueRepository _articuloBloqueRepository = ArticuloBloqueRepository(ArticuloBloqueService(), ConfigService()); 
  
  void init(BuildContext context){
    limpiarTxt();
    hiveRestoreList(context); 
  }

  Future<dynamic> getArticulo(BuildContext context,String codigo) async {

    Map<String, dynamic> resp = await _repository.getArticulo(codigo);

    if ( resp['statusCode'] == 200 ){
      if (!_isDisposed){
      // ignore: use_build_context_synchronously
      Dlg.showSnackbarDuration(context, 'El articulo existe',200);
      }
    } else   if ( resp['statusCode'] == 201 ){
      //Si no existe entonces lo consultamos en el super central
      if (!_isDisposed){
      // ignore: use_build_context_synchronously
      await getArticuloMla(context,codigo);
      }
    } 

    return resp ;

  }

  Future<dynamic> getArticuloMla(BuildContext context,String codigo) async {

    Map<String, dynamic> resp = await _repository.getArticulomla(codigo);

    if ( resp['statusCode'] == 200 ){
      //Si existe el articulo en el central obtenerlo 
      Articulo articulo = Articulo.fromMap(resp['articulo']);
      ArticuloBloque articuloBloque = ArticuloBloque(
        codigo: articulo.codArticulo,
        descripcion: articulo.descripcion,
        ingresado: false,
        articuloMla: articulo
      );
      //anadir a la lista para posterior mente ingresarlo
      list.insert(0,articuloBloque);
      safeNotify();
      if (!_isDisposed){
        // ignore: use_build_context_synchronously
        hiveSaveList(context);
      }
    } else   if ( resp['statusCode'] == 201 ){
      //Dejo esto ya que si no existe en el central hacer algo aca no se
      if(!_isDisposed){
        // ignore: use_build_context_synchronously
        Dlg.showInfo(context, 'Artículo no ingresado en el central');
      }
    } 

    return resp ;
  }

  Future<Map<String, dynamic>> ingresarListaEnQupos(BuildContext context) async{

    Map<String, dynamic> resp = await _articuloBloqueRepository.ingresarListaEnQupos(list);

    if ( resp['statusCode'] == 200 ){
      if (!_isDisposed){
        // ignore: use_build_context_synchronously
        setListaIngresadaState(context);
      }
    } 
    return resp;
  }

  bool estaEnLista(String codigo){
    for (ArticuloBloque element in list) {
      if (element.codigo == codigo){
        return true;
      }
     }
     return false;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }


  Future<void> hiveSaveList(BuildContext context) async {
    final hivebox = Hive.box('hivebox');

    try {
      final listMap = list.map((e) {
        try {
          return e.toMap();
        } catch (err) {
          Dlg.showError(context,"Error serializando item: $err");
          return null;
        }
      }).where((e) => e != null).toList();

      await hivebox.put('list', listMap);
    } catch (e) {
      if (!context.mounted) return;
      Dlg.showError(context,"Error guardando en Hive: $e");
    }
  }

  void hiveRestoreList(BuildContext context) {
    var hivebox = Hive.box('hivebox');

    try {
      final data = hivebox.get('list');

      if (data is List) {
        list = data.map((e) {
          try {
            return ArticuloBloque.fromMap(Map<String,dynamic>.from(Helpers.castMap(e)));
          } catch (err) {
            Dlg.showError(context,"Error item: $err");
            return null;
          }
        }).where((e) => e != null).whereType<ArticuloBloque>().toList();
      } else {
        list = [];
      }
    } catch (e) {
      Dlg.showError(context,"Error general Hive: $e");
      list = [];
    }

    safeNotify();
  }

  void setListaIngresadaState(BuildContext context){
    for (var element in list) {
      element.ingresado = true;
     }
     safeNotify();
     hiveSaveList(context);
  }

  void limpiarTxt(){
    txtCodigoController.clear();
    codigoFocus.requestFocus();
  }

  bool listaIngresadaEnQupos(){
    for (var element in list) { 
      if (!element.ingresado!) return false;
    }
    return true;
  }

  void clearList(BuildContext context){
    if(list.isNotEmpty){
      list.clear();
      safeNotify();
      hiveSaveList(context);
    }
  }

  void deleteItem(int index, BuildContext context){
    if(list.isNotEmpty){
      list.removeAt(index);
      safeNotify();
      hiveSaveList(context);
    }
  }

  void safeNotify(){
    if(!_isDisposed){
      notifyListeners();
    }
  }
}