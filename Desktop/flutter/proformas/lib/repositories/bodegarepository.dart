import 'package:proformas/models/bodega.dart';
import 'package:proformas/services/bodegaservice.dart';
import 'package:proformas/services/configservice.dart';

class BodegaRepository {
  final BodegaService  _service ;
  final ConfigService _configService ;

  BodegaRepository(this._service, this._configService) ;

  Future<List<Bodega>> getBodegas() async {
    return _service.getBodegas( _configService.getBaseUrl() );
  }


}