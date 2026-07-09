
import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/familiaservice.dart';

class FamiliaRepository {
  final FamiliaService  _service ;
  final ConfigService _configService ;

  FamiliaRepository(this._service, this._configService) ;

  Future<Map<String, dynamic>> getFamilias() async {
    return _service.getFamilias( _configService.getBaseUrl() );
  }


}