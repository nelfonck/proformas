class HabladorHh {
    int? id;
    String? codArticulo;
    String? descripcion;
    String? creadoPor;
    DateTime? fechaCreacion;
    double? venta;

    HabladorHh({
        this.id,
        this.codArticulo,
        this.descripcion,
        this.creadoPor,
        this.fechaCreacion,
        this.venta
    });

    factory HabladorHh.fromMap(Map<String, dynamic> json) => HabladorHh(
        id: json["id"],
        codArticulo: json["cod_articulo"],
        descripcion: json["descripcion"],
        creadoPor: json["creado_por"],
        fechaCreacion: DateTime.parse(json["fecha_creacion"]),
        venta: json["venta"].toDouble()
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "cod_articulo": codArticulo,
        "descripcion": descripcion,
        "creado_por": creadoPor,
        "fecha_creacion": fechaCreacion.toString(),
        "venta": venta
    };
}
