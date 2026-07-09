// To parse this JSON data, do
//
//     final articulo = articuloFromMap(jsonString);

import 'dart:convert';

import 'package:proformas/models/familia.dart';
import 'package:proformas/models/impuesto.dart';
import 'package:proformas/models/marca.dart';

class Articulo {
    String? codArticulo;
    String? codFamilia;
    String? codMarca;
    String? descripcion;
    dynamic modelo;
    double? precioDefault;
    double? costoProveedor;
    String? activo;
    String? creadoPor;
    DateTime? fechaCreacion;
    String? modificadoPor;
    DateTime? fechaModificacion;
    double? porcentajeUtilidad;
    double? porcDescuentoActual;
    String? codImpuesto;
    String? habilitarCambiarPrecio;
    String? cantidadMinDesc;
    String? porcDescuentoXCant;
    String? artControl;
    String? artGranel;
    String? aplicaInventario;
    String? activarArticulosRelacionados;
    dynamic ubicacion;
    String? porcentajeComision;
    String? porcentajeUtilidadSugerido;
    dynamic notas;
    String? aplicaComandas;
    String? unidadCompra;
    String? unidadVenta;
    String? permiteVentaUnitaria;
    String? unidadEmpaque;
    String? ultimoCodProveedor;
    String? ultimoNumFacturaProveedor;
    String? unidadMedida;
    double? factorMedida;
    double? porcTopeDescuento1;
    double? porcTopeDescuento2;
    double? porcTopeDescuento3;
    DateTime? fechaUltimaCompra;
    String? generarCodigoAlternativoAutomatico;
    String? articuloRomana;
    double? volumen;
    double? peso;
    String? consolidadoBultosSellado;
    String? notasTecnicas;
    String? cargarImagenAutomatica;
    String? pesadoAutomatico;
    String? articuloRelacionadoAgrupador;
    double? costoPromedio;
    double? costoBase;
    String? esCombo;
    String? proveedor;
    dynamic clase;
    dynamic segmento;
    dynamic tamano;
    dynamic codArticuloComilla;
    dynamic tipoArticulo;
    dynamic numeroParte;
    String? esReceta;
    String? esInsumo;
    String? aplicaDevoluciones;
    String? porcDescuentoUltimaCompra;
    String? codUltimaFactura;
    DateTime? fechaUltimaVenta;
    String? conceptoFacturacion;
    String? ventaLibre;
    String? costoEspecial;
    String? porcentajeUtilidadDeseada;
    String? omitirMovInvInsumosReceta;
    String? aplicaTimbreOdontologico;
    String? precioFijo;
    String? porcentajeUtilidadMinimoFacturacion;
    String? tipoPrecios;
    String? partidaArancelaria;
    String? porcDai;
    String? ivaAAplicar;
    String? ivaParaProrrata;
    String? codCabys;
    String? codImpuestoCabys;
    String? bloqueadoParaVenta;
    String ?sincronizadoNube;
    dynamic fechaSincronizadoNube;
    dynamic sincronizadoNubePor;
    String? articuloPortada;
    String? servicioSalud;
    String? semoviente;
    String? kilogramos;
    String? porcentajeDescuentoCompras;
    String? porcentajeDescuentoVentas;
    String? bonificacion;
    String? notaComanda;
    String? aplicaRea;
    dynamic tarifaReducidaRea;
    String? bultosCargaCamionCheckout;
    String? solicitaFechaVencimientoCheckout;
    String? costoDolaresReferencia;
    dynamic fechaUltimoCambioCabys;
    String? conocidoComo;
    String? diasGarantia;
    dynamic tipoCalculoComision;
    String? articuloConSerie;
    Familia? familia;
    Impuesto? impuesto;
    Marca? marca;
    double? costo;
    double? venta;

