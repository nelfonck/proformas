import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proformas/consts/globals.dart';
import 'package:proformas/models/cabys.dart';

class CabyService {

  static final CabyService _instance = CabyService.internal();

  CabyService.internal();  

  factory CabyService() => _instance ;

  Future<Cabys> getCabys( String wordKey ) async {

    final url = Uri.parse( Globals.cabysUrl +  wordKey );
    final resp = await http.get(url);

    if (resp.statusCode == 200) {

      final Map<String, dynamic> map = jsonDecode(resp.body);
      
      return Cabys.fromMap( map );

    } else {
      return Future.error(resp.body);
    }     
  }
 
  
}