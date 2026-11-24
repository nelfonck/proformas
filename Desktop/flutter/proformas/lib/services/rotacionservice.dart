import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:proformas/consts/globals.dart';

class RotacionService {

  static final RotacionService _instance = RotacionService.internal();

  RotacionService.internal();

  factory RotacionService() => _instance ;



  Future<Map<String,dynamic>> getSalida( String baseUrl, String codigo, DateTime ini, DateTime end ) async {
    final f = DateFormat('yyyy-MM-dd');

    final url = Uri.http(baseUrl, '/utilitiesapi/public/salida');

    Map<String, dynamic> params = {
      'codigo' : codigo,
      'ini': f.format(ini),
      'end': f.format(end)
    };

    final resp = await http.post(
      url,
      body: jsonEncode(params),
      headers: Globals.headers
    );

    if (resp.statusCode == 200) {

      final Map<String, dynamic>  decoded = jsonDecode(resp.body) ;

      return decoded;

    } else {
      return Future.error(resp.body);
    }     
  }

}