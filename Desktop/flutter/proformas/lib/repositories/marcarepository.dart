import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/marcaservice.dart';

class MarcaRepository{
  final MarcaService _service ;
  final ConfigService _configService ;

  MarcaRepository(this._service, this._configService) ;

  Future<Map<String, dynamic>> getMarcas() async {
    return _service.getMarcas( _configService.getBaseUrl() );
  }


}