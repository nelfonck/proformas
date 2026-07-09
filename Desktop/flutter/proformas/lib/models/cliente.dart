// To parse this JSON data, do
//
//     final cliente = clienteFromMap(jsonString);

import 'dart:convert';

class Cliente {
    String? codCliente;
    String? cedula;
    String? telefono1;
    String? telefono2;
    String? email;
    double? porcDescuento;
    double? saldoDisponible;
    String? razonSocial;
    String? razonComercial;
    String? exento;
    String? tipoDocumentoExo ;
    String? numeroDocumentoExo;
    String? nombreInstitucionExo;
    DateTime? fechaEmisionExo ;
    DateTime? fechaFinExo ;
    String? codigoImpuestoTarifaReducida ;
    double? porcentajeImpuestoTarifaReducida ;

    Cliente({
        this.codCliente,
        this.cedula,
        this.telefono1,
        this.telefono2,
        this.email,
        this.porcDescuento,
        this.saldoDisponible,
        this.razonSocial,
        this.razonComercial,
        this.exento,
        this.tipoDocumentoExo,
        this.numeroDocumentoExo,
        this.nombreInstitucionExo,
        this.fechaEmisionExo,
        this.fechaFinExo,
        this.codigoImpuestoTarifaReducida,
        this.porcentajeImpuestoTarifaReducida
    });

    Cliente copyWith({
        String? codCliente,
        String? cedula,
        String? telefono1,
        String? telefono2,
        String? email,
        double? porcDescuento,
        double? saldoDisponible,
        String? razonSocial,
        String? razonComercial,
        String? exento,
        String? tipoDocumentoExo,
        String? numeroDocumentoExo,
        String? nombreInstitucionExo,
        DateTime? fechaEmisionExo,
        DateTime? fechaFinExo,
        String? codigoImpuestoTarifaReducida,
        double? porcentajeImpuestoTarifaReducida
    }) => 
        Cliente(
            codCliente: codCliente ?? this.codCliente,
            cedula: cedula ?? this.cedula,
            telefono1: telefono1 ?? this.telefono1,
            telefono2: telefono2 ?? this.telefono2,
            email: email ?? this.email,
            porcDescuento: porcDescuento ?? this.porcDescuento,
            saldoDisponible: saldoDisponible ?? this.saldoDisponible,
            razonSocial: razonSocial ?? this.razonSocial,
            razonComercial: razonComercial ?? this.razonComercial,
            exento: exento ?? this.exento,
            tipoDocumentoExo: tipoDocumentoExo ?? this.tipoDocumentoExo,
            numeroDocumentoExo: numeroDocumentoExo ?? this.numeroDocumentoExo,
            nombreInstitucionExo: nombreInstitucionExo ?? this.nombreInstitucionExo,
            fechaEmisionExo: fechaEmisionExo ?? this.fechaEmisionExo,
            fechaFinExo : fechaFinExo ?? this.fechaFinExo,
            codigoImpuestoTarifaReducida: codigoImpuestoTarifaReducida ?? this.codigoImpuestoTarifaReducida,
            porcentajeImpuestoTarifaReducida: porcentajeImpuestoTarifaReducida ?? this.porcentajeImpuestoTarifaReducida
        );

    factory Cliente.fromJson(String str) => Cliente.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Cliente.fromMap(Map<String, dynamic> json) => Cliente(
        codCliente: json["cod_cliente"],
        cedula: json["cedula"],
        telefono1: json["telefono1"],
        telefono2: json["telefono2"],
        email: json["email"],
        porcDescuento: json["porc_descuento"].toDouble(),
        saldoDisponible: json["saldo_disponible"].toDouble(),
        razonSocial: json["razon_social"],
        razonComercial: json["razon_comercial"],
        exento: json["exento"].toString(),
        tipoDocumentoExo: json["tipo_documento_exo"],
        numeroDocumentoExo: json["numero_documento_exo"],
        nombreInstitucionExo: json["nombre_institucion_exo"],
        fechaEmisionExo: json["fecha_emision_exo"] != null  ? DateTime.parse(json["fecha_emision_exo"]) : null,
        fechaFinExo: json["fecha_fin_exo"] != null ? DateTime.parse(json["fecha_fin_exo"]) : null,
        codigoImpuestoTarifaReducida: json["codigo_impuesto_tarifa_reducida"],
        porcentajeImpuestoTarifaReducida: json["porcentaje_impuesto_tarifa_reducida"] != null ? json["porcentaje_impuesto_tarifa_reducida"].toDouble() : 0,
    );

    Map<String, dynamic> toMap() => {
        "cod_cliente": codCliente,
        "cedula": cedula,
        "telefono1": telefono1,
        "telefono2": telefono2,
        "email": email,
        "porc_descuento": porcDescuento,
        "saldo_disponible": saldoDisponible,
        "razon_social": razonSocial,
        "razon_comercial": razonComercial,
        "exento": exento,
        "tipo_documento_exo": tipoDocumentoExo,
        "numero_documento_exo": numeroDocumentoExo,
        "nombre_institucion_exo": nombreInstitucionExo,
        "fecha_emision_exo": fechaEmisionExo.toString(),
        "fecha_fin_exo": fechaFinExo.toString(),
        "codigo_impuesto_tarifa_reducida": codigoImpuestoTarifaReducida,
        "porcentaje_impuesto_tarifa_reducida": porcentajeImpuestoTarifaReducida,
    };
}
