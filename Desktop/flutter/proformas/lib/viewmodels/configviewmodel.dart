import 'package:flutter/material.dart';
import 'package:proformas/models/conexion.dart';
import 'package:proformas/services/configservice.dart';


class ConfigViewModel extends ChangeNotifier {

  final ConfigService _configService = ConfigService();
  bool? useBroadCast = false;
  
  void init( BuildContext context, TextEditingController host, TextEditingController port, TextEditingController broadcast) async {
    useBroadCast = getUseBroadCast();
    broadcast.text = getBroadCastLink() ?? '';
    Con con = await getCon();
    host.text = con.host ?? '';
    port.text = con.port.toString();
  }

  bool? getUseBroadCast(){
    return _configService.getUseBroadcast();
  }

  String? getBroadCastLink(){
    return _configService.getBroadCastReceiverLink();
  }

  Future<Con> getCon() async {
    return await _configService.getCon();
  }

  Future<void> setConfig( String host, String port, String broadcastLink ) async {
    await _configService.setConfig( Con(host: host, port:  int.parse(port)), useBroadCast ?? false, broadcastLink);
  }

  void setUseBroadcast( bool useBroadCast){
    this.useBroadCast = useBroadCast;
    notifyListeners();
  }

  bool validarText(String host, String port) {
    if ( host.isEmpty || port.isEmpty ) return false ;
    return true;
  }


}