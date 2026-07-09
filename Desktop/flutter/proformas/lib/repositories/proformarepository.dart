import 'package:proformas/models/bodega.dart';
import 'package:proformas/models/preproforma.dart';
import 'package:proformas/models/preproformadetalle.dart';
import 'package:proformas/models/usuario.dart';
import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/proformaservice.dart';

class ProformaRepository {

  final ProformaService  _service ;
  final ConfigService _configService ;

  ProformaRepository(this._service, this._configService) ;

  Future<Map<String, dynamic>> addProforma( PreProforma preProforma, List<PreProformaDetalle> preProformaDetalle, Usuario usuario, Bodega bodega ) async {
    return await _service.addProforma( _configService.getBaseUrl(), preProforma, preProformaDetalle, usuario, bodega );
  }

}