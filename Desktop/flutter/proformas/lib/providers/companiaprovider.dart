import 'package:flutter/material.dart';
import 'package:proformas/models/compania.dart';

class CompaniaProvider extends ChangeNotifier{

  Compania? _compania;
  
  void setCompania( Compania? compania){
    _compania = compania ;
  }

  Compania? getCompania(){
    return _compania ;
  }
}