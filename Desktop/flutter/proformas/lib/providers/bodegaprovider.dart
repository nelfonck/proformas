import 'package:flutter/material.dart';
import 'package:proformas/models/bodega.dart';

class BodegaProvider extends ChangeNotifier{

  Bodega? _bodega;
  
  void setBodega( Bodega? bodega){
    _bodega = bodega ;
  }

  Bodega? getBodega(){
    return _bodega ;
  }
}