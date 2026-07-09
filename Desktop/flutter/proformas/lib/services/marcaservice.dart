import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proformas/consts/globals.dart';

class MarcaService {

  static final MarcaService _instance = MarcaService.internal();

  MarcaService.internal();  

  factory MarcaService() => _instance ;

  Future<Map<String, dynamic>> getMarcas( String baseUrl ) async {
    final url = Uri.http(baseUrl, '/utilitiesapi/public/marcas',
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