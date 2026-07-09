import 'package:proformas/models/conexion.dart';
import 'package:proformas/providers/configprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:context_holder/context_holder.dart';

class ConfigService {

  static final ConfigService _instance = ConfigService.internal();

  ConfigService.internal();  

  factory ConfigService() => _instance ;

  Future<bool> toConfig()  async {
    final SharedPreferences prefs = await  SharedPreferences.getInstance();
    if ( !prefs.containsKey('host') || !prefs.containsKey('port')){
      return true;
    }
    //Si todo ok pasar parametros a ConfigProvider
    String? host = prefs.getString('host');
    int? port = prefs.getInt('port');
    bool? useBroadCast = prefs.getBool('usebroadcast');
    String? broadcastLink = prefs.getString('broadcastlink');
    await setConfigToProvider(Con(host: host, port: port), useBroadCast, broadcastLink);

    return false ;
  }

  Future<void> setConfigToProvider(Con con, bool? useBroadCast, String? broadcastLink ) async {
    //Put params to ConfigProvider
    ConfigProvider configProvider = Provider.of<ConfigProvider>(ContextHolder.currentContext, listen: false);
    configProvider.setCon(con); 
    configProvider.setUseBroadcast(useBroadCast!);
    configProvider.setBroadCastLink(broadcastLink!);
  }

  Future<void> setConfig(Con con, bool useBroadCast, String broadcastLink ) async {
    
    //Put params to ConfigProvider
    ConfigProvider configProvider = Provider.of<ConfigProvider>(ContextHolder.currentContext, listen: false);
    configProvider.setCon(con);

    //Put params to SharedPreferences
    final SharedPreferences prefs = await  SharedPreferences.getInstance();
    prefs.setString('host', con.host!);
    prefs.setInt('port', con.port!);
    prefs.setBool('usebroadcast', useBroadCast);
    prefs.setString('broadcastlink', broadcastLink);

  }

  String getBaseUrl()  {
    ConfigProvider configProvider = Provider.of<ConfigProvider>(ContextHolder.currentContext, listen: false);
    Con? con = configProvider.getCon();
    return "${con!.host}:${con.port}";
  }

  bool? getUseBroadcast()  {
    ConfigProvider configProvider = Provider.of<ConfigProvider>(ContextHolder.currentContext, listen: false);
    return configProvider.getUseBroadCast();
  }

  String? getBroadCastReceiverLink()  {
    ConfigProvider configProvider = Provider.of<ConfigProvider>(ContextHolder.currentContext, listen: false);
    return configProvider.getBroadCastLink();
  }

  Future<Con> getCon() async {
    final SharedPreferences prefs = await  SharedPreferences.getInstance();
    final String? host = prefs.getString('host',);
    final int? port = prefs.getInt('port');
    return Con(host: host, port: port);
  }

}