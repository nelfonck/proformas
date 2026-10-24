import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proformas/consts/globals.dart';

class UnidadService {

  static final UnidadService _instance = UnidadService.internal();

  UnidadService.internal();  

  factory UnidadService() => _instance ;

  Future<Map<String, dynamic>> getUnidades( String baseUrl ) async {
    final url = Uri.http(baseUrl, '/utilitiesapi/public/unidades');

    final resp = await http.get(url, headers: Globals.headers);

    if (resp.statusCode == 200) {

      final Map<String, dynamic> map = jsonDecode(resp.body);
     
      return map ;

    } else {
      return Future.error(resp.body);
    }     
  }
 
  
}