import 'package:flutter/material.dart';
import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/usuarioservice.dart';

class UsuarioReposotory {
  
  final UsuarioService  _service ;
  final ConfigService _configService ;

  UsuarioReposotory(this._service, this._configService) ;

  Future<Map<String, dynamic>?> getUsurio( String user, String pass ) async {
    return _service.getUsuario( _configService.getBaseUrl() , user, pass );
  }

  Future<Map<String, dynamic>> existeAccion( BuildContext context, String codAccion ) async {
    return _service.existeAccion(context, _configService.getBaseUrl() , codAccion );
  }


}