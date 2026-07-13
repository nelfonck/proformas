import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proformas/consts/globals.dart';
import 'package:proformas/models/bodega.dart';
import 'package:proformas/models/usuario.dart';
import 'package:proformas/providers/userprovider.dart';
import 'package:provider/provider.dart';

class UsuarioService {

  static final UsuarioService _instance = UsuarioService.internal();

  UsuarioService.internal();  

  factory UsuarioService() => _instance ;

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

  Future<Map<String, dynamic>?> getUsuario( String baseUrl, String user, String pass ) async {
    final url = Uri.http(baseUrl, '/utilitiesapi/public/usuario',
        {'api_key': Globals.apikey});

    final Usuario usuario = Usuario(
      codUsuario: user,
      clave: pass
    );

    final resp = await http.post(
      url,
      body: jsonEncode( usuario.toMap() ),
      headers: Globals.headers
    );

    if ( resp.statusCode == 200 || resp.statusCode == 201 ) {

      final Map<String, dynamic> map = jsonDecode(resp.body);

      return map ;

    } else {
      return Future.error(resp.body);
    }     
  }

  Future<Map<String, dynamic>> existeAccion(BuildContext context, String baseUrl, String codAccion ) async {

    UserProvider user = Provider.of<UserProvider>(context, listen: false);

    final url = Uri.http(baseUrl, '/utilitiesapi/public/existeaccion',
        {'api_key': Globals.apikey});

    Map<String,dynamic> params = {
      'cod_usuario': user.getUsuario()?.codUsuario,
      'cod_accion': codAccion
    };

    final resp = await http.post(
      url,
      body: jsonEncode( params ),
      headers: Globals.headers
    );

    if ( resp.statusCode == 200 || resp.statusCode == 201 ) {

      final Map<String, dynamic> map = jsonDecode(resp.body);

      return map ;

    } else {
      return Future.error(resp.body);
    }     
  }
 

}