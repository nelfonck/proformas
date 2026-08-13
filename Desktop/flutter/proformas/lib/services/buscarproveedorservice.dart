import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proformas/consts/globals.dart';
import 'package:proformas/models/proveedor.dart';

class BuscarProveedorService {

  static final BuscarProveedorService _instance = BuscarProveedorService.internal();

  BuscarProveedorService.internal();  

  factory BuscarProveedorService() => _instance ;

  Future<List<Proveedor>> getProveedores( String baseUrl, String cliterio ) async {
    final url = Uri.http(baseUrl, '/utilitiesapi/public/proveedores',
        {
          'api_key': Globals.apikey,
          'cliterio' : cliterio
        });

    final resp = await http.get(url);

    if (resp.statusCode == 200) {

      final Map<String, dynamic> map = jsonDecode(resp.body);
      final  decoded = map['proveedores'];

      return decoded.map<Proveedor>((e) => Proveedor.fromJson(e)).toList();

    } else {
      return Future.error(resp.body);
    }     
  }
 
  
}