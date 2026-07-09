import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proformas/models/articulo.dart';
import 'package:proformas/models/familia.dart';
import 'package:proformas/models/impuesto.dart';
import 'package:proformas/models/marca.dart';
import 'package:proformas/models/unidad.dart';
import 'package:proformas/models/unidadmedida.dart';
import 'package:proformas/repositories/MarcaRepository.dart';
import 'package:proformas/repositories/articulorepository.dart';
import 'package:proformas/repositories/familiarepository.dart';
import 'package:proformas/repositories/impuestorepository.dart';
import 'package:proformas/repositories/unidadRepository.dart';
import 'package:proformas/repositories/unidadmedidarepository.dart';
import 'package:proformas/services/articuloservice.dart';
import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/familiaservice.dart';
import 'package:proformas/services/impuestoservice.dart';
import 'package:proformas/services/marcaservice.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/services/unidadmedidaservice.dart';
import 'package:proformas/services/unidadservice.dart';

class NewArticuloViewModel extends ChangeNotifier {
  BuildContext? _context ;
  //states
  bool loadingContent = false;
  String msjLoading = '';

  final ConfigService _configService = ConfigService();
  final FamiliaRepository _familiaRepository = FamiliaRepository(FamiliaService(), ConfigService()); 
  final MarcaRepository _marcaRepository = MarcaRepository(MarcaService(), ConfigService()); 
  final ImpuestoRepository _impuestoRepository = ImpuestoRepository(ImpuestoService(), ConfigService()); 
  final UnidadMedidaRepository _unidadMedidaRepository = UnidadMedidaRepository(UnidadMedidaService(), ConfigService()); 
  final UnidadRepository _unidadRepository = UnidadRepository(UnidadService(), ConfigService()); 
  final ArticuloRepository _repository = ArticuloRepository(ArticuloService(), ConfigService());
  List<Familia> familias = [] ;
  List<Marca> marcas = [] ;
  List<Impuesto> impuestos = [] ;
  List<UnidadMedida> um = [] ;
  List<Unidad> ud = [] ;
  bool useBroadCast = false ;
  TextEditingController descripcionController  =  TextEditingController(); 
  TextEditingController cabysController  =  TextEditingController(); 
  PageController pageController = PageController();
  
  //preciosController
  TextEditingController costoController  =  TextEditingController(text: '0'); 
  TextEditingController utilidadController  =  TextEditingController(text: '0'); 
  TextEditingController ventaController  =  TextEditingController(text: '0'); 

  //topesDescuentosController
  TextEditingController topeDescuento1Controller  =  TextEditingController(text: '100'); 
  TextEditingController topeDescuento2Controller  =  TextEditingController(text: '100'); 
  TextEditingController topeDescuento3Controller  =  TextEditingController(text: '100'); 

  //codigoController
  TextEditingController codigoController  =  TextEditingController(); 

  //Volumen y peso y factorUnidadMedida Controller
  TextEditingController volumenController = TextEditingController(text: '0');
  TextEditingController pesoController = TextEditingController(text: '0');
  TextEditingController factorUnidadMedidaController = TextEditingController(text: '1');

  Articulo? articulo ;



 void init(BuildContext context, String? codigo) async {
    _context = context ;
    if ( codigo != null ){
      codigoController.text = codigo;
    }

    await _configService.toConfig().then(((value) async {
    if ( value ){
      Navigator.of(context).pushReplacementNamed('config');
    } else {

      await _getFamilias().onError((error, stackTrace) {
         Dlg.showError( _context! , error.toString());
      });
      await _getMarcas().onError((error, stackTrace) {
         Dlg.showError( _context! , error.toString());
      });
      await _getImpuestos().onError((error, stackTrace) => Dlg.showError( _context! , error.toString()));
      await _getUnidadesMedida().onError((error, stackTrace) {
        if (context.mounted){
          Dlg.showError(context, error.toString());
        }
      });
      await _getUnidades().onError((error, stackTrace) {
        if (context.mounted){
          Dlg.showError(context, error.toString());
        }
      });
      
      _initArticulo( codigo );
      setDefaultValues();

    }
  }));

 }

 void setDefaultValues(){
  Unidad? unidad = getLastUnidad();
  UnidadMedida? unidadMedida = getLastUnidadMedida();
  Impuesto? impuesto = getImpuestoByPorcentaje(13);
  articulo?.unidadEmpaque = unidad?.unidad;
  articulo?.unidadVenta = unidad?.unidad;
  articulo?.unidadCompra = unidad?.unidad;
  articulo?.unidadMedida = unidadMedida?.unidadMedida;
  articulo?.codImpuesto = impuesto?.codImpuesto;
  articulo?.impuesto = impuesto;
  notifyListeners();
 }


