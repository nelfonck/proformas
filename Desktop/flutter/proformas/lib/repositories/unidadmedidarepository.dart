import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/unidadmedidaservice.dart';

class UnidadMedidaRepository {
  final UnidadMedidaService  _service ;
  final ConfigService _configService ;

  UnidadMedidaRepository(this._service, this._configService) ;

  Future<Map<String, dynamic>> getUnidadesMedida() async {
    return _service.getUnidadesMedida( _configService.getBaseUrl() );
  }


}