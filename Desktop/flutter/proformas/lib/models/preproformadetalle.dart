// To parse this JSON data, do
//
//     final preProformaDetalle = preProformaDetalleFromMap(jsonString);

import 'dart:convert';

class PreProformaDetalle {
    int? id;
    String? codigo;
    String? descripcion;
    double? cantidad;
    String? unidadVenta ;
    int? preproformaId ;
    double? porcImpuesto ;
    double? costo; 
    double? venta;
    double? total;
    String? porTopeDescuento1;
    String? porTopeDescuento2;
    String? porTopeDescuento3;
    double? porcDescuento;

    PreProformaDetalle({
        this.id,
        this.codigo,
        this.descripcion,
        this.cantidad,
        this.unidadVenta,
        this.preproformaId,
        this.porcImpuesto,
        this.costo,
        this.venta,
        this.total,
        this.porTopeDescuento1,
        this.porTopeDescuento2,
        this.porTopeDescuento3,
        this.porcDescuento
    });

    PreProformaDetalle copyWith({
        int? id,
        String? codigo,
        String? descripcion,
        double? cantidad,
        String? unidadVenta,
        int? preproformaId,
        double? porcImpuesto,
        double? costo,
        double? venta,
        double? total,
        String? porTopeDescuento1,
        String? porTopeDescuento2,
        String? porTopeDescuento3,
        double? porcDescuento
    }) => 
        PreProformaDetalle(
            id: id ?? this.id,
            codigo: codigo ?? this.codigo,
            descripcion: descripcion ?? this.descripcion,
            cantidad: cantidad ?? this.cantidad,
            unidadVenta: unidadVenta ?? this.unidadVenta,
            preproformaId: preproformaId ?? this.preproformaId,
            porcImpuesto: porcImpuesto ?? this.porcImpuesto,
            costo: costo ?? this.costo,
            venta: venta ?? this.venta,
            total: total ?? this.total,
            porTopeDescuento1: porTopeDescuento1 ?? this.porTopeDescuento1,
            porTopeDescuento2: porTopeDescuento2 ?? this.porTopeDescuento2,
            porTopeDescuento3: porTopeDescuento3 ?? this.porTopeDescuento3,
            porcDescuento: porcDescuento ?? this.porcDescuento

        );

   PreProformaDetalle.clone(PreProformaDetalle source)
      : id = source.id,
        codigo = source.codigo,
        descripcion = source.descripcion,
        cantidad = source.cantidad,
        unidadVenta = source.unidadVenta,
        preproformaId = source.preproformaId,
        porcImpuesto = source.porcImpuesto,
        costo = source.costo,
        venta = source.venta,
        total = source.total,
        porTopeDescuento1 = source.porTopeDescuento1,
        porTopeDescuento2 = source.porTopeDescuento2,
        porTopeDescuento3 = source.porTopeDescuento3,
        porcDescuento = source.porcDescuento;

    factory PreProformaDetalle.fromJson(String str) => PreProformaDetalle.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PreProformaDetalle.fromMap(Map<String, dynamic> json) => PreProformaDetalle(
        id: json["id"],
        codigo: json["codigo"],
        descripcion: json["descripcion"],
        cantidad: json["cantidad"].toDouble() ,
        unidadVenta: json["unidad_venta"] ,
        preproformaId: json["preproforma_id"],
        porcImpuesto: json["porc_impuesto"].toDouble(),
        costo: json["costo"].toDouble(),
        venta: json["venta"].toDouble(),
        total: json["total"].toDouble(),
        porTopeDescuento1: json["porc_tope_descuento_1"],
        porTopeDescuento2: json["porc_tope_descuento_2"],
        porTopeDescuento3: json["porc_tope_descuento_3"],
        porcDescuento: double.parse(json["porc_descuento"].toString()) ,

    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "codigo": codigo,
        "descripcion": descripcion,
        "cantidad": cantidad,
        "unidad_venta": unidadVenta,
        "preproforma_id": preproformaId,
        "porc_impuesto": porcImpuesto,
        "costo": costo,
        "venta": venta,
        "total": total,
        "porc_tope_descuento_1": porTopeDescuento1,
        "porc_tope_descuento_2": porTopeDescuento2,
        "porc_tope_descuento_3": porTopeDescuento3,
        "porc_descuento": porcDescuento,
    };
}