    Articulo({
        this.codArticulo,
        this.codFamilia,
        this.codMarca,
        this.descripcion,
        this.modelo,
        this.precioDefault,
        this.costoProveedor,
        this.activo,
        this.creadoPor,
        this.fechaCreacion,
        this.modificadoPor,
        this.fechaModificacion,
        this.porcentajeUtilidad,
        this.porcDescuentoActual,
        this.codImpuesto,
        this.habilitarCambiarPrecio,
        this.cantidadMinDesc,
        this.porcDescuentoXCant,
        this.artControl,
        this.artGranel,
        this.aplicaInventario,
        this.activarArticulosRelacionados,
        this.ubicacion,
        this.porcentajeComision,
        this.porcentajeUtilidadSugerido,
        this.notas,
        this.aplicaComandas,
        this.unidadCompra,
        this.unidadVenta,
        this.permiteVentaUnitaria,
        this.unidadEmpaque,
        this.ultimoCodProveedor,
        this.ultimoNumFacturaProveedor,
        this.unidadMedida,
        this.factorMedida,
        this.porcTopeDescuento1,
        this.porcTopeDescuento2,
        this.porcTopeDescuento3,
        this.fechaUltimaCompra,
        this.generarCodigoAlternativoAutomatico,
        this.articuloRomana,
        this.volumen,
        this.peso,
        this.consolidadoBultosSellado,
        this.notasTecnicas,
        this.cargarImagenAutomatica,
        this.pesadoAutomatico,
        this.articuloRelacionadoAgrupador,
        this.costoPromedio,
        this.costoBase,
        this.esCombo,
        this.proveedor,
        this.clase,
        this.segmento,
        this.tamano,
        this.codArticuloComilla,
        this.tipoArticulo,
        this.numeroParte,
        this.esReceta,
        this.esInsumo,
        this.aplicaDevoluciones,
        this.porcDescuentoUltimaCompra,
        this.codUltimaFactura,
        this.fechaUltimaVenta,
        this.conceptoFacturacion,
        this.ventaLibre,
        this.costoEspecial,
        this.porcentajeUtilidadDeseada,
        this.omitirMovInvInsumosReceta,
        this.aplicaTimbreOdontologico,
        this.precioFijo,
        this.porcentajeUtilidadMinimoFacturacion,
        this.tipoPrecios,
        this.partidaArancelaria,
        this.porcDai,
        this.ivaAAplicar,
        this.ivaParaProrrata,
        this.codCabys,
        this.codImpuestoCabys,
        this.bloqueadoParaVenta,
        this.sincronizadoNube,
        this.fechaSincronizadoNube,
        this.sincronizadoNubePor,
        this.articuloPortada,
        this.servicioSalud,
        this.semoviente,
        this.kilogramos,
        this.porcentajeDescuentoCompras,
        this.porcentajeDescuentoVentas,
        this.bonificacion,
        this.notaComanda,
        this.aplicaRea,
        this.tarifaReducidaRea,
        this.bultosCargaCamionCheckout,
        this.solicitaFechaVencimientoCheckout,
        this.costoDolaresReferencia,
        this.fechaUltimoCambioCabys,
        this.conocidoComo,
        this.diasGarantia,
        this.tipoCalculoComision,
        this.articuloConSerie,
        this.familia,
        this.impuesto,
        this.marca,
        this.costo,
        this.venta,
    });

