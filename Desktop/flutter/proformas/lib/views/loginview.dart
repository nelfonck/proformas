import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:proformas/models/bodega.dart';
import 'package:proformas/models/usuario.dart';
import 'package:proformas/providers/bodegaprovider.dart';
import 'package:proformas/providers/companiaprovider.dart';
import 'package:proformas/providers/userprovider.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/viewmodels/loginviewmodel.dart';
import 'package:proformas/views/historyview.dart';
import 'package:proformas/widgets/modelready.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController userController = TextEditingController();
    TextEditingController passController = TextEditingController();
    BodegaProvider bodega = Provider.of<BodegaProvider>(context, listen: false);
    UserProvider user =  Provider.of<UserProvider>(context, listen: false);
    CompaniaProvider compania =  Provider.of<CompaniaProvider>(context, listen: false);

    return  ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: ModelReady<LoginViewModel>(
        onModelReady: (LoginViewModel model) async{
          model.init( context );
        },
        child: Consumer<LoginViewModel>(builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Pre-proformas'),
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: (){
                    Navigator.of(context).pushReplacementNamed('config');
                  },
                  icon: const Icon(Icons.settings)
                )
              ],
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person, color: Colors.orange, size: 82,),
                    const Text('Iniciar sesion'),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: userController,
                      decoration: const InputDecoration(
                        labelText: 'Usuario',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passController,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    Visibility(
                      visible: model.loading,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.grey,)
                          ),
                          Text(' Cargando bodegas...'),
                        ],
                      ),
                    ),
                    DropdownSearch<Bodega>(
                      selectedItem: model.lastUsedBodega,
                      onChanged: (value){
                          bodega.setBodega( value );
                      },
                      items: model.bodegas,
                      itemAsString: (Bodega m) => m.descripcion!,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Bodega",
                          border: OutlineInputBorder()
                        )
                    ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: (){},
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue
                          ),
                          child: const Text('Cancelar', style: TextStyle(color: Colors.white),)
                        ),
                        const SizedBox(width: 10,),
                        TextButton(
                          onPressed: () async {
                          if (model.loading) 
                          {
                            Dlg.showWarningSnackbar(context, 'Espere porfavor');
                            return;
                          }
                          await model.getUsuario(userController.text, passController.text).onError((error, stackTrace) {
                            if (context.mounted){
                              Dlg.showError(context, error.toString());
                            }
                          }).then((value){
                              if ( value['statusCode'] == 201 ){
                                if (context.mounted){
                                  Dlg.showError(context, value['message']);
                                }
                
                              } else if ( value['statusCode'] == 200 ){
                
                                if ( bodega.getBodega() == null ) {
                                  if (context.mounted){
                                    Dlg.showWarning(context, 'SE DEBE ELEGIR UNA BODEGA');
                                  }
                                  return ;
                                }
                
                                final Usuario usuario = Usuario.fromMap( value['usuario'] );
                                user.setUsuario( usuario );

                                compania.setCompania( model.compania );

                                model.setLastUsedBodega(bodega.getBodega());

                                model.setLastCompany( model.compania );
                
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: ( (context) => HistoryView(compania: compania.getCompania(),))
                                  )
                                );
                              }
                          });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.orange
                          ),
                          child: const Text('Iniciar sesion', style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        );
          
        },), 
      ),
    );
  }
}

