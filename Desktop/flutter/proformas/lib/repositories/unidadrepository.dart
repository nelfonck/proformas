import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/unidadservice.dart';

class UnidadRepository {
  final UnidadService  _service ;
  final ConfigService _configService ;

  UnidadRepository(this._service, this._configService) ;

  Future<Map<String, dynamic>> getUnidades() async {
    return _service.getUnidades( _configService.getBaseUrl() );
  }


}