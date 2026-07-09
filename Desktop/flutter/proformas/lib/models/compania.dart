// To parse this JSON data, do
//
//     final compania = companiaFromJson(jsonString);

import 'dart:typed_data';
import 'dart:convert';

class Compania {
    String? codCompania;
    String? razonSocial;
    String? razonComercial;
    String? identificacion;
    String? tipoIdentificacion;
    String? telefono;
    String? direccion;
    Uint8List? logo ;

    Compania({
        this.codCompania,
        this.razonSocial,
        this.razonComercial,
        this.identificacion,
        this.tipoIdentificacion,
        this.telefono,
        this.direccion,
        this.logo
    });

    Compania copyWith({
        String? codCompania,
        String? razonSocial,
        String? razonComercial,
        String? identificacion,
        String? tipoIdentificacion,
        String? telefono,
        String? direccion,
        Uint8List? logo,
    }) => 
        Compania(
            codCompania: codCompania ?? this.codCompania,
            razonSocial: razonSocial ?? this.razonSocial,
            razonComercial: razonComercial ?? this.razonComercial,
            identificacion: identificacion ?? this.identificacion,
            tipoIdentificacion: tipoIdentificacion ?? this.tipoIdentificacion,
            telefono: telefono ?? this.telefono,
            direccion: direccion ?? this.direccion,
            logo: logo ?? this.logo,
        );

    factory Compania.fromMap(Map<String, dynamic> json) => Compania(
        codCompania: json["cod_compania"],
        razonSocial: json["razon_social"],
        razonComercial: json["razon_comercial"],
        identificacion: json["identificacion"],
        tipoIdentificacion: json["tipo_identificacion"],
        telefono: json["telefono"],
        direccion: json["direccion"],
        logo: json["logo"] != null ? Uint8List.fromList( base64Decode(json["logo"])) : null ,
    );

    Map<String, dynamic> toMap() => {
        "cod_compania": codCompania,
        "razon_social": razonSocial,
        "razon_comercial": razonComercial,
        "identificacion": identificacion,
        "tipo_identificacion": tipoIdentificacion,
        "telefono": telefono,
        "direccion": direccion,
        "logo": logo ?? base64Encode( logo! ),
    };
}
