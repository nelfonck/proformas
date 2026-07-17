import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:context_holder/context_holder.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Dlg {
  
  static Future<Object> showError(BuildContext context, String error) async {
    return AwesomeDialog(
      width: 400,
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      headerAnimationLoop: false,
      title: 'Error',
      desc: error,
      btnOkOnPress: () {
        //Navigator.of(context).pop();
      },
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red,
    ).show();
  }

  static Future<Object> showWarning(BuildContext context, String error) async {
    return AwesomeDialog(
      width: 400,
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      headerAnimationLoop: false,
      title: 'Warning',
      desc: error,
      btnOkOnPress: () {
        //Navigator.of(context).pop();
      },
      btnOkIcon: Icons.cancel,
    
    ).show();
  }

  static Future<Object> showInfo(BuildContext context, String msg) async {
    return AwesomeDialog(
      width: 400,
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      headerAnimationLoop: false,
      title: 'Info',
      btnOkOnPress: (){},
      desc: msg
    ).show();
  }


  static Future<bool> confirm(BuildContext context, String msg) async {
    return  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Column(
          children: [
            Icon(Icons.warning, color: Colors.orange, size: 62,),
            Text('Aviso', style: TextStyle(color: Colors.orange),),
          ],
        ),
        content:  Text(msg),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue
            ),
            child: const Text("SI", style: TextStyle(color: Colors.white), ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey
            ),
            child: const Text("NO", style: TextStyle(color: Colors.white), ),
          ),
        ],
      );
    },
  );
  }

  static Future<bool?> confirmUpdate(String version, String features) async {
    return showDialog(
      context: ContextHolder.currentContext,
      builder: (context) {
        return AlertDialog(
          title: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Image(image: AssetImage('assets/update.png'))
              ),
              SizedBox(height: 20,),
              Text('Actualizacion disponible'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Version: $version'),
              const SizedBox(height: 10,),
              const Text('Novedades:', style: TextStyle(color: Colors.grey),),
              Text(features),
            ],
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop(false);
              },
              child: const Text('CANCELAR', style: TextStyle(color: Colors.blueGrey),)
            ),
            TextButton(
              onPressed: (){
                Navigator.of(context).pop(true);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.lightGreen,
              ),
              child: const Text('ACTUALIZAR', style: TextStyle(color: Colors.white),)
            ),
          ],
        );
      }
    );
  }

  static void showSnackbar(BuildContext context, String message) {
      final snackBar = SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

  static void showSnackbarDuration(BuildContext context, String message, int ms){
      final snackBar = SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        duration:  Duration(milliseconds: ms),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    static void showWarningSnackbar(BuildContext context, String message) {
      final snackBar = SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(message, style: const TextStyle(color: Colors.white),),
        backgroundColor: Colors.orange,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

  static Future<Widget?> showLoading( BuildContext context, String message){
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:  [
              Text( message ),
              const SizedBox(height: 20,),
              const CircularProgressIndicator(),
            ],
          ),
        );
      }
    );
  }
  static Future<Widget?> showDogWaiting( BuildContext context, String message){
    return showDialog(
      context: context,
      barrierDismissible: false, // <- No se puede cerrar tocando fuera
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:  [
              Lottie.asset(
                'assets/animations/dog_waiting.json',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20,),
              Text( message ,style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),),
            ],
          ),
        );
      }
    );
  }

}

 
