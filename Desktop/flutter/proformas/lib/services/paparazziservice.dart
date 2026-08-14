import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:proformas/consts/globals.dart';

class PaparazziService {

  static final PaparazziService _instance = PaparazziService.internal();

  PaparazziService.internal();  

  factory PaparazziService() => _instance ;

  Future<Map<String, dynamic>> getMarcas( String baseUrl ) async {
    final url = Uri.http(baseUrl, '/utilitiesapi/public/marcas',
        {'api_key': Globals.apikey});

    final resp = await http.get(url);

    if (resp.statusCode == 200) {

      final Map<String, dynamic> map = jsonDecode(resp.body);

      return map ;

    } else {
      return Future.error(resp.body);
    }     
  }

  Future<Map<String,dynamic>> subirImagen(String baseUrl, File imagen, String foldername) async {

    var request = http.MultipartRequest(
      'POST',
      Uri.http(baseUrl, '/utilitiesapi/public/subir-imagen',
          {'api_key': Globals.apikey}
    ));

    request.fields['foldername'] = foldername;

    request.files.add(
      await http.MultipartFile.fromPath(
        'imagen',
        imagen.path,
      ),
    );

    var response = await request.send();
    final body = await response.stream.bytesToString();
    final Map<String, dynamic> data = jsonDecode(body);

    if(response.statusCode == 200){
      return data;
    }else{
      throw data;
    }
  }
  
}