 void _initArticulo(String? codArticulo){
   articulo = Articulo(
    codArticulo: codArticulo,
    costo: 0,
    porcentajeUtilidad: 0,
    venta: 0,
    impuesto: impuestos.isNotEmpty ? impuestos[0] : Impuesto(
      porcentaje: 0
    ),
    aplicaInventario: 'S',
    permiteVentaUnitaria: 'S',
    artGranel: 'N',
    habilitarCambiarPrecio: 'N',
    artControl: 'N',
    articuloRomana: 'N',
    pesadoAutomatico: 'N',
    ventaLibre: 'N',
    servicioSalud: 'N',
    bonificacion: 'N',
    activarArticulosRelacionados: 'N',
    aplicaComandas: 'N',
    articuloRelacionadoAgrupador: 'N',
    aplicaTimbreOdontologico: 'N',
    articuloConSerie: 'N',
    volumen: 0,
    peso: 0,
    factorMedida: 1,
    porcTopeDescuento1: 100,
    porcTopeDescuento2: 100,
    porcTopeDescuento3: 100,
  );
 }

  Future<dynamic> insertArticulo() async {
    if ( articulo == null ) return ;
    Map<String, dynamic> resp = await _repository.insertArticulo(articulo!);
    return resp ;
  }

  Future<void> _getFamilias() async {
    loadingContent = true ;
    msjLoading = 'Obteniendo familias..';
    notifyListeners();

    Map<String, dynamic> resp = await _familiaRepository.getFamilias();

    if ( resp['statusCode'] == 200 ){
      familias = resp['familias'].map<Familia>((e) => Familia.fromMap(e)).toList();
      notifyListeners();
    }

  }

  Future<void> _getMarcas() async {
    msjLoading = 'Obteniendo marcas..';
    notifyListeners();

    Map<String, dynamic> resp = await _marcaRepository.getMarcas();

    if ( resp['statusCode'] == 200 ){
      marcas = resp['marcas'].map<Marca>((e) => Marca.fromMap(e)).toList();
      notifyListeners();
    }
  }

  Future<void> _getImpuestos() async {
    msjLoading = 'Obteniendo impuestos..';
    notifyListeners();

    Map<String, dynamic> resp = await _impuestoRepository.getImpuestos();

    if ( resp['statusCode'] == 200 ){
      impuestos = resp['impuestos'].map<Impuesto>((e) => Impuesto.fromMap(e)).toList();
      notifyListeners();
    }
  }

  Future<void> _getUnidadesMedida() async {
    msjLoading = 'Obteniendo unidades de medida..';
    notifyListeners();

    Map<String, dynamic> resp = await  _unidadMedidaRepository.getUnidadesMedida();

    if ( resp['statusCode'] == 200 ) {
      um = resp['unidades_medida'].map<UnidadMedida>((e) => UnidadMedida.fromMap(e)).toList();
      notifyListeners();
    }
  }

  Future<void> _getUnidades() async {
    msjLoading = 'Obteniendo unidades..';
    notifyListeners();
    
    Map<String, dynamic> resp = await  _unidadRepository.getUnidades();

    if ( resp['statusCode'] == 200 ) {
      ud = resp['unidades'].map<Unidad>((e) => Unidad.fromMap(e)).toList();
      notifyListeners();
    }
    loadingContent = false;
    notifyListeners();
  }


  void setCodigoImpuestoCabysByImp( int? porcentaje ){
    for ( int x = 0 ; x <= impuestos.length-1; x++ ){
      if ( impuestos[x].porcentaje == porcentaje ){
        articulo?.codImpuestoCabys =  impuestos[x].codImpuesto;
        notifyListeners();
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

  
  Impuesto? getImpuestoByPorcentaje( int porcentaje ){
    for ( int x = 0 ; x <= impuestos.length-1; x++ ){
      if ( impuestos[x].porcentaje == porcentaje ){
        return impuestos[x];
      }
    }
    return null;
  }

  UnidadMedida? getUnidadMedidaByCodigo( String codigo ){
    for ( int x = 0 ; x <= um.length-1; x++ ){
      if ( um[x].unidadMedida == codigo ){
        return um[x];
      }
    }
    return null;
  }

  Unidad? getUnidadByCodigo( String codigo ){
    for ( int x = 0 ; x <= ud.length-1; x++ ){
      if ( ud[x].unidad == codigo ){
        return ud[x];
      }
    }
    return null;
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

    articulo?.venta = venta ;
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

  Unidad? getLastUnidad(){
    if ( ud.isNotEmpty ){
      return ud[ ud.length -1];
    } else {
      return null;
    }
  }

  UnidadMedida? getLastUnidadMedida(){
    if ( um.isNotEmpty ){
      return um[ um.length -1];
    } else {
      return null;
    }
  }

  void nL(){
    notifyListeners();
  }
}