import 'package:context_holder/context_holder.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proformas/providers/bodegaprovider.dart';
import 'package:proformas/providers/configprovider.dart';
import 'package:proformas/providers/userprovider.dart';
import 'package:proformas/views/configview.dart';
import 'package:proformas/views/loginview.dart';
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
  const AppState({super.key, });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => UserProvider()),
        ChangeNotifierProvider(create: ( _ ) => BodegaProvider()),
        ChangeNotifierProvider(create: ( _ ) => ConfigProvider())
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Listener(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontSize: 20),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue, // cambia a tu color de marca
            brightness: Brightness.light,
          ),

          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white, // texto e íconos
            elevation: 2,
            centerTitle: true,
          ),
          tabBarTheme: const TabBarThemeData(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
          ),
        ),
        navigatorKey: ContextHolder.key,
        routes:{
          'login': ( _ ) =>  const LoginView(),
          'config': ( _ ) =>  const ConfigView(),
        },
        initialRoute: 'login',
      ),
    );
  }
}


