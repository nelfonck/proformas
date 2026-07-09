import 'package:proformas/models/compania.dart';
import 'package:proformas/services/companiaservice.dart';
import 'package:proformas/services/configservice.dart';

class CompaniaRepository {

  final CompaniaService  _service ;
  final ConfigService _configService ;

  CompaniaRepository(this._service, this._configService) ;

  Future<Compania> getCompania() async {
    return _service.getCompania( _configService.getBaseUrl() );
  }


}