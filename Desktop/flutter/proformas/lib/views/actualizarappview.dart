import 'package:flutter/material.dart';
import 'package:proformas/viewmodels/updateappviewmodel.dart';
import 'package:proformas/widgets/modelready.dart';
import 'package:provider/provider.dart';

class ActualizarAppView extends StatefulWidget {
  const ActualizarAppView({Key? key, this.appUrl, this.versionName}) : super(key: key);
  final String? appUrl ;
  final String? versionName ;

  @override
  State<ActualizarAppView> createState() => _ActualizarAppViewState();

}

class _ActualizarAppViewState extends State<ActualizarAppView> {

  @override
  Widget build(BuildContext context) {
    const   textColor = Colors.white;
    const  String fileName = 'apprelease.apk';
    return ChangeNotifierProvider(
      create: (_) => UpdateAppViewModel(),
      child: ModelReady<UpdateAppViewModel>(
        onModelReady: (UpdateAppViewModel model)async{
          model.init(widget.appUrl!, fileName);
        },
        child:Consumer<UpdateAppViewModel>(
          builder: ((context, model, child){
            return Scaffold(
              body:  Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.red,
                      Colors.blue
                    ]
                  )
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Descargando nueva version', style: TextStyle(color: textColor, fontSize: 20)),
                      const SizedBox(height: 10,),
                      Text('version: ${widget.versionName}', style: const TextStyle(color: textColor, fontSize: 14)),
                      const SizedBox(height: 30,),
                      Text('${model.downloadingProgress.toStringAsFixed(0)} %', style: const TextStyle(color: textColor, fontSize: 40)),
                      const SizedBox(height: 30,),
                    ],
                  ),
                ),
              )

            );
          })
        ), 
      ),
    );
  }
}