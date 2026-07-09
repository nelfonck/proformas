import 'package:flutter/material.dart';
import 'package:proformas/models/usuario.dart';

class UserProvider extends ChangeNotifier{

  Usuario? _usuario;
  
  void setUsuario( Usuario usuario){
    _usuario = usuario ;
  }

  Usuario? getUsuario(){
    return _usuario ;
  }
}