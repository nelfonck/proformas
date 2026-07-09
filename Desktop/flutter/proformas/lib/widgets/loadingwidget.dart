import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, this.msj}) : super(key: key);

  final String? msj ;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text( msj?? 'Cargando'),
          const SizedBox(height: 10,),
          const CircularProgressIndicator()
        ],
      ),
    );
  }
}