import 'package:flutter/material.dart';
import 'package:proformas/models/proveedor.dart';

class PaparazziViewModel extends ChangeNotifier{
  TextEditingController  consecutivoController = TextEditingController();
  bool mostrarProductoEncontrado = false; 
  bool bloquearCampo = true;
  bool _disposed = false;
  Proveedor? selectedProveedor;

  void setMostrarProductoEncontrado(bool value){
    mostrarProductoEncontrado = value;
    _safeNotifyListeners();
  }

  void setSelectedProveedor(Proveedor selected){
    selectedProveedor = selected;
    _safeNotifyListeners();
  }

  void setBloquearCampo(bool value){
    bloquearCampo = value;
    _safeNotifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _safeNotifyListeners(){
    if (!_disposed){
      notifyListeners();
    }
  }

}