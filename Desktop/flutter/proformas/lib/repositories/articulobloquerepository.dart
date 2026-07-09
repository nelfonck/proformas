import 'package:proformas/models/articulobloquemodel.dart';
import 'package:proformas/services/articulosbloqueservice.dart';
import 'package:proformas/services/configservice.dart';

class ArticuloBloqueRepository {
  final ArticuloBloqueService   _service ;
  final ConfigService _configService ;

  ArticuloBloqueRepository(this._service, this._configService) ;

  Future<Map<String, dynamic>> ingresarListaEnQupos(List<ArticuloBloque> list) async {
    return _service.ingresarListaEnQupos( _configService.getBaseUrl(), list );
  }

}