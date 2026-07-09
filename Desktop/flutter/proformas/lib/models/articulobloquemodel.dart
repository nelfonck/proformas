import 'package:proformas/models/articulo.dart';

class ArticuloBloque{
  final String? codigo;
  final String? descripcion;
  bool? ingresado ;
  final Articulo? articuloMla;

  ArticuloBloque({
    this.codigo,
    this.descripcion,
    this.ingresado = false,
    this.articuloMla,
  });

  Map<String,dynamic> toMap(){
    return {
      'codigo' : codigo,
      'descripcion': descripcion,
      'ingresado': ingresado,
      'articulomla': articuloMla?.toMap()
    };
  }

  factory ArticuloBloque.fromMap(Map<String,dynamic> map){
    return ArticuloBloque(
      codigo: map['codigo'],
      descripcion: map['descripcion'],
      ingresado: map['ingresado'] ?? false,
      articuloMla: map['articulomla'] != null
        ? Articulo.fromMap(map['articulomla'])
        : null,
    );
  }

}