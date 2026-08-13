import 'package:flutter/material.dart';
import 'package:proformas/models/proveedor.dart';
import 'package:proformas/repositories/buscarproveedorrepository.dart';
import 'package:proformas/services/buscarproveedorservice.dart';
import 'package:proformas/services/configservice.dart';


class BuscarProveedorViewModel extends ChangeNotifier{
  TextEditingController proveedorController = TextEditingController();
  final BuscarProveedorRepository _repository = BuscarProveedorRepository(BuscarProveedorService(), ConfigService());

  List<Proveedor> proveedores = [];
  bool _dispose = false;

  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }

  Future<void> buscarProveedores () async{
    proveedores = await _repository.getProveedores(proveedorController.text);
    _safeNotifyListeners();
  }

  void init(){
    /*proveedores.add(
      Proveedor(codProveedor: "1420", razsocial: "ISLENA DE ALIMENTOS", identificacion: "333")
    );
    proveedores.add(
      Proveedor(codProveedor: "1640", razsocial: "COMPANIA POZUELO", identificacion: "4323452356")
    );
    _safeNotifyListeners();*/
  }

  void _safeNotifyListeners(){
    if (!_dispose){
      notifyListeners();
    }
  }
}