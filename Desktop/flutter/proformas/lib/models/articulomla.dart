// To parse this JSON data, do
//
//     final articulo = articuloFromMap(jsonString);

import 'dart:convert';

class ArticuloMla {
    String? codArticulo;
    double? costo;
    double? venta;

    ArticuloMla({
        this.codArticulo,
        this.costo,
        this.venta
    });

    ArticuloMla copyWith({
        String? codArticulo,
        double? costo,
        double? venta,
    }) => 
        ArticuloMla(
            codArticulo: codArticulo ?? this.codArticulo,
            costo: costo ?? this.costo,
            venta: venta ?? this.venta,
        );

    factory ArticuloMla.fromJson(String str) => ArticuloMla.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ArticuloMla.fromMap(Map<String, dynamic> json) => ArticuloMla(
        codArticulo: json["cod_articulo"],
        costo: json["costo"].toDouble(),
        venta: json["venta"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "cod_articulo": codArticulo,
        "costo": costo,
        "venta": venta,
    };
}

