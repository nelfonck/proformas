import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:intl/intl.dart';
import 'package:proformas/models/articulo.dart';
import 'package:proformas/models/articulomla.dart';
import 'package:proformas/models/familia.dart';
import 'package:proformas/models/impuesto.dart';
import 'package:proformas/models/marca.dart';
import 'package:proformas/models/unidad.dart';
import 'package:proformas/models/unidadmedida.dart';
import 'package:proformas/repositories/MarcaRepository.dart';
import 'package:proformas/repositories/articulorepository.dart';
import 'package:proformas/repositories/familiarepository.dart';
import 'package:proformas/repositories/impuestorepository.dart';
import 'package:proformas/repositories/unidadmedidarepository.dart';
import 'package:proformas/repositories/unidadrepository.dart';
import 'package:proformas/services/articuloservice.dart';
import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/familiaservice.dart';
import 'package:proformas/services/impuestoservice.dart';
import 'package:proformas/services/marcaservice.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/services/unidadmedidaservice.dart';
import 'package:proformas/services/unidadservice.dart';
import 'package:proformas/services/helperservice.dart';


class ArticuloViewModel extends ChangeNotifier {
  bool _disposed = false;
  BuildContext? _context ;
  BroadcastReceiver? receiver ;
  final ConfigService _configService = ConfigService();
  final ArticuloRepository _repository = ArticuloRepository(ArticuloService(), ConfigService()); 
  final FamiliaRepository _familiaRepository = FamiliaRepository(FamiliaService(), ConfigService()); 
  final MarcaRepository _marcaRepository = MarcaRepository(MarcaService(), ConfigService()); 
  final ImpuestoRepository _impuestoRepository = ImpuestoRepository(ImpuestoService(), ConfigService()); 
  final UnidadMedidaRepository _unidadMedidaRepository = UnidadMedidaRepository(UnidadMedidaService(), ConfigService()); 
  final UnidadRepository _unidadRepository = UnidadRepository(UnidadService(), ConfigService()); 
  Articulo? articulo ;
  ArticuloMla? articulomla ;
  List<Familia> familias = [] ;
  List<Marca> marcas = [] ;
  List<Impuesto> impuestos = [] ;
  List<UnidadMedida> um = [] ;
  List<Unidad> ud = [] ;
  List<Articulo> articuloList = [];
  bool? useBroadCast = false ;
  TextEditingController descripcionController  =  TextEditingController(); 
  TextEditingController cabysController  =  TextEditingController(); 
  PageController pageController = PageController();

  //preciosController
  TextEditingController costoController  =  TextEditingController(); 
  TextEditingController utilidadController  =  TextEditingController(); 
  TextEditingController ventaController  =  TextEditingController(); 

  //topesDescuentosController
  TextEditingController topeDescuento1Controller  =  TextEditingController(); 
  TextEditingController topeDescuento2Controller  =  TextEditingController(); 
  TextEditingController topeDescuento3Controller  =  TextEditingController(); 

  //filtroCodigoController
  TextEditingController codigoController  =  TextEditingController(); 

  //Volumen y peso y factorUnidadMedida Controller
  TextEditingController volumenController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController factorUnidadMedidaController = TextEditingController();

  FocusNode codigoFocusNode = FocusNode();


