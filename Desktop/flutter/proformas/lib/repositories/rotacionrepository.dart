import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/rotacionservice.dart';

class Rotacionrepository {
  final RotacionService  _service ;
  final ConfigService _configService ;

  Rotacionrepository(this._service, this._configService) ;

  Future<Map<String, dynamic>> getSalida(String codigo, DateTime ini, DateTime end) async {
    return _service.getSalida( _configService.getBaseUrl(), codigo, ini, end);
  }


}