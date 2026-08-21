import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proformas/models/proveedor.dart';
import 'package:proformas/repositories/paparazzirepository.dart';
import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/paparazziservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaparazziViewModel extends ChangeNotifier{

  final PaparazziRepository _paparazziRepository = PaparazziRepository(PaparazziService(), ConfigService()); 

  TextEditingController  consecutivoController = TextEditingController();
  bool mostrarProductoEncontrado = false; 
  bool bloquearCampo = true;
  bool _disposed = false;
  Proveedor? selectedProveedor;
  final List<File> fotos = [];
  TextEditingController codigoController = TextEditingController();
  FocusNode codigoFocus = FocusNode();

  Future<Map<String,dynamic>?> checkCode()async{
    if (selectedProveedor==null){
      throw Exception('Debe seleccionar un proveedor');
    }else if (consecutivoController.text.isEmpty){
      throw Exception('Consecutivo factura es requerido');
    }else{
      String codProveedor = selectedProveedor!.codProveedor ;
      String codArticulo  = codigoController.text;
      final resp = await _paparazziRepository.checkCode(codArticulo, codProveedor);
      return resp;
    }
  }

  Future<File?> tomarFoto() async {
    final ImagePicker picker = ImagePicker();

    final XFile? foto = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );

    if (foto == null) {
      return null;
    }
    return File(foto.path);
  }

  void clearAll(){
    selectedProveedor = null;
    consecutivoController.text = '';
    fotos.clear();
    codigoController.text =  '';
    codigoFocus.requestFocus();
    _safeNotifyListeners();
  }

  Future<Map<String,dynamic>?> subirImagen()async{
    final parameters = await SharedPreferences.getInstance();

    File? image = await tomarFoto();

    if (image==null) return null;
    if (consecutivoController.text.isEmpty) return null;
    if (parameters.getString('ruta-facturas')?.isEmpty??true) return null;

    String? rutaBase = '${parameters.getString('ruta-facturas')}';
    String? folder = consecutivoController.text;
    String codArticulo = codigoController.text;

    final response = await _paparazziRepository.subirImagen(image, rutaBase, folder,codArticulo);

    if (response['status']==true){
      fotos.add(image);
      _safeNotifyListeners();
      cleanAndRequest();
    }

    return response;
  }

  void cleanAndRequest(){
    codigoController.text = '';
    codigoFocus.requestFocus();
  }

  Future<File> imageUrlToFile(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode != 200) {
      throw Exception('No se pudo descargar la imagen');
    }
    
    final directory = await getTemporaryDirectory();

    final file = File(
      '${directory.path}/imagen.jpg',
    );

    await file.writeAsBytes(response.bodyBytes);

    return file;
  }

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