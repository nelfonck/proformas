import 'package:flutter/material.dart';
import 'package:proformas/repositories/rotacionrepository.dart';
import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/helperservice.dart';
import 'package:proformas/services/rotacionservice.dart';

class Rotacionviewmodel extends ChangeNotifier{
  final TextEditingController codigoController = TextEditingController();
  final codigoFocus = FocusNode();

  DateTime? fechaDesde;
  DateTime? fechaHasta;
  String descripcion = '';
  double salidas = 0;
  bool _disposed = false;

  final Rotacionrepository _repository = Rotacionrepository(RotacionService(), ConfigService());

  Future<void> init()async{
    fechaDesde = HelperService.firstDayOfMonth(DateTime.now());
    fechaHasta = DateTime.now();
    codigoFocus.requestFocus();
    safeNotify();
  }

  Future<Map<String,dynamic>> getSalida() async{
    if (codigoController.text.isEmpty) return {};

    Map<String,dynamic> resp = await _repository.getSalida(codigoController.text, fechaDesde!, fechaHasta!);
    if (resp['statusCode']==200){
      descripcion = resp['articulo']['descripcion'];
      salidas = double.tryParse(
        resp['articulo']['salidas']?.toString() ?? '0'
      ) ?? 0.0;
      clearTxt();
    }
    return resp;
  }

  void clearTxt()async{
    codigoController.clear();
    codigoFocus.requestFocus();
    safeNotify();
  }

  bool validar(){
    if (codigoController.text.isEmpty){
      return false;
    }
    if (fechaDesde == null){
      return false;
    }
    if (fechaHasta == null){
      return false;
    }
    return true;
  } 


  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }


  void  safeNotify(){
    if (!_disposed){
      notifyListeners();
    }
  }


}