import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proformas/consts/globals.dart';
import 'package:proformas/models/cliente.dart';

class ClienteService {

  static final ClienteService _instance = ClienteService.internal();

  ClienteService.internal();  

  factory ClienteService() => _instance ;

  Future<List<Cliente>> getClientes( String baseUrl ) async {
    final url = Uri.http(baseUrl, '/utilitiesapi/public/clientes',
        {'api_key': Globals.apikey});

    final resp = await http.get(url);

    if (resp.statusCode == 200) {

      final Map<String, dynamic> map = jsonDecode(resp.body);
      final  decoded = map['clientes'];

      return decoded.map<Cliente>((e) => Cliente.fromMap(e)).toList();

    } else {
      return Future.error(resp.body);
    }     
  }
  Future<List<Cliente>> getClientesByRazonSocial( String baseUrl, String razonSocial ) async {
    final url = Uri.http(baseUrl, '/utilitiesapi/public/clientesbyrazonsocial',
        {'api_key': Globals.apikey, 'razon_social': razonSocial});

    final resp = await http.get(url);

    if (resp.statusCode == 200) {

      final Map<String, dynamic> map = jsonDecode(resp.body);
      final  decoded = map['clientes'];

      return decoded.map<Cliente>((e) => Cliente.fromMap(e)).toList();

    } else {
      return Future.error(resp.body);
    }     
  }

}