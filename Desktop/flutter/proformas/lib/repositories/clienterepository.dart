import 'package:proformas/models/cliente.dart';
import 'package:proformas/services/clienteservice.dart';
import 'package:proformas/services/configservice.dart';

class ClienteRepository {
  final ClienteService  _service ;
  final ConfigService _configService ;
  ClienteRepository(this._service, this._configService) ;

  Future<List<Cliente>> getClientes() async {
    return _service.getClientes( _configService.getBaseUrl() );
  }

  Future<List<Cliente>> getClientesByRazonSocial( String razonSocial) async {
    return _service.getClientesByRazonSocial( _configService.getBaseUrl() , razonSocial);
  }

}