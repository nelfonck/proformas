// To parse this JSON data, do
//
//     final cabys = cabysFromMap(jsonString);

import 'dart:convert';

class Cabys {
    int? total;
    int? cantidad;
    List<Caby>? cabys;

    Cabys({
        this.total,
        this.cantidad,
        this.cabys,
    });

    Cabys copyWith({
        int? total,
        int? cantidad,
        List<Caby>? cabys,
    }) => 
        Cabys(
            total: total ?? this.total,
            cantidad: cantidad ?? this.cantidad,
            cabys: cabys ?? this.cabys,
        );

    factory Cabys.fromJson(String str) => Cabys.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Cabys.fromMap(Map<String, dynamic> json) => Cabys(
        total: json["total"],
        cantidad: json["cantidad"],
        cabys: List<Caby>.from(json["cabys"].map((x) => Caby.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "total": total,
        "cantidad": cantidad,
        "cabys": List<dynamic>.from(cabys!.map((x) => x.toMap())),
    };
}

class Caby {
    String? codigo;
    String? descripcion;
    List<String>? categorias;
    int? impuesto;
    String? uri;
    String? estado;

    Caby({
        this.codigo,
        this.descripcion,
        this.categorias,
        this.impuesto,
        this.uri,
        this.estado,
    });

    Caby copyWith({
        String? codigo,
        String? descripcion,
        List<String>? categorias,
        int? impuesto,
        String? uri,
        String? estado,
    }) => 
        Caby(
            codigo: codigo ?? this.codigo,
            descripcion: descripcion ?? this.descripcion,
            categorias: categorias ?? this.categorias,
            impuesto: impuesto ?? this.impuesto,
            uri: uri ?? this.uri,
            estado: estado ?? this.estado,
        );

    factory Caby.fromJson(String str) => Caby.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Caby.fromMap(Map<String, dynamic> json) => Caby(
        codigo: json["codigo"],
        descripcion: json["descripcion"],
        categorias: List<String>.from(json["categorias"].map((x) => x)),
        impuesto: json["impuesto"],
        uri: json["uri"],
        estado: json["estado"],
    );

    Map<String, dynamic> toMap() => {
        "codigo": codigo,
        "descripcion": descripcion,
        "categorias": List<dynamic>.from(categorias!.map((x) => x)),
        "impuesto": impuesto,
        "uri": uri,
        "estado": estado,
    };
}
