// To parse this JSON data, do
//
//     final proveedor = proveedorFromJson(jsonString);

import 'dart:convert';

Proveedor proveedorFromJson(String str) => Proveedor.fromJson(json.decode(str));

String proveedorToJson(Proveedor data) => json.encode(data.toJson());

class Proveedor {
    String codProveedor;
    String razsocial;
    String identificacion;

    Proveedor({
        required this.codProveedor,
        required this.razsocial,
        required this.identificacion,
    });

    Proveedor copyWith({
        String? codProveedor,
        String? razsocial,
        String? identificacin,
    }) => 
        Proveedor(
            codProveedor: codProveedor ?? this.codProveedor,
            razsocial: razsocial ?? this.razsocial,
            identificacion: identificacin ?? this.identificacion,
        );

    factory Proveedor.fromJson(Map<String, dynamic> json) => Proveedor(
        codProveedor: json["cod_proveedor"],
        razsocial: json["razsocial"],
        identificacion: json["identificación"],
    );

    Map<String, dynamic> toJson() => {
        "cod_proveedor": codProveedor,
        "razsocial": razsocial,
        "identificación": identificacion,
    };
}
