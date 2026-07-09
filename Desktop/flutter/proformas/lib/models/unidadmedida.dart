// To parse this JSON data, do
//
//     final unidadMedida = unidadMedidaFromMap(jsonString);

import 'dart:convert';

class UnidadMedida {
    String? unidadMedida;
    String? descripcion;
    String? abreviatura;
    String? unidadHacienda;
    String? sistema;
    String? creadoPor;
    DateTime? fechaCreacion;
    String? modificadoPor;
    DateTime? fechaModificacion;

    UnidadMedida({
        this.unidadMedida,
        this.descripcion,
        this.abreviatura,
        this.unidadHacienda,
        this.sistema,
        this.creadoPor,
        this.fechaCreacion,
        this.modificadoPor,
        this.fechaModificacion,
    });

    UnidadMedida copyWith({
        String? unidadMedida,
        String? descripcion,
        String? abreviatura,
        String? unidadHacienda,
        String? sistema,
        String? creadoPor,
        DateTime? fechaCreacion,
        String? modificadoPor,
        DateTime? fechaModificacion,
    }) => 
        UnidadMedida(
            unidadMedida: unidadMedida ?? this.unidadMedida,
            descripcion: descripcion ?? this.descripcion,
            abreviatura: abreviatura ?? this.abreviatura,
            unidadHacienda: unidadHacienda ?? this.unidadHacienda,
            sistema: sistema ?? this.sistema,
            creadoPor: creadoPor ?? this.creadoPor,
            fechaCreacion: fechaCreacion ?? this.fechaCreacion,
            modificadoPor: modificadoPor ?? this.modificadoPor,
            fechaModificacion: fechaModificacion ?? this.fechaModificacion,
        );

    factory UnidadMedida.fromJson(String str) => UnidadMedida.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UnidadMedida.fromMap(Map<String, dynamic> json) => UnidadMedida(
        unidadMedida: json["unidad_medida"],
        descripcion: json["descripcion"],
        abreviatura: json["abreviatura"],
        unidadHacienda: json["unidad_hacienda"],
        sistema: json["sistema"],
        creadoPor: json["creado_por"],
        fechaCreacion: DateTime.parse(json["fecha_creacion"]),
        modificadoPor: json["modificado_por"],
        fechaModificacion: DateTime.parse(json["fecha_modificacion"]),
    );

    Map<String, dynamic> toMap() => {
        "unidad_medida": unidadMedida,
        "descripcion": descripcion,
        "abreviatura": abreviatura,
        "unidad_hacienda": unidadHacienda,
        "sistema": sistema,
        "creado_por": creadoPor,
        // ignore: prefer_null_aware_operators
        "fecha_creacion": fechaCreacion != null ?  fechaCreacion?.toIso8601String() : null,
        "modificado_por": modificadoPor,
        // ignore: prefer_null_aware_operators
        "fecha_modificacion": fechaModificacion   != null ? fechaModificacion?.toIso8601String() : null,
    };
}
