import 'dart:io';

import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/paparazziservice.dart';

class PaparazziRepository{
  final PaparazziService _service ;
  final ConfigService _configService ;

  PaparazziRepository(this._service, this._configService) ;

  Future<Map<String, dynamic>> subirImagen(File imagen, String rutaBase, String folder, String codArticulo) async {
    return _service.subirImagen( _configService.getBaseUrl(), imagen, rutaBase, folder,codArticulo);
  }

  Future<Map<String, dynamic>> checkCode(String codArticulo, String codProveedor) async {
    return _service.checkCode( _configService.getBaseUrl(), codArticulo, codProveedor);
  }


}