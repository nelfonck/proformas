import 'package:flutter/material.dart';
import 'package:proformas/models/bodega.dart';
import 'package:proformas/models/compania.dart';
import 'package:proformas/providers/bodegaprovider.dart';
import 'package:proformas/repositories/bodegarepository.dart';
import 'package:proformas/repositories/companiarepository.dart';
import 'package:proformas/repositories/usuariorepository.dart';
import 'package:proformas/services/bodegaservice.dart';
import 'package:proformas/services/companiaservice.dart';
import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/helperservice.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/services/usuarioservice.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier{
  final BodegaRepository _bodegaRepository = BodegaRepository(BodegaService(), ConfigService()); 
  final UsuarioReposotory _usuarioReposotory = UsuarioReposotory(UsuarioService(), ConfigService()); 
  final CompaniaRepository _companiaRepository = CompaniaRepository(CompaniaService(), ConfigService());
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool loading = false;

  Compania? compania ;  
  
  List<Bodega> bodegas = [];
  Bodega? lastUsedBodega;
  Compania? lastCompany;
  BuildContext? context ;
  bool rememberLogin = false;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
  
  void setRememberLogin(bool value){
    rememberLogin = !rememberLogin;
    _safeNotifyListeners();
  }


  Future<void> saveLoginCredentials()async{
      SharedPreferences prefs = await  SharedPreferences.getInstance();
      prefs.setString('user', rememberLogin ? userController.text : '');
      prefs.setString('pass', rememberLogin ? passController.text: '');
      prefs.setBool('remember-login', rememberLogin);
  }

  Future<void> restoreLoginCredentials()async{
      SharedPreferences prefs = await  SharedPreferences.getInstance();
      String? user = prefs.getString('user');
      String? pass = prefs.getString('pass');
      bool? remember = prefs.getBool('remember-login');

      if (prefs.containsKey('remember-login')){
        if (remember!=null){
          if (remember){
            userController.text = user ?? '';
            passController.text = pass ?? '';
            rememberLogin = remember;
            _safeNotifyListeners();
          }
        }
      }
  }

  void init( BuildContext context ) async {
    this.context = context ;
    await ConfigService().toConfig().then((value) async{
      if ( value ) {
        if (context.mounted){
          Navigator.pushReplacementNamed(context, 'config');
        }
      } else {
        await restoreLoginCredentials();

        loading = true;
        _safeNotifyListeners();
        lastUsedBodega = await getLastUsedBodega();
        if ( lastUsedBodega == null ){
          getBodegas().onError((error, stackTrace) {
            if (context.mounted){
              Dlg.showError(context, error.toString());
              loading = false;
              _safeNotifyListeners();
              return;
            }
          });
        } else {
          bodegas.add(lastUsedBodega!);
          setBodega(lastUsedBodega!);
        }
        lastCompany = await getLastCompany();
        if (lastCompany == null){
          getCompania().onError((error, stackTrace) {
            if (context.mounted){
              Dlg.showError(context, error.toString());
              loading = false;
              _safeNotifyListeners();
              return;
            }
          });
          if (compania!=null){
            setLastCompany(compania!);
          }
        } else {
          compania = lastCompany;
        }
        loading = false;
        _safeNotifyListeners();
      }
    },);
  }

  Future<Bodega?> getLastUsedBodega() async{
      SharedPreferences prefs = await  SharedPreferences.getInstance();
      if (prefs.containsKey('bodega')){
        return Bodega(
          bodega: prefs.getString('bodega'),
          descripcion: prefs.getString('descripcion'),
          activo: 'S'
        );
      } else {
        return null;
      }
  }

  Future<Compania?> getLastCompany() async{
    SharedPreferences prefs = await  SharedPreferences.getInstance();
    if (prefs.containsKey('cod_compania')){
      return Compania(
        codCompania: prefs.getString('cod_compania'),
        razonSocial: prefs.getString('razon_social'),
        razonComercial: prefs.getString('razon_comercial'),
        identificacion: prefs.getString('identificacion'),
        tipoIdentificacion: prefs.getString('tipo_identificacion'),
        telefono: prefs.getString('telefono'),
        direccion: prefs.getString('direccion'),
        logo: prefs.getString('logo') != null ? HelperService.base64StringToUnit8List(prefs.getString('logo')!) : null,
      );
    } else {
      return null;
    }
  }

  void setBodega(Bodega bodega){
    BodegaProvider bodegaProvider = Provider.of<BodegaProvider>(context!, listen: false);
    bodegaProvider.setBodega(bodega);
   } 


  Future<void> getBodegas() async {
    bodegas = await _bodegaRepository.getBodegas();
    _safeNotifyListeners();
  }

  Future<void> getCompania() async {
    compania = await _companiaRepository.getCompania();
    _safeNotifyListeners();
  }


  Future<Map<String, dynamic>?> getUsuario( String user, String pass ) async {
    final Map<String, dynamic>? result = await _usuarioReposotory.getUsurio(user, pass);
    return result ;
  }

  Future<void> setLastUsedBodega(Bodega? bodega) async{
    SharedPreferences prefs = await  SharedPreferences.getInstance();
    prefs.setString('bodega', bodega?.bodega ?? '');
    prefs.setString('descripcion', bodega?.descripcion ?? '');
    prefs.setString('activo', bodega?.activo ?? 'N');
  }

  Future<void> setLastCompany(Compania compania) async{
    SharedPreferences prefs = await  SharedPreferences.getInstance();
    prefs.setString('cod_compania', compania.codCompania ?? '');
    prefs.setString('razon_social', compania.razonSocial ?? '');
    prefs.setString('razon_comercial', compania.razonComercial ?? '');
    prefs.setString('identificacion', compania.identificacion ?? '');
    prefs.setString('tipo_identificacion', compania.tipoIdentificacion ?? '');
    prefs.setString('telefono', compania.telefono ?? '');
    prefs.setString('direccion', compania.direccion ?? '');
    prefs.setString('logo',  HelperService.uint8ListToBase64String(compania.logo));
  }

  void _safeNotifyListeners(){
    if (!_disposed){
      notifyListeners();
    }
  }
}