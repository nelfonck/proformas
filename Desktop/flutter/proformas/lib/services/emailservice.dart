import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proformas/consts/globals.dart';
import 'package:proformas/models/compania.dart';
import 'package:proformas/models/preproforma.dart';
import 'package:proformas/models/preproformadetalle.dart';

class EmailService {

  static final EmailService _instance = EmailService.internal();

  EmailService.internal();  

  factory EmailService() => _instance ;

  Future<Map<String, dynamic>?> sendEmail( String baseUrl, PreProforma preProforma, List<PreProformaDetalle> preProformaDetalle, Compania compania) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/sendemail',
        {'api_key': Globals.apikey});

    final Map<String, dynamic> params = preProforma.toMap();
    params['detalle_proforma'] = preProformaDetalle.map<Map<String, dynamic>>((e) => e.toMap()).toList();
    params['compania'] = compania.toMap();

    final resp = await http.post(
      url,
      body: jsonEncode( params ),
      headers: Globals.headers
    );

    if (resp.statusCode == 200) {

      final Map<String, dynamic>?  decoded = jsonDecode(resp.body) ;

      return decoded;

    } else {
      return Future.error(resp.body);
    }     
  }
 

}