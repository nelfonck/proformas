import 'package:flutter/material.dart';
import 'package:proformas/models/habladorhh.dart';
import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/habladorhhservice.dart';

class HabladorHHRepository {
  final HabladorHHService  _service ;
  final ConfigService _configService ;

  HabladorHHRepository(this._service, this._configService) ;

  Future<Map<String,dynamic>> getHabladoresHH(BuildContext context) async {
    return _service.getHabladoresHH(context, _configService.getBaseUrl() );
  }

  Future<Map<String,dynamic>> insertHabladorHHToDb(BuildContext context, HabladorHh hablador) async {
    return _service.insertHabladorHHToDb(context, _configService.getBaseUrl(), hablador);
  }

  Future<Map<String,dynamic>> insertHabladorHHBloqToDb(BuildContext context, List<HabladorHh> list) async {
    return _service.insertHabladorHHBloqToDb(context, _configService.getBaseUrl(), list);
  }

  Future<Map<String,dynamic>> deleteHablador(int id) async{
    return _service.deleteHablador(_configService.getBaseUrl(), id);
  }

  Future<Map<String,dynamic>> moveListToQupos(List<HabladorHh> list) async{
    return _service.moveListToQupos(_configService.getBaseUrl(), list);
  }

  Future<Map<String,dynamic>> deleteList(BuildContext context) async{
    return _service.deleteList(context , _configService.getBaseUrl());
  }


}