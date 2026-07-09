import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proformas/consts/globals.dart';

class ImpuestoService {

  static final ImpuestoService _instance = ImpuestoService.internal();

  ImpuestoService.internal();  

  factory ImpuestoService() => _instance ;

  Future<Map<String, dynamic>> getImpuestos( String baseUrl ) async {
    final url = Uri.http(baseUrl, '/utilitiesapi/public/impuestos',
        {'api_key': Globals.apikey});

    final resp = await http.get(url);

    if (resp.statusCode == 200) {

      final Map<String, dynamic> map = jsonDecode(resp.body);

      return map ;

    } else {
      return Future.error(resp.body);
    }     
  }
 
  
}