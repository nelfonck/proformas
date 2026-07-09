import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proformas/consts/globals.dart';
import 'package:proformas/models/bodega.dart';

class BodegaService {

  static final BodegaService _instance = BodegaService.internal();

  BodegaService.internal();  

  factory BodegaService() => _instance ;

  Future<List<Bodega>> getBodegas( String baseUrl ) async {
    final url = Uri.http(baseUrl, '/utilitiesapi/public/bodegas',
        {'api_key': Globals.apikey});

    final resp = await http.get(url);

    if (resp.statusCode == 200) {

      final Map<String, dynamic> map = jsonDecode(resp.body);
      final  decoded = map['bodegas'];

      return decoded.map<Bodega>((e) => Bodega.fromMap(e)).toList();

    } else {
      return Future.error(resp.body);
    }     
  }
 
  
}