import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proformas/consts/globals.dart';
import 'package:proformas/models/habladorhh.dart';
import 'package:proformas/providers/userprovider.dart';
import 'package:provider/provider.dart';

class HabladorHHService {

  static final HabladorHHService _instance = HabladorHHService.internal();

  HabladorHHService.internal();  

  factory HabladorHHService() => _instance ;

  Future<Map<String,dynamic>> getHabladoresHH(BuildContext context, String baseUrl,  ) async {

    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    final url = Uri.http(baseUrl, '/utilitiesapi/public/habladoreshh',
        {'api_key': Globals.apikey, 'creado_por': userProvider.getUsuario()?.codUsuario});

    final resp = await http.get(url);

    if (resp.statusCode == 200) {

      final Map<String, dynamic> map = jsonDecode(resp.body);

      return map;

    } else {
      return Future.error(resp.body);
    }     
  }

  Future<Map<String,dynamic>> insertHabladorHHToDb(BuildContext context, String baseUrl, HabladorHh hablador  ) async {

    final url = Uri.http(baseUrl, '/utilitiesapi/public/inserthabladorhh',
        {'api_key': Globals.apikey});

    final resp = await http.post(
      url,
      body: jsonEncode(hablador.toMap()),
      headers: Globals.headers
    );

    if (resp.statusCode == 200) {

      final Map<String, dynamic> map = jsonDecode(resp.body);

      return map;

    } else {
      return Future.error(resp.body);
    }     
  }

  Future<Map<String,dynamic>> insertHabladorHHBloqToDb(BuildContext context, String baseUrl, List<HabladorHh> list) async {
    final url = Uri.http(baseUrl, '/utilitiesapi/public/inserthabladorhhbloq',
        {'api_key': Globals.apikey});
    List<Map<String,dynamic>> listMap = list.map((e) => e.toMap()).toList();
    Map<String,dynamic> params = {
      'list': listMap
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

  Future<Map<String,dynamic>> deleteHablador(String baseUrl,int id) async{
    final url = Uri.http(baseUrl, '/utilitiesapi/public/deletehabladorhh',
        {'api_key': Globals.apikey, 'id': id.toString()});

    final resp = await http.delete(
      url,
      headers: Globals.headers
    );

    if (resp.statusCode == 200) {

      final Map<String, dynamic> map = jsonDecode(resp.body);

      return map;

    } else {
      return Future.error(resp.body);
    }  
  }

  Future<Map<String,dynamic>> moveListToQupos(String baseUrl, List<HabladorHh> list) async{
    
    final url = Uri.http(baseUrl, '/utilitiesapi/public/movelisttoquposhabladorhh', {'api_key': Globals.apikey});
    
    List<Map<String,dynamic>> listMapped = list.map((e) => e.toMap()).toList();
    Map<String,dynamic> params = {'lista':listMapped};

    final resp = await http.post(
      url,
      body: jsonEncode(  params ),
      headers: Globals.headers
    );

    if (resp.statusCode == 200) {

      final Map<String, dynamic> map = jsonDecode(resp.body);

      return map;

    } else {
      return Future.error(resp.body);
    }  

  }

  Future<Map<String,dynamic>> deleteList(BuildContext context, String baseUrl ) async{

    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    final url = Uri.http(baseUrl, '/utilitiesapi/public/deletehabladorhhlist', {'api_key': Globals.apikey, 'creado_por': userProvider.getUsuario()?.codUsuario.toString()});
    
    final resp = await http.delete(
      url,
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