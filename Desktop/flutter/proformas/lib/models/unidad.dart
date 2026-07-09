// To parse this JSON data, do
//
//     final unidad = unidadFromMap(jsonString);

import 'dart:convert';

class Unidad {
    String? unidad;
    String? descripcion;
    String? abreviatura;
    String? tipoUnidad;
    String? activo;
    String? creadoPor;
    DateTime? fechaCreacion;
    String? modificadoPor;
    DateTime? fechaModificacion;
    String? notas;
    String? factor;
    String? unidadDefault;

    Unidad({
        this.unidad,
        this.descripcion,
        this.abreviatura,
        this.tipoUnidad,
        this.activo,
        this.creadoPor,
        this.fechaCreacion,
        this.modificadoPor,
        this.fechaModificacion,
        this.notas,
        this.factor,
        this.unidadDefault,
    });

    Unidad copyWith({
        String? unidad,
        String? descripcion,
        String? abreviatura,
        String? tipoUnidad,
        String? activo,
        String? creadoPor,
        DateTime? fechaCreacion,
        String? modificadoPor,
        DateTime? fechaModificacion,
        String? notas,
        String? factor,
        String? unidadDefault,
    }) => 
        Unidad(
            unidad: unidad ?? this.unidad,
            descripcion: descripcion ?? this.descripcion,
            abreviatura: abreviatura ?? this.abreviatura,
            tipoUnidad: tipoUnidad ?? this.tipoUnidad,
            activo: activo ?? this.activo,
            creadoPor: creadoPor ?? this.creadoPor,
            fechaCreacion: fechaCreacion ?? this.fechaCreacion,
            modificadoPor: modificadoPor ?? this.modificadoPor,
            fechaModificacion: fechaModificacion ?? this.fechaModificacion,
            notas: notas ?? this.notas,
            factor: factor ?? this.factor,
            unidadDefault: unidadDefault ?? this.unidadDefault,
        );

    factory Unidad.fromJson(String str) => Unidad.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Unidad.fromMap(Map<String, dynamic> json) => Unidad(
        unidad: json["unidad"],
        descripcion: json["descripcion"],
        abreviatura: json["abreviatura"],
        tipoUnidad: json["tipo_unidad"],
        activo: json["activo"],
        creadoPor: json["creado_por"],
        fechaCreacion: DateTime.parse(json["fecha_creacion"]),
        modificadoPor: json["modificado_por"],
        fechaModificacion: DateTime.parse(json["fecha_modificacion"]),
        notas: json["notas"],
        factor: json["factor"],
        unidadDefault: json["unidad_default"],
    );

    Map<String, dynamic> toMap() => {
        "unidad": unidad,
        "descripcion": descripcion,
        "abreviatura": abreviatura,
        "tipo_unidad": tipoUnidad,
        "activo": activo,
        "creado_por": creadoPor,
        "fecha_creacion": fechaCreacion?.toIso8601String(),
        "modificado_por": modificadoPor,
        "fecha_modificacion": fechaModificacion?.toIso8601String(),
        "notas": notas,
        "factor": factor,
        "unidad_default": unidadDefault,
    };
}
