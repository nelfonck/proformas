// To parse this JSON data, do
//
//     final preProforma = preProformaFromMap(jsonString);

import 'dart:convert';

class PreProforma {
    int? id;
    String? nombre;
    DateTime? fecha;
    bool? enviada;
    double? refproforma;
    String? codCliente ;
    String? razonSocial ;
    String? razonComercial ;
    String? email;
    String? telefono1;
    String? telefono2;
    double? porcDescuento ;
    double? subTotal ;
    double? descuento;
    double? total;
    double? montoIvColones;
    double? subTotalExento;
    double? subTotalGravado;
    String? exento;
    String? tipoDocumentoExo ;
    String? numeroDocumentoExo;
    String? nombreInstitucionExo;
    DateTime? fechaEmisionExo ;
    DateTime? fechaFinExo ;
    String? codigoImpuestoTarifaReducida ;
    double? porcentajeImpuestoTarifaReducida ;
    
    PreProforma({
        this.id,
        this.nombre,
        this.fecha,
        this.enviada,
        this.refproforma,
        this.codCliente,
        this.razonSocial,
        this.razonComercial,
        this.email,
        this.telefono1,
        this.telefono2,
        this.porcDescuento,
        this.descuento,
        this.subTotal,
        this.total,
        this.montoIvColones,
        this.subTotalExento,
        this.subTotalGravado,
        this.exento,
        this.tipoDocumentoExo,
        this.numeroDocumentoExo,
        this.nombreInstitucionExo,
        this.fechaEmisionExo,
        this.fechaFinExo,
        this.codigoImpuestoTarifaReducida,
        this.porcentajeImpuestoTarifaReducida
    });

    PreProforma copyWith({
        int? id,
        String? nombre,
        DateTime? fecha,
        bool? enviada,
        double? refproforma,
        String? codCliente,
        String? razonSocial, 
        String? razonComercial,
        String? email,
        String? telefono1,
        String? telefono2,
        double? porcDescuento,
        double? descuento,
        double? subTotal,
        double? total,
        double? montoIvColones,
        double? subTotalExento,
        double? subTotalGravado,
        String? exento,
        String? tipoDocumentoExo,
        String? numeroDocumentoExo,
        String? nombreInstitucionExo,
        DateTime? fechaEmisionExo,
        DateTime? fechaFinExo,
        String? codigoImpuestoTarifaReducida,
        double? porcentajeImpuestoTarifaReducida
    }) => 
        PreProforma(
            id: id ?? this.id,
            nombre: nombre ?? this.nombre,
            fecha: fecha ?? this.fecha,
            enviada: enviada ?? this.enviada,
            refproforma: refproforma ?? this.refproforma,
            codCliente: codCliente ?? this.codCliente,
            razonSocial: razonSocial ?? this.razonSocial,
            razonComercial: razonComercial ?? this.razonComercial,
            email: email ?? this.email,
            telefono1: telefono1 ?? this.telefono1,
            telefono2: telefono2 ?? this.telefono2,
            porcDescuento: porcDescuento ?? this.porcDescuento,
            descuento: descuento ?? this.descuento,
            subTotal: subTotal ?? this.subTotal,
            total: total ?? this.total,
            montoIvColones: montoIvColones ?? this.montoIvColones,
            subTotalExento: subTotalExento ?? this.subTotalExento,
            subTotalGravado: subTotalGravado ?? this.subTotalGravado,
            exento: exento ?? this.exento,
            tipoDocumentoExo: tipoDocumentoExo ?? this.tipoDocumentoExo,
            numeroDocumentoExo: numeroDocumentoExo ?? this.numeroDocumentoExo,
            nombreInstitucionExo: nombreInstitucionExo ?? this.nombreInstitucionExo,
            fechaEmisionExo: fechaEmisionExo ?? this.fechaEmisionExo,
            fechaFinExo : fechaFinExo ?? this.fechaFinExo,
            codigoImpuestoTarifaReducida: codigoImpuestoTarifaReducida ?? this.codigoImpuestoTarifaReducida,
            porcentajeImpuestoTarifaReducida: porcentajeImpuestoTarifaReducida ?? this.porcentajeImpuestoTarifaReducida
        );

