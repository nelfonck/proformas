import 'dart:convert';

class Impuesto {
    String? codImpuesto;
    String? descripcion;
    int? porcentaje;
    String? tipo;
    String? activo;
    String? creadoPor;
    DateTime? fechaCreacion;
    String? modificadoPor;
    DateTime? fechaModificacion;
    String? sistema;
    String? tipoCredito;
    String? aplicaRegistroGastoManual;
    dynamic productoDefaultGasto;
    String? codigoTarifaHacienda;

    Impuesto({
        this.codImpuesto,
        this.descripcion,
        this.porcentaje,
        this.tipo,
        this.activo,
        this.creadoPor,
        this.fechaCreacion,
        this.modificadoPor,
        this.fechaModificacion,
        this.sistema,
        this.tipoCredito,
        this.aplicaRegistroGastoManual,
        this.productoDefaultGasto,
        this.codigoTarifaHacienda,
    });

    Impuesto copyWith({
        String? codImpuesto,
        String? descripcion,
        int? porcentaje,
        String? tipo,
        String? activo,
        String? creadoPor,
        DateTime? fechaCreacion,
        String? modificadoPor,
        DateTime? fechaModificacion,
        String? sistema,
        String? tipoCredito,
        String? aplicaRegistroGastoManual,
        dynamic productoDefaultGasto,
        String? codigoTarifaHacienda,
    }) => 
        Impuesto(
            codImpuesto: codImpuesto ?? this.codImpuesto,
            descripcion: descripcion ?? this.descripcion,
            porcentaje: porcentaje ?? this.porcentaje,
            tipo: tipo ?? this.tipo,
            activo: activo ?? this.activo,
            creadoPor: creadoPor ?? this.creadoPor,
            fechaCreacion: fechaCreacion ?? this.fechaCreacion,
            modificadoPor: modificadoPor ?? this.modificadoPor,
            fechaModificacion: fechaModificacion ?? this.fechaModificacion,
            sistema: sistema ?? this.sistema,
            tipoCredito: tipoCredito ?? this.tipoCredito,
            aplicaRegistroGastoManual: aplicaRegistroGastoManual ?? this.aplicaRegistroGastoManual,
            productoDefaultGasto: productoDefaultGasto ?? this.productoDefaultGasto,
            codigoTarifaHacienda: codigoTarifaHacienda ?? this.codigoTarifaHacienda,
        );

    factory Impuesto.fromJson(String str) => Impuesto.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Impuesto.fromMap(Map<String, dynamic> json) => Impuesto(
        codImpuesto: json["cod_impuesto"],
        descripcion: json["descripcion"],
        porcentaje: json["porcentaje"],
        tipo: json["tipo"],
        activo: json["activo"],
        creadoPor: json["creado_por"],
        fechaCreacion: DateTime.parse(json["fecha_creacion"]),
        modificadoPor: json["modificado_por"],
        fechaModificacion: DateTime.parse(json["fecha_modificacion"]),
        sistema: json["sistema"],
        tipoCredito: json["tipo_credito"],
        aplicaRegistroGastoManual: json["aplica_registro_gasto_manual"],
        productoDefaultGasto: json["producto_default_gasto"],
        codigoTarifaHacienda: json["codigo_tarifa_hacienda"],
    );

    Map<String, dynamic> toMap() => {
        "cod_impuesto": codImpuesto,
        "descripcion": descripcion,
        "porcentaje": porcentaje,
        "tipo": tipo,
        "activo": activo,
        "creado_por": creadoPor,
        "fecha_creacion": fechaCreacion?.toIso8601String(),
        "modificado_por": modificadoPor,
        "fecha_modificacion": fechaModificacion?.toIso8601String(),
        "sistema": sistema,
        "tipo_credito": tipoCredito,
        "aplica_registro_gasto_manual": aplicaRegistroGastoManual,
        "producto_default_gasto": productoDefaultGasto,
        "codigo_tarifa_hacienda": codigoTarifaHacienda,
    };
}