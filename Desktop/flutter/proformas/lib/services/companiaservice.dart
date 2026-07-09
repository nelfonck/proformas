import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proformas/consts/globals.dart';
import 'package:proformas/models/compania.dart';

class CompaniaService {

  static final CompaniaService _instance = CompaniaService.internal();

  CompaniaService.internal();  

  factory CompaniaService() => _instance ;

  Future<Compania> getCompania( String baseUrl ) async {
    final url = Uri.http(baseUrl, '/utilitiesapi/public/compania',
        {'api_key': Globals.apikey});

    final resp = await http.get(url);

    if (resp.statusCode == 200) {

      final Map<String, dynamic> map = jsonDecode(resp.body);
      
      return Compania.fromMap(map['compania']);

    } else {
      return Future.error(resp.body);
    }     
  }
 
  
}