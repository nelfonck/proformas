import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigPaparazziviewModel extends ChangeNotifier{

  TextEditingController routeController = TextEditingController();

  Future<void> init() async{
    await loadParameters();
  }

  Future<void> loadParameters() async{
    final parameters = await SharedPreferences.getInstance();
    routeController.text = parameters.getString('ruta-facturas') ?? '';
    if (routeController.text == ''){
      routeController.text = '\\\\10.147.18.3\\Compartida\\Paparazzi' ;
    }
  }

  Future<bool?> saveParameters() async{
    final parameters = await SharedPreferences.getInstance();
    parameters.setString('ruta-facturas', routeController.text);
    return true;
  }

}