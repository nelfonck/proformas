import 'package:proformas/models/preproforma.dart';
import 'package:proformas/models/preproformadetalle.dart';
import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/preproformaservice.dart';

class PreProformaRepository {

  final PreProformaService  _service ;
  final ConfigService _configService ;

  PreProformaRepository(this._service, this._configService) ;

  Future<List<PreProforma>> getPreProformas() async {
    return await _service.getPreProformas( _configService.getBaseUrl() );
  }

  Future<List<PreProforma>> getPreProformasByDate( DateTime from, DateTime to ) async {
    return await _service.getPreProformasByDate( _configService.getBaseUrl(), from, to );
  }

  Future<PreProforma> addPreProforma( PreProforma preProforma ) async {
    return await _service.addPreProforma( _configService.getBaseUrl(), preProforma );
  }

  Future<Map<String, dynamic>> insertItem( Map<String, dynamic> data ) async {
    return await _service.insertItem( _configService.getBaseUrl(), data );
  }

  Future<Map<String, dynamic>> updateItemCount( int id, String codigo, double cantidad, double total) async {
    return await _service.updateItemCount( _configService.getBaseUrl(), id,codigo, cantidad, total );
  }

  Future<bool> deleteItem( int? id ) async {
    return await _service.deleteItem( _configService.getBaseUrl(), id );
  }

  Future<Map<String, dynamic>> deletePreProforma( int id ) async {
    return await _service.deletePreProforma( _configService.getBaseUrl(), id );
  }

  Future<List<PreProformaDetalle>> getPreproformaDetalleById( int? id ) async {
    return await _service.getPreproformaDetalleById( _configService.getBaseUrl(), id);
  }

  Future<Map<String, dynamic>> setClienteToPreproforma( PreProforma preProforma ) async {
    return await _service.setClienteToPreproforma( _configService.getBaseUrl(), preProforma);
  }

  Future<Map<String, dynamic>> setTotales( PreProforma preProforma ) async {
    return await _service.setTotales( _configService.getBaseUrl(), preProforma);
  }

  Future<Map<String, dynamic>> exonerarLista(List<PreProformaDetalle> preproformadetalle) async {
    return await _service.exonerarLista( _configService.getBaseUrl(), preproformadetalle);
  } 

  Future<Map<String, dynamic>> realPriceToList(List<PreProformaDetalle> preproformadetalle) async {
    return await _service.realPriceToList( _configService.getBaseUrl(), preproformadetalle);
  } 

  Future<Map<String, dynamic>> aplicarDescuentos ( Map<String, dynamic> params ) async {
    return await _service.aplicarDescuentos( _configService.getBaseUrl(), params );
  }

  Future<Map<String, dynamic>> descuentosEnCero ( Map<String, dynamic> params ) async {
    return await _service.descuentosEnCero( _configService.getBaseUrl(), params );
  }


}