// To parse this JSON data, do
//
//     final familia = familiaFromMap(jsonString);

import 'dart:convert';

class Familia {
    String? codFamilia;
    String? descripcion;
    String? activo;
    String? creadoPor;
    DateTime? fechaCreacion;
    String? modificadoPor;
    DateTime? fechaModificacion;
    dynamic notas;
    String? departamento;
    String? sistema;
    String? generarCodigoAlternativoAutomatico;
    String? categoriaD151;

    Familia({
        this.codFamilia,
        this.descripcion,
        this.activo,
        this.creadoPor,
        this.fechaCreacion,
        this.modificadoPor,
        this.fechaModificacion,
        this.notas,
        this.departamento,
        this.sistema,
        this.generarCodigoAlternativoAutomatico,
        this.categoriaD151,
    });

    Familia copyWith({
        String? codFamilia,
        String? descripcion,
        String? activo,
        String? creadoPor,
        DateTime? fechaCreacion,
        String? modificadoPor,
        DateTime? fechaModificacion,
        dynamic notas,
        String? departamento,
        String? sistema,
        String? generarCodigoAlternativoAutomatico,
        String? categoriaD151,
    }) => 
        Familia(
            codFamilia: codFamilia ?? this.codFamilia,
            descripcion: descripcion ?? this.descripcion,
            activo: activo ?? this.activo,
            creadoPor: creadoPor ?? this.creadoPor,
            fechaCreacion: fechaCreacion ?? this.fechaCreacion,
            modificadoPor: modificadoPor ?? this.modificadoPor,
            fechaModificacion: fechaModificacion ?? this.fechaModificacion,
            notas: notas ?? this.notas,
            departamento: departamento ?? this.departamento,
            sistema: sistema ?? this.sistema,
            generarCodigoAlternativoAutomatico: generarCodigoAlternativoAutomatico ?? this.generarCodigoAlternativoAutomatico,
            categoriaD151: categoriaD151 ?? this.categoriaD151,
        );

    factory Familia.fromJson(String str) => Familia.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Familia.fromMap(Map<String, dynamic> json) => Familia(
        codFamilia: json["cod_familia"],
        descripcion: json["descripcion"],
        activo: json["activo"],
        creadoPor: json["creado_por"],
        fechaCreacion: DateTime.parse(json["fecha_creacion"]),
        modificadoPor: json["modificado_por"],
        fechaModificacion: DateTime.parse(json["fecha_modificacion"]),
        notas: json["notas"],
        departamento: json["departamento"],
        sistema: json["sistema"],
        generarCodigoAlternativoAutomatico: json["generar_codigo_alternativo_automatico"],
        categoriaD151: json["categoria_d151"],
    );

    Map<String, dynamic> toMap() => {
        "cod_familia": codFamilia,
        "descripcion": descripcion,
        "activo": activo,
        "creado_por": creadoPor,
        "fecha_creacion": fechaCreacion?.toIso8601String(),
        "modificado_por": modificadoPor,
        "fecha_modificacion": fechaModificacion?.toIso8601String(),
        "notas": notas,
        "departamento": departamento,
        "sistema": sistema,
        "generar_codigo_alternativo_automatico": generarCodigoAlternativoAutomatico,
        "categoria_d151": categoriaD151,
    };
}
