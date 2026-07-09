
import 'package:proformas/consts/globals.dart';
import 'package:proformas/models/appupdate.dart';
import 'package:proformas/services/updateservice.dart';

class UpdateRepository {
  
  final UpdateService _service ;

  UpdateRepository( this._service ) ;

  Future<List<AppsUpdate>> checkForUpdate() async {
    return await _service.checkForUpdate( Globals.updateUrl ) ;
  }

}

