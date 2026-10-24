import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proformas/consts/globals.dart';
import 'package:proformas/models/bodega.dart';
import 'package:proformas/models/preproforma.dart';
import 'package:proformas/models/preproformadetalle.dart';
import 'package:proformas/models/usuario.dart';

class ProformaService {

  static final ProformaService _instance = ProformaService.internal();

  ProformaService.internal();

  factory ProformaService() => _instance ;


  Future<Map<String, dynamic>> addProforma( String baseUrl, PreProforma preProforma, List<PreProformaDetalle> preProformaDetalle, Usuario usuario, Bodega bodega ) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/addproforma');

    final Map<String, dynamic> params = preProforma.toMap();
    params['user'] = usuario.codUsuario;
    params['bodega'] = bodega.bodega;
    params['detalle_proforma'] = preProformaDetalle.map<Map<String, dynamic>>((e) => e.toMap()).toList();

    final resp = await http.post(
      url,
      body: jsonEncode( params ),
      headers: Globals.headers
    );

    if (resp.statusCode == 200) {

      final Map<String, dynamic>  decoded = jsonDecode(resp.body) ;

      return decoded;

    } else {
      return Future.error(resp.body);
    }     
  }

  Future<List<PreProformaDetalle>> getPreproformaDetalleById( String baseUrl, int id) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/detallepreproformabyid',
        {'id' : id.toString()});

    final resp = await http.get(
      url,
      headers: Globals.headers
    );

    if ( resp.statusCode == 200 ) {

      final Map<String, dynamic>  map = jsonDecode( resp.body ) ;
      final decoded = map['listado'] ;

      return decoded.map<PreProformaDetalle>((e) => PreProformaDetalle.fromMap(e)).toList();

    } else {

      return  Future.error(resp.body);
      
    }
  }

  Future<Map<String, dynamic>> insertItem( String baseUrl, Map<String, dynamic> data ) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/insertitem');

    final resp = await http.post(
      url,
      body: jsonEncode( data ),
      headers: Globals.headers
    );

    if ( resp.statusCode == 200 || resp.statusCode == 201 ) {

      final Map<String, dynamic> decoded = jsonDecode( resp.body );
      return decoded ;

    } else {

      return  Future.error(resp.body);
      
    }

  }

  Future<Map<String, dynamic>> updateItemCount( String baseUrl, int id, double cantidad, double total ) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/updateitemcount');

    final Map<String, dynamic> params = {
      'id' : id,
      'cantidad' : cantidad,
      'total' : total
    };

    final resp = await http.put(
      url,
      body: jsonEncode( params ),
      headers: Globals.headers
    );

    if ( resp.statusCode == 200 ) {

      final Map<String, dynamic> decoded = jsonDecode( resp.body );
      return decoded ;

    } else {

      return  Future.error(resp.body);

    }

  }

  Future<bool> deleteItem( String baseUrl, int id ) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/deleteitem');

    final Map<String, dynamic> params = {
      'id' : id,
    };

    final resp = await http.delete(
      url,
      body: jsonEncode( params ),
      headers: Globals.headers
    );

    if ( resp.statusCode == 200 ) {

      return true ;

    } else {

      return  Future.error(resp.body);

    }

  }

  Future<Map<String, dynamic>> setClienteToPreproforma( String baseUrl, PreProforma preProforma ) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/setclientetopreproforma');

  
    final resp = await http.put(
      url,
      body: jsonEncode( preProforma.toMap() ),
      headers: Globals.headers
    );

    if ( resp.statusCode == 200 ) {

      final Map<String, dynamic> decoded = jsonDecode( resp.body );
      return decoded ;

    } else {

      return  Future.error(resp.body);

    }

  }

  Future<Map<String, dynamic>> setTotales( String baseUrl, PreProforma preProforma ) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/settotales');

    final resp = await http.put(
      url,
      body: jsonEncode( preProforma.toMap() ),
      headers: Globals.headers
    );

    if ( resp.statusCode == 200 ) {

      final Map<String, dynamic> decoded = jsonDecode( resp.body );
      return decoded ;

    } else {

      return  Future.error(resp.body);

    }

  }

}