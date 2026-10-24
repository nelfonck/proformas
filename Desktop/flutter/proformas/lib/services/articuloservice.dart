import 'dart:convert';
import 'package:context_holder/context_holder.dart';
import 'package:http/http.dart' as http;
import 'package:proformas/consts/globals.dart';
import 'package:proformas/models/articulo.dart';
import 'package:proformas/providers/userprovider.dart';
import 'package:provider/provider.dart';

class ArticuloService {

  static final ArticuloService _instance = ArticuloService.internal();

  ArticuloService.internal();  

  factory ArticuloService() => _instance ;

  Future<Map<String, dynamic>> getArticulo( String baseUrl, String? codigo ) async {
    final url = Uri.http(baseUrl, '/utilitiesapi/public/articulo',
        {
          'codigo': codigo
        }
    );

    final resp = await http.get(url,headers: Globals.headers);

    if (resp.statusCode == 200) {

      final Map<String, dynamic> mapResp = jsonDecode(resp.body);
      
      return mapResp;

    } else {
      return Future.error(resp.body);
    }     
  }

  Future<Map<String, dynamic>> getArticulosByDescription( String baseUrl, String txt ) async {
    final url = Uri.http(baseUrl, '/utilitiesapi/public/articulosbydescripcion');

    Map<String,dynamic> params = {
      'descripcion': txt
    };

    final resp = await http.post(
      url,
      body: jsonEncode(params),
      headers: Globals.headers
    );

    if (resp.statusCode == 200) {

      return jsonDecode(resp.body);

    } else {
      return Future.error(resp.body);
    }     
  }

  Future<Map<String, dynamic>> getArticulomla( String baseUrl, String codigo ) async {
    final url = Uri.http(baseUrl, '/utilitiesapi/public/articulomla',
        {
          'codigo': codigo
        }
    );

    final resp = await http.get(url,headers: Globals.headers);

    if (resp.statusCode == 200) {

      final Map<String, dynamic> mapResp = jsonDecode(resp.body);
      
      return mapResp;

    } else {
      return Future.error(resp.body);
    }     
  }

  Future<Map<String, dynamic>> updateArticulo(String baseUrl, Articulo articulo ) async {
    final url = Uri.http(baseUrl, '/utilitiesapi/public/updatearticulo');

    Map<String, dynamic> params = {
      'articulo' : articulo.toMap()
    };

    final resp = await http.put(
      url,
      body: jsonEncode( params ),
      headers: Globals.headers
    );

    if ( resp.statusCode == 200 ){

      return jsonDecode( resp.body );
    } else {

      return Future.error(resp.body);
    }
  } 

  Future<Map<String, dynamic>> insertArticulo(String baseUrl, Articulo articulo ) async {
    UserProvider user = Provider.of ( ContextHolder.currentContext, listen: false );

    final url = Uri.http(baseUrl, '/utilitiesapi/public/insertarticulo');

    Map<String, dynamic> params = {
      'articulo' : articulo.toMap(),
      'user': user.getUsuario()?.toMap()
    };

    final resp = await http.post(
      url,
      body: jsonEncode( params ),
      headers: Globals.headers
    );

    if ( resp.statusCode == 200 ){

      return jsonDecode( resp.body );
    } else {

      return Future.error(resp.body);
    }
  } 

  Future<Map<String,dynamic>> insertarHablador(String baseUrl,  String codArticulo ) async{
    UserProvider user = Provider.of ( ContextHolder.currentContext, listen: false );
    
    Map<String,dynamic> params = {
      'cod_articulo' : codArticulo,
      'creado_por'   : user.getUsuario()?.codUsuario
    };

    final url = Uri.http(baseUrl, '/utilitiesapi/public/insertarhablador');

    final resp = await http.post(
      url,
      body: jsonEncode( params ),
      headers: Globals.headers
    );

    if ( resp.statusCode == 200 || resp.statusCode == 201 ){

      return jsonDecode( resp.body );
    } else {

      return Future.error(resp.body);
    }
  }
 
  
}