import 'package:flutter/material.dart';
import 'package:proformas/models/conexion.dart';

class ConfigProvider extends ChangeNotifier {

  Con? _con ;
  String? _broadCastLink;
  bool? _useBroadCast;

  void setCon( Con con ) {
    _con = con ;
  }

  void setBroadCastLink(String broadcastLink) {
    _broadCastLink = broadcastLink;
  } 

  void setUseBroadcast(bool useBroadCast) {
    _useBroadCast = useBroadCast;
  } 

  String? getBroadCastLink(){
    return _broadCastLink;
  }

  bool? getUseBroadCast(){
    return _useBroadCast;
  }

  Con? getCon() => _con ;
  
}