    Articulo copyWith({
        String? codArticulo,
        String? codFamilia,
        String? codMarca,
        String? descripcion,
        dynamic modelo,
        double? precioDefault,
        double? costoProveedor,
        String? activo,
        String? creadoPor,
        DateTime? fechaCreacion,
        String? modificadoPor,
        DateTime? fechaModificacion,
        double? porcentajeUtilidad,
        double? porcDescuentoActual,
        String? codImpuesto,
        String? habilitarCambiarPrecio,
        String? cantidadMinDesc,
        String? porcDescuentoXCant,
        String? artControl,
        String? artGranel,
        String? aplicaInventario,
        String? activarArticulosRelacionados,
        dynamic ubicacion,
        String? porcentajeComision,
        String? porcentajeUtilidadSugerido,
        dynamic notas,
        String? aplicaComandas,
        String? unidadCompra,
        String? unidadVenta,
        String? permiteVentaUnitaria,
        String? unidadEmpaque,
        String? ultimoCodProveedor,
        String? ultimoNumFacturaProveedor,
        String? unidadMedida,
        double? factorMedida,
        double? porcTopeDescuento1,
        double? porcTopeDescuento2,
        double? porcTopeDescuento3,
        DateTime? fechaUltimaCompra,
        String? generarCodigoAlternativoAutomatico,
        String? articuloRomana,
        double? volumen,
        double? peso,
        String? consolidadoBultosSellado,
        String? notasTecnicas,
        String? cargarImagenAutomatica,
        String? pesadoAutomatico,
        String? articuloRelacionadoAgrupador,
        double? costoPromedio,
        double? costoBase,
        String? esCombo,
        String? proveedor,
        dynamic clase,
        dynamic segmento,
        dynamic tamano,
        dynamic codArticuloComilla,
        dynamic tipoArticulo,
        dynamic numeroParte,
        String? esReceta,
        String? esInsumo,
        String? aplicaDevoluciones,
        String? porcDescuentoUltimaCompra,
        String? codUltimaFactura,
        DateTime? fechaUltimaVenta,
        String? conceptoFacturacion,
        String? ventaLibre,
        String? costoEspecial,
        String? porcentajeUtilidadDeseada,
        String? omitirMovInvInsumosReceta,
        String? aplicaTimbreOdontologico,
        String? precioFijo,
        String? porcentajeUtilidadMinimoFacturacion,
        String? tipoPrecios,
        String? partidaArancelaria,
        String? porcDai,
        String? ivaAAplicar,
        String? ivaParaProrrata,
        String? codCabys,
        String? codImpuestoCabys,
        String? bloqueadoParaVenta,
        String? sincronizadoNube,
        dynamic fechaSincronizadoNube,
        dynamic sincronizadoNubePor,
        String? articuloPortada,
        String? servicioSalud,
        String? semoviente,
        String? kilogramos,
        String? porcentajeDescuentoCompras,
        String? porcentajeDescuentoVentas,
        String? bonificacion,
        String? notaComanda,
        String? aplicaRea,
        dynamic tarifaReducidaRea,
        String? bultosCargaCamionCheckout,
        String? solicitaFechaVencimientoCheckout,
        String? costoDolaresReferencia,
        dynamic fechaUltimoCambioCabys,
        String? conocidoComo,
        String? diasGarantia,
        dynamic tipoCalculoComision,
        String? articuloConSerie,
        Familia? familia,
        Impuesto? impuesto,
        Marca? marca,
        double? costo,
        double? venta,
    }) => 
        Articulo(
            codArticulo: codArticulo ?? this.codArticulo,
            codFamilia: codFamilia ?? this.codFamilia,
            codMarca: codMarca ?? this.codMarca,
            descripcion: descripcion ?? this.descripcion,
            modelo: modelo ?? this.modelo,
            precioDefault: precioDefault ?? this.precioDefault,
            costoProveedor: costoProveedor ?? this.costoProveedor,
            activo: activo ?? this.activo,
            creadoPor: creadoPor ?? this.creadoPor,
            fechaCreacion: fechaCreacion ?? this.fechaCreacion,
            modificadoPor: modificadoPor ?? this.modificadoPor,
            fechaModificacion: fechaModificacion ?? this.fechaModificacion,
            porcentajeUtilidad: porcentajeUtilidad ?? this.porcentajeUtilidad,
            porcDescuentoActual: porcDescuentoActual ?? this.porcDescuentoActual,
            codImpuesto: codImpuesto ?? this.codImpuesto,
            habilitarCambiarPrecio: habilitarCambiarPrecio ?? this.habilitarCambiarPrecio,
            cantidadMinDesc: cantidadMinDesc ?? this.cantidadMinDesc,
            porcDescuentoXCant: porcDescuentoXCant ?? this.porcDescuentoXCant,
            artControl: artControl ?? this.artControl,
            artGranel: artGranel ?? this.artGranel,
            aplicaInventario: aplicaInventario ?? this.aplicaInventario,
            activarArticulosRelacionados: activarArticulosRelacionados ?? this.activarArticulosRelacionados,
            ubicacion: ubicacion ?? this.ubicacion,
            porcentajeComision: porcentajeComision ?? this.porcentajeComision,
            porcentajeUtilidadSugerido: porcentajeUtilidadSugerido ?? this.porcentajeUtilidadSugerido,
            notas: notas ?? this.notas,
            aplicaComandas: aplicaComandas ?? this.aplicaComandas,
            unidadCompra: unidadCompra ?? this.unidadCompra,
            unidadVenta: unidadVenta ?? this.unidadVenta,
            permiteVentaUnitaria: permiteVentaUnitaria ?? this.permiteVentaUnitaria,
            unidadEmpaque: unidadEmpaque ?? this.unidadEmpaque,
            ultimoCodProveedor: ultimoCodProveedor ?? this.ultimoCodProveedor,
            ultimoNumFacturaProveedor: ultimoNumFacturaProveedor ?? this.ultimoNumFacturaProveedor,
            unidadMedida: unidadMedida ?? this.unidadMedida,
            factorMedida: factorMedida ?? this.factorMedida,
            porcTopeDescuento1: porcTopeDescuento1 ?? this.porcTopeDescuento1,
            porcTopeDescuento2: porcTopeDescuento2 ?? this.porcTopeDescuento2,
            porcTopeDescuento3: porcTopeDescuento3 ?? this.porcTopeDescuento3,
            fechaUltimaCompra: fechaUltimaCompra ?? this.fechaUltimaCompra,
            generarCodigoAlternativoAutomatico: generarCodigoAlternativoAutomatico ?? this.generarCodigoAlternativoAutomatico,
            articuloRomana: articuloRomana ?? this.articuloRomana,
            volumen: volumen ?? this.volumen,
            peso: peso ?? this.peso,
            consolidadoBultosSellado: consolidadoBultosSellado ?? this.consolidadoBultosSellado,
            notasTecnicas: notasTecnicas ?? this.notasTecnicas,
            cargarImagenAutomatica: cargarImagenAutomatica ?? this.cargarImagenAutomatica,
            pesadoAutomatico: pesadoAutomatico ?? this.pesadoAutomatico,
            articuloRelacionadoAgrupador: articuloRelacionadoAgrupador ?? this.articuloRelacionadoAgrupador,
            costoPromedio: costoPromedio ?? this.costoPromedio,
            esCombo: esCombo ?? this.esCombo,
            proveedor: proveedor ?? this.proveedor,
            clase: clase ?? this.clase,
            segmento: segmento ?? this.segmento,
            tamano: tamano ?? this.tamano,
            codArticuloComilla: codArticuloComilla ?? this.codArticuloComilla,
            tipoArticulo: tipoArticulo ?? this.tipoArticulo,
            numeroParte: numeroParte ?? this.numeroParte,
            esReceta: esReceta ?? this.esReceta,
            esInsumo: esInsumo ?? this.esInsumo,
            aplicaDevoluciones: aplicaDevoluciones ?? this.aplicaDevoluciones,
            porcDescuentoUltimaCompra: porcDescuentoUltimaCompra ?? this.porcDescuentoUltimaCompra,
            codUltimaFactura: codUltimaFactura ?? this.codUltimaFactura,
            fechaUltimaVenta: fechaUltimaVenta ?? this.fechaUltimaVenta,
            conceptoFacturacion: conceptoFacturacion ?? this.conceptoFacturacion,
            ventaLibre: ventaLibre ?? this.ventaLibre,
            costoEspecial: costoEspecial ?? this.costoEspecial,
            porcentajeUtilidadDeseada: porcentajeUtilidadDeseada ?? this.porcentajeUtilidadDeseada,
            omitirMovInvInsumosReceta: omitirMovInvInsumosReceta ?? this.omitirMovInvInsumosReceta,
            aplicaTimbreOdontologico: aplicaTimbreOdontologico ?? this.aplicaTimbreOdontologico,
            precioFijo: precioFijo ?? this.precioFijo,
            porcentajeUtilidadMinimoFacturacion: porcentajeUtilidadMinimoFacturacion ?? this.porcentajeUtilidadMinimoFacturacion,
            tipoPrecios: tipoPrecios ?? this.tipoPrecios,
            partidaArancelaria: partidaArancelaria ?? this.partidaArancelaria,
            porcDai: porcDai ?? this.porcDai,
            ivaAAplicar: ivaAAplicar ?? this.ivaAAplicar,
            ivaParaProrrata: ivaParaProrrata ?? this.ivaParaProrrata,
            codCabys: codCabys ?? this.codCabys,
            codImpuestoCabys: codImpuestoCabys ?? this.codImpuestoCabys,
            bloqueadoParaVenta: bloqueadoParaVenta ?? this.bloqueadoParaVenta,
            sincronizadoNube: sincronizadoNube ?? this.sincronizadoNube,
            fechaSincronizadoNube: fechaSincronizadoNube ?? this.fechaSincronizadoNube,
            sincronizadoNubePor: sincronizadoNubePor ?? this.sincronizadoNubePor,
            articuloPortada: articuloPortada ?? this.articuloPortada,
            servicioSalud: servicioSalud ?? this.servicioSalud,
            semoviente: semoviente ?? this.semoviente,
            kilogramos: kilogramos ?? this.kilogramos,
            costoBase: costoBase ?? this.costoBase,
            porcentajeDescuentoCompras: porcentajeDescuentoCompras ?? this.porcentajeDescuentoCompras,
            porcentajeDescuentoVentas: porcentajeDescuentoVentas ?? this.porcentajeDescuentoVentas,
            bonificacion: bonificacion ?? this.bonificacion,
            notaComanda: notaComanda ?? this.notaComanda,
            aplicaRea: aplicaRea ?? this.aplicaRea,
            tarifaReducidaRea: tarifaReducidaRea ?? this.tarifaReducidaRea,
            bultosCargaCamionCheckout: bultosCargaCamionCheckout ?? this.bultosCargaCamionCheckout,
            solicitaFechaVencimientoCheckout: solicitaFechaVencimientoCheckout ?? this.solicitaFechaVencimientoCheckout,
            costoDolaresReferencia: costoDolaresReferencia ?? this.costoDolaresReferencia,
            fechaUltimoCambioCabys: fechaUltimoCambioCabys ?? this.fechaUltimoCambioCabys,
            conocidoComo: conocidoComo ?? this.conocidoComo,
            diasGarantia: diasGarantia ?? this.diasGarantia,
            tipoCalculoComision: tipoCalculoComision ?? this.tipoCalculoComision,
            articuloConSerie: articuloConSerie ?? this.articuloConSerie,
            familia: familia ?? this.familia,
            impuesto: impuesto ?? this.impuesto,
            marca: marca ?? this.marca,
            costo: costo ?? this.costo,
            venta: venta ?? this.venta,
        );

