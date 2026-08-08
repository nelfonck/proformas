import 'package:proformas/models/proveedor.dart';
import 'package:proformas/services/buscarproveedorservice.dart';
import 'package:proformas/services/configservice.dart';

class BuscarProveedorRepository {
  final BuscarProveedorService  _service ;
  final ConfigService _configService ;

  BuscarProveedorRepository(this._service, this._configService) ;

  Future<List<Proveedor>> getProveedores(String cliterio) async {
    return _service.getProveedores( _configService.getBaseUrl(), cliterio);
  }


}