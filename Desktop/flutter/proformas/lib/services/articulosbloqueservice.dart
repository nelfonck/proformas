import 'dart:convert';
import 'package:context_holder/context_holder.dart';
import 'package:http/http.dart' as http;
import 'package:proformas/consts/globals.dart';
import 'package:proformas/data/exceptions/api_exception.dart';
import 'package:proformas/models/articulobloquemodel.dart';
import 'package:proformas/providers/bodegaprovider.dart';
import 'package:proformas/providers/userprovider.dart';
import 'package:provider/provider.dart';

class ArticuloBloqueService {

  static final ArticuloBloqueService _instance = ArticuloBloqueService.internal();

  ArticuloBloqueService.internal();  

  factory ArticuloBloqueService() => _instance ;


  Future<Map<String,dynamic>> ingresarListaEnQupos(String baseUrl, List<ArticuloBloque> list) async{
    UserProvider user = Provider.of ( ContextHolder.currentContext, listen: false );
    BodegaProvider bodega = Provider.of ( ContextHolder.currentContext, listen: false );

    List<Map<String,dynamic>> mapList = list.where((element) => !element.ingresado!).map((e) => e.toMap()).toList();

    Map<String,dynamic> params = {
      'user': user.getUsuario()?.toMap(),
      'bodega': bodega.getBodega()?.toMap(),
      'list': mapList
    };
    final url = Uri.http(baseUrl, '/utilitiesapi/public/insertarlistaenqupos',
      {'api_key': Globals.apikey}
    );

    final resp = await http.post(
      url,
      body: jsonEncode(params),
      headers: Globals.headers
    );

    final body = resp.body;
    final decoded = body.isNotEmpty ? jsonDecode(body) : {};

    if (resp.statusCode == 200) {
      return decoded;
    } else {
      throw ApiException(
        statusCode: resp.statusCode,
        message: decoded['message'] ?? 'Error desconocido',
        data: decoded,
      );
    }
  }
}