    factory Articulo.fromJson(String str) => Articulo.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Articulo.fromMap(Map<String, dynamic> json) => Articulo(
        codArticulo: json["cod_articulo"],
        codFamilia: json["cod_familia"],
        codMarca: json["cod_marca"],
        descripcion: json["descripcion"],
        modelo: json["modelo"],
        precioDefault: json["precio_default"] == null ? 0 : json["precio_default"].toDouble(),
        costoProveedor: json["costo_proveedor"] == null ? 0 : json["costo_proveedor"].toDouble(),
        costoPromedio: json["costo_promedio"] == null ? 0 : json["costo_promedio"].toDouble(),
        costoBase: json["costo_base"] == null ? 0 : json["costo_base"].toDouble(),
        activo: json["activo"],
        creadoPor: json["creado_por"],
        fechaCreacion: json["fecha_creacion"] == null ? null :  DateTime.parse(json["fecha_creacion"]) ,
        modificadoPor: json["modificado_por"],
        fechaModificacion: json["fecha_modificacion"] == null ? null : DateTime.parse(json["fecha_modificacion"]),
        porcentajeUtilidad: json["porcentaje_utilidad"] == null ? 0 : json["porcentaje_utilidad"].toDouble(),
        porcDescuentoActual: json["porc_descuento_actual"],
        codImpuesto: json["cod_impuesto"],
        habilitarCambiarPrecio: json["habilitar_cambiar_precio"],
        cantidadMinDesc: json["cantidad_min_desc"],
        porcDescuentoXCant: json["porc_descuento_x_cant"],
        artControl: json["art_control"],
        artGranel: json["art_granel"],
        aplicaInventario: json["aplica_inventario"],
        activarArticulosRelacionados: json["activar_articulos_relacionados"],
        ubicacion: json["ubicacion"],
        porcentajeComision: json["porcentaje_comision"],
        porcentajeUtilidadSugerido: json["porcentaje_utilidad_sugerido"],
        notas: json["notas"],
        aplicaComandas: json["aplica_comandas"],
        unidadCompra: json["unidad_compra"],
        unidadVenta: json["unidad_venta"],
        permiteVentaUnitaria: json["permite_venta_unitaria"],
        unidadEmpaque: json["unidad_empaque"],
        ultimoCodProveedor: json["ultimo_cod_proveedor"],
        ultimoNumFacturaProveedor: json["ultimo_num_factura_proveedor"],
        unidadMedida: json["unidad_medida"],
        factorMedida: json["factor_medida"] == null ? 0 : json["factor_medida"].toDouble(),
        porcTopeDescuento1: json["porc_tope_descuento_1"] == null ? 0 : json["porc_tope_descuento_1"].toDouble(),
        porcTopeDescuento2: json["porc_tope_descuento_2"] == null ? 0 : json["porc_tope_descuento_2"].toDouble(),
        porcTopeDescuento3: json["porc_tope_descuento_3"] == null ? 0 : json["porc_tope_descuento_3"].toDouble(),
        fechaUltimaCompra: json["fecha_ultima_compra"] == null ? null : DateTime.parse(json["fecha_ultima_compra"]) ,
        generarCodigoAlternativoAutomatico: json["generar_codigo_alternativo_automatico"],
        articuloRomana: json["articulo_romana"],
        // ignore: prefer_null_aware_operators
        volumen: json["volumen"] != null ? json["volumen"].toDouble() : 0,
        // ignore: prefer_null_aware_operators
        peso: json["peso"] != null ? json["peso"].toDouble() : 0,
        consolidadoBultosSellado: json["consolidado_bultos_sellado"],
        notasTecnicas: json["notas_tecnicas"],
        cargarImagenAutomatica: json["cargar_imagen_automatica"],
        pesadoAutomatico: json["pesado_automatico"],
        articuloRelacionadoAgrupador: json["articulo_relacionado_agrupador"],
        esCombo: json["es_combo"],
        proveedor: json["proveedor"],
        clase: json["clase"],
        segmento: json["segmento"],
        tamano: json["tamano"],
        codArticuloComilla: json["cod_articulo_comilla"],
        tipoArticulo: json["tipo_articulo"],
        numeroParte: json["numero_parte"],
        esReceta: json["es_receta"],
        esInsumo: json["es_insumo"],
        aplicaDevoluciones: json["aplica_devoluciones"],
        porcDescuentoUltimaCompra: json["porc_descuento_ultima_compra"],
        codUltimaFactura: json["cod_ultima_factura"],
        fechaUltimaVenta: json["fecha_ultima_venta"] != null ? DateTime.parse(json["fecha_ultima_venta"]) : null,
        conceptoFacturacion: json["concepto_facturacion"],
        ventaLibre: json["venta_libre"],
        costoEspecial: json["costo_especial"],
        porcentajeUtilidadDeseada: json["porcentaje_utilidad_deseada"],
        omitirMovInvInsumosReceta: json["omitir_mov_inv_insumos_receta"],
        aplicaTimbreOdontologico: json["aplica_timbre_odontologico"],
        precioFijo: json["precio_fijo"],
        porcentajeUtilidadMinimoFacturacion: json["porcentaje_utilidad_minimo_facturacion"],
        tipoPrecios: json["tipo_precios"],
        partidaArancelaria: json["partida_arancelaria"],
        porcDai: json["porc_dai"],
        ivaAAplicar: json["iva_a_aplicar"],
        ivaParaProrrata: json["iva_para_prorrata"],
        codCabys: json["cod_cabys"],
        codImpuestoCabys: json["cod_impuesto_cabys"],
        bloqueadoParaVenta: json["bloqueado_para_venta"],
        sincronizadoNube: json["sincronizado_nube"],
        fechaSincronizadoNube: json["fecha_sincronizado_nube"],
        sincronizadoNubePor: json["sincronizado_nube_por"],
        articuloPortada: json["articulo_portada"],
        servicioSalud: json["servicio_salud"],
        semoviente: json["semoviente"],
        kilogramos: json["kilogramos"],
        porcentajeDescuentoCompras: json["porcentaje_descuento_compras"],
        porcentajeDescuentoVentas: json["porcentaje_descuento_ventas"],
        bonificacion: json["bonificacion"],
        notaComanda: json["nota_comanda"],
        aplicaRea: json["aplica_rea"],
        tarifaReducidaRea: json["tarifa_reducida_rea"],
        bultosCargaCamionCheckout: json["bultos_carga_camion_checkout"],
        solicitaFechaVencimientoCheckout: json["solicita_fecha_vencimiento_checkout"],
        costoDolaresReferencia: json["costo_dolares_referencia"],
        fechaUltimoCambioCabys: json["fecha_ultimo_cambio_cabys"],
        conocidoComo: json["conocido_como"],
        diasGarantia: json["dias_garantia"],
        tipoCalculoComision: json["tipo_calculo_comision"],
        articuloConSerie: json["articulo_con_serie"],
        familia: json["familia"] == null ? null : Familia.fromMap(json["familia"]),
        impuesto: json["impuesto"] == null ? null : Impuesto.fromMap(json["impuesto"]),
        marca: json["marca"] == null ? null : Marca.fromMap(json["marca"]),
        costo: json["costo"] == null ? 0 : json["costo"].toDouble(),
        venta: json["venta"] == null ? 0 : json["venta"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "cod_articulo": codArticulo,
        "cod_familia": codFamilia,
        "cod_marca": codMarca,
        "descripcion": descripcion,
        "modelo": modelo,
        "precio_default": precioDefault,
        "costo_proveedor": costoProveedor,
        "costo_promedio": costoPromedio,
        "costo_base": costoBase,
        "activo": activo,
        "creado_por": creadoPor,
        // ignore: prefer_null_aware_operators
        "fecha_creacion": fechaCreacion != null ? fechaCreacion?.toIso8601String() : null,
        "modificado_por": modificadoPor,
        // ignore: prefer_null_aware_operators
        "fecha_modificacion": fechaModificacion != null ? fechaModificacion?.toIso8601String() : null,
        "porcentaje_utilidad": porcentajeUtilidad,
        "porc_descuento_actual": porcDescuentoActual,
        "cod_impuesto": codImpuesto,
        "habilitar_cambiar_precio": habilitarCambiarPrecio,
        "cantidad_min_desc": cantidadMinDesc,
        "porc_descuento_x_cant": porcDescuentoXCant,
        "art_control": artControl,
        "art_granel": artGranel,
        "aplica_inventario": aplicaInventario,
        "activar_articulos_relacionados": activarArticulosRelacionados,
        "ubicacion": ubicacion,
        "porcentaje_comision": porcentajeComision,
        "porcentaje_utilidad_sugerido": porcentajeUtilidadSugerido,
        "notas": notas,
        "aplica_comandas": aplicaComandas,
        "unidad_compra": unidadCompra,
        "unidad_venta": unidadVenta,
        "permite_venta_unitaria": permiteVentaUnitaria,
        "unidad_empaque": unidadEmpaque,
        "ultimo_cod_proveedor": ultimoCodProveedor,
        "ultimo_num_factura_proveedor": ultimoNumFacturaProveedor,
        "unidad_medida": unidadMedida,
        "factor_medida": factorMedida,
        "porc_tope_descuento_1": porcTopeDescuento1,
        "porc_tope_descuento_2": porcTopeDescuento2,
        "porc_tope_descuento_3": porcTopeDescuento3,
        // ignore: prefer_null_aware_operators
        "fecha_ultima_compra": fechaUltimaCompra != null ? fechaUltimaCompra?.toIso8601String() : null,
        "generar_codigo_alternativo_automatico": generarCodigoAlternativoAutomatico,
        "articulo_romana": articuloRomana,
        "volumen": volumen,
        "peso": peso,
        "consolidado_bultos_sellado": consolidadoBultosSellado,
        "notas_tecnicas": notasTecnicas,
        "cargar_imagen_automatica": cargarImagenAutomatica,
        "pesado_automatico": pesadoAutomatico,
        "articulo_relacionado_agrupador": articuloRelacionadoAgrupador,
        "es_combo": esCombo,
        "proveedor": proveedor,
        "clase": clase,
        "segmento": segmento,
        "tamano": tamano,
        "cod_articulo_comilla": codArticuloComilla,
        "tipo_articulo": tipoArticulo,
        "numero_parte": numeroParte,
        "es_receta": esReceta,
        "es_insumo": esInsumo,
        "aplica_devoluciones": aplicaDevoluciones,
        "porc_descuento_ultima_compra": porcDescuentoUltimaCompra,
        "cod_ultima_factura": codUltimaFactura,
        // ignore: prefer_null_aware_operators
        "fecha_ultima_venta": fechaUltimaVenta != null ? fechaUltimaVenta?.toIso8601String() : null,
        "concepto_facturacion": conceptoFacturacion,
        "venta_libre": ventaLibre,
        "costo_especial": costoEspecial,
        "porcentaje_utilidad_deseada": porcentajeUtilidadDeseada,
        "omitir_mov_inv_insumos_receta": omitirMovInvInsumosReceta,
        "aplica_timbre_odontologico": aplicaTimbreOdontologico,
        "precio_fijo": precioFijo,
        "porcentaje_utilidad_minimo_facturacion": porcentajeUtilidadMinimoFacturacion,
        "tipo_precios": tipoPrecios,
        "partida_arancelaria": partidaArancelaria,
        "porc_dai": porcDai,
        "iva_a_aplicar": ivaAAplicar,
        "iva_para_prorrata": ivaParaProrrata,
        "cod_cabys": codCabys,
        "cod_impuesto_cabys": codImpuestoCabys,
        "bloqueado_para_venta": bloqueadoParaVenta,
        "sincronizado_nube": sincronizadoNube,
        "fecha_sincronizado_nube": fechaSincronizadoNube,
        "sincronizado_nube_por": sincronizadoNubePor,
        "articulo_portada": articuloPortada,
        "servicio_salud": servicioSalud,
        "semoviente": semoviente,
        "kilogramos": kilogramos,
        "porcentaje_descuento_compras": porcentajeDescuentoCompras,
        "porcentaje_descuento_ventas": porcentajeDescuentoVentas,
        "bonificacion": bonificacion,
        "nota_comanda": notaComanda,
        "aplica_rea": aplicaRea,
        "tarifa_reducida_rea": tarifaReducidaRea,
        "bultos_carga_camion_checkout": bultosCargaCamionCheckout,
        "solicita_fecha_vencimiento_checkout": solicitaFechaVencimientoCheckout,
        "costo_dolares_referencia": costoDolaresReferencia,
        "fecha_ultimo_cambio_cabys": fechaUltimoCambioCabys,
        "conocido_como": conocidoComo,
        "dias_garantia": diasGarantia,
        "tipo_calculo_comision": tipoCalculoComision,
        "articulo_con_serie": articuloConSerie,
        "familia": familia?.toMap(),
        "impuesto": impuesto?.toMap(),
        "marca": marca?.toMap(),
        "costo": costo,
        "venta": venta,
    };
}

