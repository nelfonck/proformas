import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:proformas/consts/globals.dart';


class PaparazziService {

  static final PaparazziService _instance = PaparazziService.internal();

  PaparazziService.internal();  

  factory PaparazziService() => _instance ;

  Future<Map<String,dynamic>> subirImagen(String baseUrl, File imagen, String rutaBase, String folder, String codArticulo) async {

    var request = http.MultipartRequest(
      'POST',
      Uri.http(baseUrl, '/utilitiesapi/public/subir-imagen',
          {'api_key': Globals.apikey}
    ));

    request.fields['ruta-base'] = rutaBase;
    request.fields['folder'] = folder;
    request.fields['cod-articulo'] = codArticulo;

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

  Future<Map<String,dynamic>> checkCode(String baseUrl, String codArticulo, String codProveedor) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/check-code',
        {'api_key': Globals.apikey});

    final params = {
      "cod_articulo": codArticulo,
      "cod_proveedor": codProveedor
    };

    final resp = await http.post(
      url,
      body: jsonEncode(params),
      headers: Globals.headers
    );

    if (resp.statusCode == 200) {

      final Map<String, dynamic> map = jsonDecode(resp.body);

      return map;

    } else {
      return Future.error(resp.body);
    }     
  }
  
}