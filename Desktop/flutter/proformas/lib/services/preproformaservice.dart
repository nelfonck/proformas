import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proformas/consts/globals.dart';
import 'package:proformas/models/preproforma.dart';
import 'package:proformas/models/preproformadetalle.dart';

class PreProformaService {

  static final PreProformaService _instance = PreProformaService.internal();

  PreProformaService.internal();

  factory PreProformaService() => _instance ;

  Future<List<PreProforma>> getPreProformas( String baseUrl ) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/preproformas',
        {'api_key': Globals.apikey});

    final resp = await http.get(url);

    if (resp.statusCode == 200) {

      final Map<String, dynamic> map = jsonDecode(resp.body);
      final  decoded = map['listado'];

      return decoded.map<PreProforma>((e) => PreProforma.fromMap(e)).toList();

    } else {
      return Future.error(resp.body);
    }     
  }

  Future<List<PreProforma>> getPreProformasByDate( String baseUrl, DateTime from, DateTime to ) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/preproformasbydate',
        {'api_key': Globals.apikey});

    final Map<String, dynamic> params = {
      'from': from.toString(),
      'to' : to.toString()
    };

    final resp = await http.post(
      url,
      body: jsonEncode( params ),
      headers: Globals.headers
    );

    if (resp.statusCode == 200) {

      final Map<String, dynamic> map = jsonDecode(resp.body);
      final  decoded = map['listado'];

      return decoded.map<PreProforma>((e) => PreProforma.fromMap(e)).toList();

    } else {
      return Future.error(resp.body);
    }     
  }


  Future<PreProforma> addPreProforma( String baseUrl, PreProforma preProforma ) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/addpreproforma',
        {'api_key': Globals.apikey});

    final resp = await http.post(
      url,
      body: jsonEncode( preProforma.toMap()),
      headers: Globals.headers
    );

    if (resp.statusCode == 200) {

      final Map<String, dynamic>  decoded = jsonDecode(resp.body) ;

      return PreProforma.fromMap(decoded['preproforma']);

    } else {
      return Future.error(resp.body);
    }     
  }

  Future<List<PreProformaDetalle>> getPreproformaDetalleById( String baseUrl, int id) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/detallepreproformabyid',
        {'api_key': Globals.apikey, 'id' : id.toString()});

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

    final url = Uri.http(baseUrl, '/utilitiesapi/public/insertitem',
        {'api_key': Globals.apikey});

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

  Future<Map<String, dynamic>> updateItemCount( String baseUrl, int id,String codigo, double cantidad, double total ) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/updateitemcount',
        {'api_key': Globals.apikey});

    final Map<String, dynamic> params = {
      'id' : id,
      'cantidad' : cantidad,
      'codigo' : codigo,
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

  Future<bool> deleteItem( String baseUrl, int? id ) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/deleteitem',
        {'api_key': Globals.apikey});

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
  Future<Map<String, dynamic>> deletePreProforma( String baseUrl, int id ) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/deletepreproforma',
        {'api_key': Globals.apikey});

    final Map<String, dynamic> params = {
      'id' : id,
    };

    final resp = await http.delete(
      url,
      body: jsonEncode( params ),
      headers: Globals.headers
    );

    if ( resp.statusCode == 200 ) {

      final Map<String, dynamic> map = jsonDecode( resp.body );
      return map ;

    } else {

      return  Future.error(resp.body);

    }

  }

  Future<Map<String, dynamic>> setClienteToPreproforma( String baseUrl, PreProforma preProforma ) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/setclientetopreproforma',
        {'api_key': Globals.apikey});

  
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

    final url = Uri.http(baseUrl, '/utilitiesapi/public/settotales',
        {'api_key': Globals.apikey});

  
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

  Future<Map<String, dynamic>> exonerarLista(String  baseUrl, List<PreProformaDetalle> preproformadetalle) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/exonerarlista',
        {'api_key': Globals.apikey});

    final Map<String, dynamic> params = {
      'lista' : preproformadetalle.map((e) => e.toMap()).toList()
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
  
  Future<Map<String, dynamic>> realPriceToList(String  baseUrl, List<PreProformaDetalle> preProformaDetalle) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/realpricetolist',
        {'api_key': Globals.apikey});

    final Map<String, dynamic> params = {
      'lista' : preProformaDetalle.map<Map<String, dynamic>>((e) => e.toMap()).toList()
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

  Future<Map<String, dynamic>> aplicarDescuentos(String  baseUrl, Map<String, dynamic> params ) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/aplicardescuentos',
        {'api_key': Globals.apikey});

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

  Future<Map<String, dynamic>> descuentosEnCero(String  baseUrl, Map<String, dynamic> params ) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/descuentosencero',
        {'api_key': Globals.apikey});

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
}