import 'package:flutter/material.dart';
import 'package:proformas/models/articulo.dart';
import 'package:proformas/models/articulobloquemodel.dart';
import 'package:proformas/models/habladorhh.dart';
import 'package:proformas/providers/userprovider.dart';
import 'package:proformas/repositories/habladorhhrepository.dart';
import 'package:proformas/services/articuloservice.dart';
import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/habladorhhservice.dart';

import '../repositories/articulorepository.dart';

class HabladoresViewModel extends ChangeNotifier {
  UserProvider? _userProvider;
  final ConfigService _configService = ConfigService();
  TextEditingController? codigoController = TextEditingController();
  final ArticuloRepository _articuloRepository = ArticuloRepository(ArticuloService(), ConfigService());
  final HabladorHHRepository _habladorHHRepository = HabladorHHRepository(HabladorHHService(), ConfigService());
  bool? useBroadCast = false ;
  List<HabladorHh> habladores = [];
  BuildContext? _context;
  FocusNode focusNode = FocusNode() ; 
  bool _dispose = false;

  void init(BuildContext context,UserProvider userProvider, List<ArticuloBloque>? articulosBloque) async{
    _userProvider = userProvider;
    _context = context;
    await _configService.toConfig().then(((value) async {
      if ( value ){
        Navigator.of(context).pushReplacementNamed('config');
      } else {
        useBroadCast = _configService.getUseBroadcast();

        if (articulosBloque != null && articulosBloque.isNotEmpty) {
          final respInsertBloqToDb = await insertHabladorHHBloqToDb(articulosBloque);
          if (respInsertBloqToDb['statusCode']==200){
            //insertListFromArticulosBloqueToCurrentList(articulosBloque);
            await getHabladoresHH();
          }
        }else{
          await getHabladoresHH();
        }
        
      }
    }));
  }

  void insertListFromArticulosBloqueToCurrentList(List<ArticuloBloque> list){
    for (var element in list) {
      HabladorHh hh = _convertToHabladorHH(element.articuloMla);
      habladores.add(hh);
      notify();
     }
  }

  Future<dynamic> insertHabladorHHBloqToDb(List<ArticuloBloque> list)async{
    List<HabladorHh> habladorHHlist = list.map((e) => _convertToHabladorHH(e.articuloMla)).toList();
    Map<String,dynamic> respHabladorHH = await _habladorHHRepository.insertHabladorHHBloqToDb(_context!, habladorHHlist);
    return respHabladorHH;
  }


  Future<dynamic> deleteHablador(int index) async{
    int id = habladores[index].id!;
    Map<String,dynamic> resp = await _habladorHHRepository.deleteHablador(id);
    if ( resp['statusCode'] == 200 ){
      habladores.removeAt(index);
      notify();
    }
  }

  Future<dynamic> getArticulo(String? codigo) async {
    Map<String, dynamic> resp = await _articuloRepository.getArticulo(codigo);
    if ( resp['statusCode'] == 200 ){

      Articulo articulo = Articulo.fromMap( resp['articulo'] );
      HabladorHh tempHabladorHH = _convertToHabladorHH(articulo);

      if (!estaEnLaLista(articulo.codArticulo!)){
        
        Map<String, dynamic> respHabladorHH = await insertHabladorToDb(tempHabladorHH);

        if (respHabladorHH['statusCode'] == 200){

          HabladorHh habladorhh = HabladorHh.fromMap(respHabladorHH['hablador']);

          if (habladores.isEmpty){
            habladores.add(habladorhh);
          }else{
            habladores.insert(0,habladorhh);
          }
          codigoController?.text = '';
          focusNode.requestFocus();
          notify();
        } else if(respHabladorHH['statusCode'] == 201) {
          codigoController?.text = '';
          focusNode.requestFocus();
          return respHabladorHH;
        }
      }else{
          codigoController?.text = '';
          focusNode.requestFocus();
      }

    }
    return resp ;
  }

  bool estaEnLaLista(String codArticulo){
    for (var item in habladores) { 
      if (item.codArticulo == codArticulo){
        return true;
      }
    }
    return false;
  }

  Future<dynamic> insertHabladorToDb(HabladorHh hablador)async{
    Map<String,dynamic> respHabladorHH = await _habladorHHRepository.insertHabladorHHToDb(_context!, hablador);
    return respHabladorHH;
  }

  Future<dynamic> getHabladoresHH() async {
    Map<String, dynamic> resp = await _habladorHHRepository.getHabladoresHH(_context!);
    if (resp['statusCode'] == 200){
      habladores = resp['habladores'].map<HabladorHh>((e) => HabladorHh.fromMap(e)).toList();
      notify();
    }
  }

  Future<dynamic> moveListToQupos() async{
    Map<String,dynamic> resp = await _habladorHHRepository.moveListToQupos(habladores);
    if (resp['statusCode']==200){
      Map<String,dynamic> respDeleteList = await deleteListOnDb();
      if(respDeleteList['statusCode']==200){
        habladores.clear();
        notify();
      }
    }
    return resp;
  }

  Future<Map<String,dynamic>> deleteListOnDb() async{
    return  await _habladorHHRepository.deleteList(_context!);
  }

  HabladorHh _convertToHabladorHH(Articulo? articulo){
    return HabladorHh(
      codArticulo: articulo?.codArticulo,
      descripcion: articulo?.descripcion,
      creadoPor: _userProvider?.getUsuario()?.codUsuario,
      fechaCreacion: DateTime.now(),
      venta: articulo?.venta
    );
  } 
  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }

  void notify(){
    if (!_dispose){
      notifyListeners();
    }
  }
}