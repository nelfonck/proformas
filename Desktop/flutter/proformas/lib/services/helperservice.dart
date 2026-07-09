import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class HelperService {

  static Future<DateTime?> selectDate(BuildContext context, DateTime from) async {
    DateTime selectedDate = from;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
     selectedDate = picked;
    }
    return selectedDate;
  }

  static DateTime firstDayOfMonth(DateTime date){
    String month = (date.month.toString().length == 1) ? '0${date.month}' : date.month.toString();
    String formatedDate = '${date.year}-$month-01';
    return DateTime.parse(formatedDate);
  }

  static Future<void> mostrarBase64(BuildContext context, String base64 ) async {
   final TextEditingController textEditingController = TextEditingController( text: base64 );
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
          controller: textEditingController,
          decoration: const InputDecoration(
            border: OutlineInputBorder()
          ),
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'))
        ],
        );
      });
      
  }

  static Future<String?> chooseNumber(BuildContext context, List<String> numbers) async{
    return showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text('Elige un numero'),
          content: SizedBox(
            height: 200,
            width: 200,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: numbers.length,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(numbers[index]);
                  },
                  child: Card(
                     child: Padding(
                       padding: const EdgeInsets.all(14),
                       child: Text(numbers[index]),
                     ),
                  ),
                );
              })
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop('-1');
              }, 
              child: const Text('Cancelar', style:  TextStyle(color: Colors.grey),),
            ),
            TextButton(
              onPressed: (){
                Navigator.of(context).pop(null);
              }, 
              child: const Text('Otro numero'),
            ),
          ],
        );
      }
    );
  }


  static  void selectText( TextEditingController? textEditingController ){
    Future.delayed(const Duration(milliseconds: 500), () {
      textEditingController?.selection = TextSelection(
        baseOffset: 0,
        extentOffset: textEditingController.value.text.length,
      );
    });
  }
  static  void selectTextNoTime( TextEditingController? textEditingController ){
    Future.delayed(Duration.zero, () {
      textEditingController?.selection = TextSelection(
        baseOffset: 0,
        extentOffset: textEditingController.value.text.length,
      );
    });
  }



  static String boolToChar( bool? value ){
    if ( value == null ){
      return 'N';
    }
    switch (value) {
      case true:
        return 'S';
      case false:
        return 'N';
      }
  }

  static bool charToBool( String? char ){
    if ( char == null ){
      return false;
    }
    switch (char) {
      case 'S':
        return true;
      case 'N':
        return false;
      default:
        return false ;
    }
  }

  static String uint8ListToBase64String(Uint8List? data){
    if (data==null){
      return '';
    }
    return base64Encode(data);
  }

  static Uint8List base64StringToUnit8List(String data){
    return  Uint8List.fromList(base64Decode(data));
  }

}
