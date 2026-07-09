// To parse this JSON data, do
//
//     final usuario = usuarioFromMap(jsonString);

import 'dart:convert';

class Usuario {
    String? codUsuario;
    String? nombre;
    String? clave ;
    String? superusuario;
    String? codCajero;
    String? topeDescuento;
    String? facturarExcento;
    String? facturarCreditoExedido;

    Usuario({
        this.codUsuario,
        this.nombre,
        this.superusuario,
        this.codCajero,
        this.clave,
        this.topeDescuento,
        this.facturarExcento,
        this.facturarCreditoExedido
    });

    Usuario copyWith({
        String? codUsuario,
        String? nombre,
        String? superusuario,
        String? codCajero,
        String? clave,
        String? topeDescuento, 
        String? facturarExcento,
        String? facturarCreditoExedido
    }) => 
        Usuario(
            codUsuario: codUsuario ?? this.codUsuario,
            nombre: nombre ?? this.nombre,
            superusuario: superusuario ?? this.superusuario,
            codCajero: codCajero ?? this.codCajero,
            clave: clave ?? this.clave,
            topeDescuento: topeDescuento ?? this.topeDescuento,
            facturarExcento: facturarExcento ?? this.facturarExcento,
            facturarCreditoExedido : facturarCreditoExedido ?? this.facturarCreditoExedido
        );

    factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        codUsuario: json["cod_usuario"],
        nombre: json["nombre"],
        superusuario: json["superusuario"],
        codCajero: json["cod_cajero"],
        clave: json["clave"],
        topeDescuento: json["tope_descuento"],
        facturarExcento: json["facturar_excento"],
        facturarCreditoExedido: json["puede_facturar_credito_exedido"],
    );

    Map<String, dynamic> toMap() => {
        "cod_usuario": codUsuario,
        "nombre": nombre,
        "superusuario": superusuario,
        "cod_cajero": codCajero,
        "clave": clave,
        "tope_descuento": topeDescuento,
        "facturar_excento": facturarExcento,
        "puede_facturar_credito_exedido": facturarCreditoExedido,
    };
}
