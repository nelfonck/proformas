import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proformas/consts/globals.dart';

class FamiliaService {

  static final FamiliaService _instance = FamiliaService.internal();

  FamiliaService.internal();  

  factory FamiliaService() => _instance ;

  Future<Map<String, dynamic>> getFamilias( String baseUrl ) async {
    final url = Uri.http(baseUrl, '/utilitiesapi/public/familias',
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