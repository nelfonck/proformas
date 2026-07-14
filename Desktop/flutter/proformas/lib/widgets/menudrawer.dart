import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proformas/consts/globals.dart';
import 'package:proformas/providers/userprovider.dart';
import 'package:proformas/repositories/usuariorepository.dart';
import 'package:proformas/services/configservice.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/services/usuarioservice.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    super.key
  });


  @override
  Widget build(BuildContext context) {

    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    UsuarioReposotory userRepository = UsuarioReposotory(UsuarioService(), ConfigService());

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
           SizedBox(
            height: 150,
             child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  const Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Expanded(child: Container(),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.person, color: Colors.white),
                      Text(
                        userProvider.getUsuario()?.nombre ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
                     ),
           ),
          ListTile(
            leading: const Icon(Icons.document_scanner),
            title: const Text('Proformas'),
            onTap: () {
              Navigator.pop(context); // Cerrar el drawer

              Navigator.pushNamedAndRemoveUntil(
                context,
                'history',
                (route) => false,
                );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shape_line),
            title: const Text('Artículos'),
            onTap: () async{
              if (userProvider.getUsuario()?.superusuario == 'S'){
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  'articulo',
                  (route) => false,
                  ); 
              } else {
                await userRepository.existeAccion(context, 'inv-mant-articulo').then((value) {
                  Map<String,dynamic> resp = value;
                  if (resp['statusCode'] == 200){
                    if (resp['existe_accion']){
                      if (context.mounted){
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          'articulo',
                          (route) => false,
                          );
                      }
                    }else{
                      if (context.mounted){
                        Dlg.showWarning(context, 'El usuario ${userProvider.getUsuario()?.nombre} no tiene privilegios para mantenimiento de artículos');
                      }
                    }
                  }
                });
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.print),
            title: const Text('Habladores'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                'habladores',
                (route) => false,
                );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_road),
            title: const Text('Insertar articulos en bloque'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                'articulosbloque',
                (route) => false,
                );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Ayuda'),
            onTap: () {
              _launchURLBrowser(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Salir'),
            onTap: () async{
              exit(0);
              
            },
          ),
        ],
      ),
    );
  }

  
Future<void> _launchURLBrowser(BuildContext context) async {
    var url = Uri.parse(Globals.ayudaUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // ignore: use_build_context_synchronously
      Dlg.showSnackbar(context, 'Could not launch $url');
    }
  }

}
