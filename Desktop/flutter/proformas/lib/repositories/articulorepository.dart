import 'package:proformas/models/articulo.dart';
import 'package:proformas/services/articuloservice.dart';
import 'package:proformas/services/configservice.dart';

class ArticuloRepository {
  final ArticuloService  _service ;
  final ConfigService _configService ;

  ArticuloRepository(this._service, this._configService) ;

  Future<Map<String, dynamic>> getArticulo( String? codigo) async {
    return _service.getArticulo( _configService.getBaseUrl(), codigo );
  }

  Future<Map<String, dynamic>> getArticulosByDescription(String txt) async {
    return _service.getArticulosByDescription( _configService.getBaseUrl(), txt );
  }

  Future<Map<String, dynamic>> getArticulomla( String codigo) async {
    return _service.getArticulomla( _configService.getBaseUrl(), codigo );
  }

  Future<Map<String, dynamic>> updateArticulo( Articulo articulo ) async {
    return _service.updateArticulo( _configService.getBaseUrl(), articulo );
  }

  Future<Map<String, dynamic>> insertArticulo( Articulo articulo ) async {
    return _service.insertArticulo( _configService.getBaseUrl(), articulo );
  }

  Future<Map<String,dynamic>> insertarHablador(String codArticulo ) async {
    return _service.insertarHablador( _configService.getBaseUrl(), codArticulo );
  }


}