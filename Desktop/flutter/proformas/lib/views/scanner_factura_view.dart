import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScannerFacturaView extends StatefulWidget {
  const ScannerFacturaView({super.key});

  @override
  State<ScannerFacturaView> createState() => _ScannerFacturaViewState();
}

class _ScannerFacturaViewState extends State<ScannerFacturaView> {

  CameraController? _cameraController;

  late final TextRecognizer _textRecognizer;

  bool _procesando = false;
  bool _encontrado = false;

  String _textoDetectado = 'Buscando consecutivo...';

  // Para evitar aceptar un resultado falso de un solo frame.
  String? _ultimoConsecutivo;
  int _vecesDetectado = 0;

  DateTime _ultimoProcesamiento = DateTime.now();

  @override
  void initState() {
    super.initState();

    _textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );

    _iniciarCamara();
  }

  Future<void> _iniciarCamara() async {

    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se encontró ninguna cámara'),
          ),
        );

        Navigator.pop(context);
      }

      return;
    }

    // Buscamos la cámara trasera.
    final camera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await _cameraController!.initialize();

    if (!mounted) return;

    await _cameraController!.startImageStream(
      _procesarImagen,
    );

    setState(() {});
  }

  Future<void> _procesarImagen(CameraImage image) async {

    if (_procesando || _encontrado) {
      return;
    }

    // No procesamos todos los frames.
    //
    // Esto evita consumir demasiado CPU.
    final ahora = DateTime.now();

    if (ahora.difference(_ultimoProcesamiento).inMilliseconds < 400) {
      return;
    }

    _ultimoProcesamiento = ahora;

    _procesando = true;

    try {

      final inputImage = _convertirImagen(image);

      if (inputImage == null) {
        return;
      }

      final recognizedText =
          await _textRecognizer.processImage(inputImage);

      final texto = recognizedText.text;

      if (texto.trim().isEmpty) {
        return;
      }

      final consecutivo = _buscarConsecutivo(texto);

      if (consecutivo != null) {

        if (mounted) {
          setState(() {
            _textoDetectado = consecutivo;
          });
        }

        // Confirmamos que el mismo número aparezca
        // dos veces antes de aceptarlo.
        if (_ultimoConsecutivo == consecutivo) {

          _vecesDetectado++;

        } else {

          _ultimoConsecutivo = consecutivo;
          _vecesDetectado = 1;
        }

        // Con 2 lecturas iguales confirmamos el consecutivo.
        if (_vecesDetectado >= 2) {

          _encontrado = true;

          await _cameraController?.stopImageStream();

          if (!mounted) return;

          Navigator.pop(
            context,
            consecutivo,
          );
        }

      } else {

        if (mounted) {
          setState(() {
            _textoDetectado = 'Buscando consecutivo...';
          });
        }

        // Si no encuentra un consecutivo,
        // reiniciamos la confirmación.
        _ultimoConsecutivo = null;
        _vecesDetectado = 0;
      }

    } catch (e) {

      debugPrint('Error OCR: $e');

    } finally {

      _procesando = false;
    }
  }
  InputImage? _convertirImagen(CameraImage image) {

    final controller = _cameraController;

    if (controller == null) {
      return null;
    }

    final camera = controller.description;

    final rotation =
        InputImageRotationValue.fromRawValue(
      camera.sensorOrientation,
    );

    if (rotation == null) {
      return null;
    }

    final format =
        InputImageFormatValue.fromRawValue(
      image.format.raw,
    );

    if (format == null) {
      return null;
    }

    if (Platform.isAndroid &&
        format != InputImageFormat.nv21) {
      return null;
    }

    if (Platform.isIOS &&
        format != InputImageFormat.bgra8888) {
      return null;
    }

    if (image.planes.length != 1) {
      return null;
    }

    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(
          image.width.toDouble(),
          image.height.toDouble(),
        ),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  String? _buscarConsecutivo(String texto) {

    /*
     * Primero limpiamos un poco el texto.
     */
    String textoLimpio = texto
        .replaceAll('\n', ' ')
        .replaceAll('\r', ' ');

    /*
     * Buscamos específicamente la palabra
     * CONSECUTIVO y los números que vienen después.
     *
     * Ejemplo:
     *
     * Consecutivo: 00100001010000012345
     */
    final regexConsecutivo = RegExp(
      r'(?:CONSECUTIVO|CONSECUTIVO\s*N[°º]?|N[°º]?\s*CONSECUTIVO)'
      r'\s*[:\-]?\s*([0-9\s\-]{10,30})',
      caseSensitive: false,
    );

    final match = regexConsecutivo.firstMatch(textoLimpio);

    if (match != null) {

      final numero = match.group(1)!
          .replaceAll(RegExp(r'[\s\-]'), '');

      if (_esConsecutivoValido(numero)) {
        return numero;
      }
    }

    /*
     * Si el OCR no detectó la palabra "CONSECUTIVO",
     * buscamos directamente números con la estructura
     * típica del consecutivo.
     */
    final regexNumero = RegExp(
       r'\b\d{20}\b',
    );

    final numeros = regexNumero.allMatches(textoLimpio);

    for (final match in numeros) {

      final numero = match.group(0)!;

      if (_esConsecutivoValido(numero)) {
        return numero;
      }
    }

    return null;
  }

  bool _esConsecutivoValido(String numero) {
    return RegExp(r'^\d{20}$').hasMatch(numero);
  }

  @override
  void dispose() {

    _cameraController?.dispose();

    _textRecognizer.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final controller = _cameraController;

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text(
          'Escanear factura',
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

      body: controller == null ||
              !controller.value.isInitialized
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              fit: StackFit.expand,
              children: [

                CameraPreview(controller),

                /*
                 * Oscurecemos un poco los bordes
                 * para resaltar el área de lectura.
                 */
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                  ),
                ),

                Center(
                  child: Container(
                    width: double.infinity,
                    height: 180,

                    margin: const EdgeInsets.symmetric(
                      horizontal: 25,
                    ),

                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),
                ),

                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 40,

                  child: Column(
                    children: [

                      const Text(
                        'Coloque el encabezado de la factura dentro del recuadro',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius:
                              BorderRadius.circular(10),
                        ),

                        child: Text(
                          _textoDetectado,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}