// To parse this JSON data, do
//
//     final bodega = bodegaFromMap(jsonString);

import 'dart:convert';

class Bodega {
    String? bodega;
    String? descripcion;
    String? activo;

    Bodega({
        this.bodega,
        this.descripcion,
        this.activo,
    });

    Bodega copyWith({
        String? bodega,
        String? descripcion,
        String? activo,
    }) => 
        Bodega(
            bodega: bodega ?? this.bodega,
            descripcion: descripcion ?? this.descripcion,
            activo: activo ?? this.activo,
        );

    factory Bodega.fromJson(String str) => Bodega.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Bodega.fromMap(Map<String, dynamic> json) => Bodega(
        bodega: json["bodega"],
        descripcion: json["descripcion"],
        activo: json["activo"],
    );

    Map<String, dynamic> toMap() => {
        "bodega": bodega,
        "descripcion": descripcion,
        "activo": activo,
    };
}
