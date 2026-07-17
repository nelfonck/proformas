import 'package:proformas/models/compania.dart';
import 'package:proformas/models/preproforma.dart';
import 'package:proformas/models/preproformadetalle.dart';
import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/emailservice.dart';

class EmailRepository {

  final EmailService  _service ;
  final ConfigService _configService ;

  EmailRepository(this._service, this._configService) ;

  Future<Map<String, dynamic>?> sendEmail( PreProforma preProforma, List<PreProformaDetalle> preProformaDetalle, Compania compania) async {
    return await _service.sendEmail( _configService.getBaseUrl(), preProforma, preProformaDetalle, compania);
  }


}