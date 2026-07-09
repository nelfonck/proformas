import 'package:flutter/cupertino.dart';
import 'package:proformas/models/cliente.dart';
import 'package:proformas/repositories/clienterepository.dart';
import 'package:proformas/services/clienteservice.dart';
import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/notificationservice.dart';

class ClienteViewModel extends ChangeNotifier {
  final ClienteRepository _repository = ClienteRepository(ClienteService(), ConfigService()); 
  List<Cliente> clientes = [];
  BuildContext? _context ;

  void init(BuildContext context) async {
    _context = context ;
    await ConfigService().toConfig().then(((value) {
      if ( value ){
        Navigator.of(context).pushReplacementNamed('config');
      } else {
       getClientes().onError((error, stackTrace) => Dlg.showError(_context!, error.toString()));
      }
    }));
  }

  Future<void> getClientes() async {
    clientes = await _repository.getClientes();
    notifyListeners();
  }
  Future<void> getClientesByRazonSocial( String razonSocial ) async {
    clientes = await _repository.getClientesByRazonSocial( razonSocial );
    notifyListeners();
  }


}