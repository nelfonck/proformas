import 'dart:convert';

class Marca {
    String? codMarca;
    String? descripcion;
    String? activo;
    String? creadoPor;
    DateTime ?fechaCreacion;
    String? modificadoPor;
    DateTime? fechaModificacion;
    String? notas;
    String? generarCodigoAlternativoAutomatico;

    Marca({
        this.codMarca,
        this.descripcion,
        this.activo,
        this.creadoPor,
        this.fechaCreacion,
        this.modificadoPor,
        this.fechaModificacion,
        this.notas,
        this.generarCodigoAlternativoAutomatico,
    });

    Marca copyWith({
        String? codMarca,
        String? descripcion,
        String? activo,
        String? creadoPor,
        DateTime? fechaCreacion,
        String? modificadoPor,
        DateTime? fechaModificacion,
        String? notas,
        String? generarCodigoAlternativoAutomatico,
    }) => 
        Marca(
            codMarca: codMarca ?? this.codMarca,
            descripcion: descripcion ?? this.descripcion,
            activo: activo ?? this.activo,
            creadoPor: creadoPor ?? this.creadoPor,
            fechaCreacion: fechaCreacion ?? this.fechaCreacion,
            modificadoPor: modificadoPor ?? this.modificadoPor,
            fechaModificacion: fechaModificacion ?? this.fechaModificacion,
            notas: notas ?? this.notas,
            generarCodigoAlternativoAutomatico: generarCodigoAlternativoAutomatico ?? this.generarCodigoAlternativoAutomatico,
        );

    factory Marca.fromJson(String str) => Marca.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Marca.fromMap(Map<String, dynamic> json) => Marca(
        codMarca: json["cod_marca"],
        descripcion: json["descripcion"],
        activo: json["activo"],
        creadoPor: json["creado_por"],
        fechaCreacion: DateTime.parse(json["fecha_creacion"]),
        modificadoPor: json["modificado_por"],
        fechaModificacion: DateTime.parse(json["fecha_modificacion"]),
        notas: json["notas"],
        generarCodigoAlternativoAutomatico: json["generar_codigo_alternativo_automatico"],
    );

    Map<String, dynamic> toMap() => {
        "cod_marca": codMarca,
        "descripcion": descripcion,
        "activo": activo,
        "creado_por": creadoPor,
        "fecha_creacion": fechaCreacion?.toIso8601String(),
        "modificado_por": modificadoPor,
        "fecha_modificacion": fechaModificacion?.toIso8601String(),
        "notas": notas,
        "generar_codigo_alternativo_automatico": generarCodigoAlternativoAutomatico,
    };
}