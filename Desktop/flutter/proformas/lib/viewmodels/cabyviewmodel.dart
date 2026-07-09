import 'package:flutter/material.dart';
import 'package:proformas/models/cabys.dart';
import 'package:proformas/repositories/cabyrepository.dart';
import 'package:proformas/services/cabyservice.dart';


class CabyViewModel extends ChangeNotifier {
  final CabyRepository _service = CabyRepository(CabyService()); 
  TextEditingController cabysController = TextEditingController();

  Cabys cabys  = Cabys(
    total: 0,
    cantidad: 0,
    cabys: [],
  );

  void init(){}


  Future<void> getCabys( String wordKey ) async {

    cabys = await _service.getCabys(wordKey);
    notifyListeners();

  }

}