        PreProforma.clone(PreProforma source)
            : id = source.id,
              nombre = source.nombre,
              fecha = source.fecha,
              enviada = source.enviada,
              refproforma = source.refproforma,
              codCliente = source.codCliente,
              razonSocial = source.razonSocial,
              razonComercial = source.razonComercial,
              email = source.email,
              telefono1 = source.telefono1,
              telefono2 = source.telefono2,
              porcDescuento = source.porcDescuento,
              descuento = source.descuento,
              subTotal = source.subTotal,
              total = source.total,
              montoIvColones = source.montoIvColones,
              subTotalExento = source.subTotalExento,
              subTotalGravado = source.subTotalGravado,
              exento = source.exento,
              tipoDocumentoExo = source.tipoDocumentoExo,
              numeroDocumentoExo = source.numeroDocumentoExo,
              nombreInstitucionExo = source.nombreInstitucionExo,
              fechaEmisionExo = source.fechaEmisionExo,
              fechaFinExo = source.fechaFinExo,
              codigoImpuestoTarifaReducida = source.codigoImpuestoTarifaReducida,
              porcentajeImpuestoTarifaReducida = source.porcentajeImpuestoTarifaReducida;

    factory PreProforma.fromJson(String str) => PreProforma.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PreProforma.fromMap(Map<String, dynamic> json) => PreProforma(
        id: json["id"],
        nombre: json["nombre"],
        fecha: DateTime.parse(json["fecha"]),
        enviada: json["enviada"],
        // ignore: prefer_null_aware_operators
        refproforma: json["refproforma"] != null ? json["refproforma"].toDouble() : null,
        codCliente: json["cod_cliente"],
        razonSocial: json["razon_social"],
        razonComercial: json["razon_comercial"],
        email: json["email"],
        telefono1: json["telefono1"],
        telefono2: json["telefono2"],
        porcDescuento: json["porc_descuento"].toDouble(),
        descuento: json["descuento"].toDouble(),
        subTotal: json['sub_total'].toDouble(),
        total: json['total'].toDouble(),
        montoIvColones: json['monto_iv_colones'].toDouble(),
        subTotalExento: json['sub_total_exento'].toDouble(),
        subTotalGravado: json['sub_total_gravado'].toDouble(),
        exento: json['exento'].toString(),
        tipoDocumentoExo: json["tipo_documento_exo"],
        numeroDocumentoExo: json["numero_documento_exo"],
        nombreInstitucionExo: json["nombre_institucion_exo"],
        fechaEmisionExo: json["fecha_emision_exo"] != null  ? DateTime.parse(json["fecha_emision_exo"]) : null,
        fechaFinExo: json["fecha_fin_exo"] != null ? DateTime.parse(json["fecha_fin_exo"]) : null,
        codigoImpuestoTarifaReducida: json["codigo_impuesto_tarifa_reducida"],
        porcentajeImpuestoTarifaReducida: json["porcentaje_impuesto_tarifa_reducida"] != null ? json["porcentaje_impuesto_tarifa_reducida"].toDouble() : 0,
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "fecha": fecha.toString(),
        "enviada": enviada,
        "refproforma": refproforma,
        "cod_cliente": codCliente,
        "razon_social": razonSocial,
        "razon_comercial": razonComercial,
        "email": email,
        "telefono1": telefono1,
        "telefono2": telefono2,
        "porc_descuento": porcDescuento,
        "descuento": descuento,
        "sub_total" : subTotal,
        "total": total,
        "monto_iv_colones": montoIvColones,
        "sub_total_exento": subTotalExento,
        "sub_total_gravado": subTotalGravado,
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
