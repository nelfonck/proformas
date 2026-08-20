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
  }

  Future<bool?> saveParameters() async{
    final parameters = await SharedPreferences.getInstance();
    parameters.setString('ruta-facturas', routeController.text);
    return true;
  }

}