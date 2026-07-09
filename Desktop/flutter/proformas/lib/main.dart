import 'package:context_holder/context_holder.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proformas/providers/bodegaprovider.dart';
import 'package:proformas/providers/companiaprovider.dart';
import 'package:proformas/providers/configprovider.dart';
import 'package:proformas/providers/userprovider.dart';
import 'package:proformas/views/articulopageview.dart';
import 'package:proformas/views/configview.dart';
import 'package:proformas/views/habladoresview.dart';
import 'package:proformas/views/historyview.dart';
import 'package:proformas/views/loginview.dart';
import 'package:proformas/views/newarticulosbloqueview.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };
  await Hive.initFlutter();
  await Hive.openBox('hivebox');
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => UserProvider()),
        ChangeNotifierProvider(create: ( _ ) => BodegaProvider()),
        ChangeNotifierProvider(create: ( _ ) => ConfigProvider()),
        ChangeNotifierProvider(create: ( _ ) => CompaniaProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Listener(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorKey: ContextHolder.key,
        routes:{
          'history' : ( _ ) => const HistoryView(),
          'articulo' : ( _ ) => const ArticuloPageView(),
          'login': ( _ ) =>  const LoginView(),
          'config': ( _ ) =>  const ConfigView(),
          'habladores': ( _ ) =>  const HabladoresView(),
          'articulosbloque': ( _ ) =>  const NewArticulosBloqueView(),
        },
        initialRoute: 'login',
      ),
    );
  }
}