  void init( BuildContext context ) async {
    _context = context ;

      await _configService.toConfig().then(((value) async {
      if ( value ){
        Navigator.of(context).pushReplacementNamed('config');
      } else {
        useBroadCast = _configService.getUseBroadcast();
        if (useBroadCast!){
          setReceiver();
        }
        await _getFamilias().onError((error, stackTrace) => Dlg.showError( _context! , error.toString()));
        await _getMarcas().onError((error, stackTrace) => Dlg.showError( _context! , error.toString()));
        await _getImpuestos().onError((error, stackTrace) => Dlg.showError( _context! , error.toString()));
        await _getUnidadesMedida().onError((error, stackTrace) => Dlg.showError(_context!, error.toString()));
        await _getUnidades().onError((error, stackTrace) => Dlg.showError(_context!, error.toString()));
      }
    }));
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void setReceiver(){
    String? receiverLink = _configService.getBroadCastReceiverLink();
    if (receiverLink!=null){
      receiver = BroadcastReceiver(
        names: <String>[
          receiverLink,
        ],
      );
    }
  }

  Future<void> _getFamilias() async {
    Map<String, dynamic> resp = await _familiaRepository.getFamilias();

    if ( resp['statusCode'] == 200 ){
      familias = resp['familias'].map<Familia>((e) => Familia.fromMap(e)).toList();
      _safeNotifyListeners();
    }
  }

  Future<void> _getMarcas() async {
    Map<String, dynamic> resp = await _marcaRepository.getMarcas();

    if ( resp['statusCode'] == 200 ){
      marcas = resp['marcas'].map<Marca>((e) => Marca.fromMap(e)).toList();
      _safeNotifyListeners();
    }
  }

  Future<void> _getImpuestos() async {
    Map<String, dynamic> resp = await _impuestoRepository.getImpuestos();

    if ( resp['statusCode'] == 200 ){
      impuestos = resp['impuestos'].map<Impuesto>((e) => Impuesto.fromMap(e)).toList();
      _safeNotifyListeners();
    }
  }

  Future<void> _getUnidadesMedida() async {
    Map<String, dynamic> resp = await  _unidadMedidaRepository.getUnidadesMedida();

    if ( resp['statusCode'] == 200 ) {
      um = resp['unidades_medida'].map<UnidadMedida>((e) => UnidadMedida.fromMap(e)).toList();
      _safeNotifyListeners();
    }
  }

  Future<void> _getUnidades() async {
    Map<String, dynamic> resp = await  _unidadRepository.getUnidades();

    if ( resp['statusCode'] == 200 ) {
      ud = resp['unidades'].map<Unidad>((e) => Unidad.fromMap(e)).toList();
      _safeNotifyListeners();
    }
  }

  Future<dynamic> getArticulosByDescription(String txt) async{

    Map<String, dynamic> resp = await _repository.getArticulosByDescription(txt);

    if (resp['statusCode']==200){

      articuloList = resp['articulos'].map<Articulo>((e)=> Articulo.fromMap(e)).toList();

      _safeNotifyListeners();
    }
  }

  Future<dynamic> getArticulo(String codigo) async {

    Map<String, dynamic> resp = await _repository.getArticulo(codigo);

    if ( resp['statusCode'] == 200 ){

      articulo = Articulo.fromMap( resp['articulo'] );
      descripcionController.text = articulo?.descripcion ?? '';
      cabysController.text = articulo?.codCabys ?? '';
      costoController.text = NumberFormat.decimalPattern().format( articulo?.costo );
      utilidadController.text = NumberFormat.decimalPattern().format( articulo?.porcentajeUtilidad );
      ventaController.text = NumberFormat.decimalPattern().format( articulo?.venta );
      topeDescuento1Controller.text = NumberFormat.decimalPattern().format( articulo?.porcTopeDescuento1 ); 
      topeDescuento2Controller.text = NumberFormat.decimalPattern().format( articulo?.porcTopeDescuento2 ); 
      topeDescuento3Controller.text = NumberFormat.decimalPattern().format( articulo?.porcTopeDescuento3 ); 
      volumenController.text = NumberFormat.decimalPattern().format( articulo?.volumen ); 
      pesoController.text = NumberFormat.decimalPattern().format( articulo?.peso ); 
      factorUnidadMedidaController.text = articulo!.factorMedida!.toInt().toString() ; 
      _safeNotifyListeners();
    } else   if ( resp['statusCode'] == 201 ){

      if ( articulo != null ){
        articulo?.descripcion = 'No encontrado';
        articulo?.precioDefault = 0;
        articulo?.venta = 0;
        articulo?.costo = 0;
        articulo?.porcentajeUtilidad = 0;
        _safeNotifyListeners();
      }
      
    } 

    return resp ;

  }

  Future<dynamic> getArticulomla(String codigo) async {

    Map<String, dynamic> resp = await _repository.getArticulomla(codigo);

    if ( resp['statusCode'] == 200 ){

      articulomla = ArticuloMla.fromMap( resp['articulo'] );
      _safeNotifyListeners();
    } else 
    if ( resp['statusCode'] == 201 ){

      articulomla = ArticuloMla(codArticulo: '',costo: 0,venta: 0);
      _safeNotifyListeners();
    } 

    return resp ;

  }

  Future<dynamic> updateArticulo() async {
    if ( articulo == null ) return ;
    Map<String, dynamic> resp = await _repository.updateArticulo( articulo! );
    return resp;
  }

  Future<dynamic> insertarHablador( String? codArticulo ) async{
    if ( codArticulo == null ){
      return;
    } else if ( codArticulo.isEmpty ){
      return;
    } else {
      Map<String, dynamic> resp = await _repository.insertarHablador(codArticulo);
      return resp;
    }
  }

  void setCodigoImpuestoCabysByImp( int? porcentaje ){
    for ( int x = 0 ; x <= impuestos.length-1; x++ ){
      if ( impuestos[x].porcentaje == porcentaje ){
        articulo?.codImpuestoCabys =  impuestos[x].codImpuesto;
        _safeNotifyListeners();
        break;
      }
    }
  }

  Impuesto? getImpuestoByCodigo( String? codigo ){
    for ( int x = 0 ; x <= impuestos.length-1; x++ ){
      if ( impuestos[x].codImpuesto == codigo ){
        return impuestos[x];
      }
    }
    return null;
  }

  UnidadMedida? getUnidadMedidaByCodigo( String? codigo ){
    for ( int x = 0 ; x <= um.length-1; x++ ){
      if ( um[x].unidadMedida == codigo ){
        return um[x];
      }
    }
    return null;
  }

  Unidad? getUnidadByCodigo( String? codigo ){
    for ( int x = 0 ; x <= ud.length-1; x++ ){
      if ( ud[x].unidad == codigo ){
        return ud[x];
      }
    }
    return null;
  }

  bool charToBool( String? char ){
    if ( char == null ){
      return false;
    }
    switch (char) {
      case 'S':
        return true;
      case 'N':
        return false;
      default:
        return false ;
    }
  }

  String boolToChar( bool? value ){
    if ( value == null ){
      return 'N';
    }
    switch (value) {
      case true:
        return 'S';
      case false:
        return 'N';
      }
  }

  void setUtilidad( double costo, double venta, int porcImpuesto ) {
    if ( articulo == null ) return;

    double utilidad = 0;
    //despejar el impuesto
    venta = ( venta * 100 ) / ( 100 + porcImpuesto  );
    //despejar la utilidad
    utilidad = (( venta * 100 ) / costo) - 100 ;

    articulo?.porcentajeUtilidad = utilidad ;
    utilidadController.text = NumberFormat.decimalPattern().format( articulo?.porcentajeUtilidad )  ;

    //set precio default
    setPrecioDefault();
  } 

  void setVenta( double costo, double utilidad, int porcImpuesto ){
    if ( articulo == null ) return;

    double venta = 0;
    //sumar la utilidad
    venta = (costo * ( 100 + utilidad )) / 100 ;
    //sumar el impuesto
    venta = (venta * ( 100 + porcImpuesto )) / 100 ;

    articulo?.venta = venta;
    ventaController.text = NumberFormat.decimalPattern().format( articulo?.venta )  ;

    //set precio default
    setPrecioDefault();
  }

  void setPrecioDefault( ){
    if ( articulo == null ) return;
    //set variables
    double? venta = articulo?.venta;
    int? porcImpuesto = articulo?.impuesto?.porcentaje;

    //despejar el impuesto para obtener el precio default
    double precioDefault = ( venta! * 100 ) / ( 100 + porcImpuesto! );
    articulo?.precioDefault = precioDefault ;
  }

  void nL(){
    _safeNotifyListeners();
  }

  void findItem() async{
    if ( codigoController.text.isEmpty ) return ;
    Dlg.showLoading(_context!, 'Obteniendo datos del articulo');
    Map<String, dynamic> respArticulo = await getArticulo( codigoController.text ).onError((error, stackTrace) {
      Navigator.of(_context!).pop();
      Dlg.showError(_context!, error.toString());
    });

    if ( respArticulo['statusCode'] == 200 ){

      Map<String,dynamic> respArticuloMla = await getArticulomla( codigoController.text ).onError((error, stackTrace) {
        Navigator.of(_context!).pop();
        Dlg.showError(_context!, error.toString());
      });
      // ignore: use_build_context_synchronously
      Navigator.of(_context!).pop();
      
      if ( respArticuloMla['statusCode'] == 201 ){
          // ignore: use_build_context_synchronously
          Dlg.showWarning(_context!, respArticuloMla['message']);
      }

    } else if ( respArticulo['statusCode'] == 201 ){
      if (articulo != null){
        articulo?.costo = 0;
        articulo?.venta = 0;
        articulomla = ArticuloMla(codArticulo: '',costo: 0,venta: 0);
        nL();
      }
        // ignore: use_build_context_synchronously
        Navigator.of(_context!).pop();
        // ignore: use_build_context_synchronously
        Dlg.showWarning(_context!, respArticulo['message']);
    }
    codigoFocusNode.requestFocus();
    HelperService.selectText( codigoController );
  }

   void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

}