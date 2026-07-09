
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proformas/models/appupdate.dart';

class UpdateService {

  static final UpdateService _instance = UpdateService.internal();

  UpdateService.internal();  

  factory UpdateService() => _instance ;

  Future<List<AppsUpdate>> checkForUpdate( String updUrl ) async {

      final resp = await http.get(Uri.parse( updUrl ));

      if ( resp.statusCode == 200 ) {

        final decoded = jsonDecode(resp.body) as List ;

        return decoded.map((e) => AppsUpdate.fromMap(e) ).toList();

      } else {
        return Future.error(resp.body);
      }
  }

}