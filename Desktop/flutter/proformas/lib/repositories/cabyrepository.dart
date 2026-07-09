import 'package:proformas/models/cabys.dart';
import 'package:proformas/services/cabyservice.dart';

class CabyRepository {
  
  final CabyService  _service ;

  CabyRepository(this._service) ;

  Future<Cabys> getCabys( String wordKey) async {
    return _service.getCabys( wordKey );
  }


}