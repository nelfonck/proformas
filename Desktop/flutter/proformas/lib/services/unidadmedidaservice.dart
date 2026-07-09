import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proformas/consts/globals.dart';

class UnidadMedidaService {

  static final UnidadMedidaService _instance = UnidadMedidaService.internal();

  UnidadMedidaService.internal();  

  factory UnidadMedidaService() => _instance ;

  Future<Map<String, dynamic>> getUnidadesMedida( String baseUrl ) async {
    final url = Uri.http(baseUrl, '/utilitiesapi/public/unidadesmedida',
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