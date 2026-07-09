import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/impuestoservice.dart';

class ImpuestoRepository{
  final ImpuestoService _service ;
  final ConfigService _configService ;

  ImpuestoRepository(this._service, this._configService) ;

  Future<Map<String, dynamic>> getImpuestos() async {
    return _service.getImpuestos( _configService.getBaseUrl() );
  }


}