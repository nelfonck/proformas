import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {

  bool _leido = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear'),
      ),
      body: MobileScanner(
        onDetect: (capture) {

          if (_leido) return;

          final Barcode barcode = capture.barcodes.first;

          final String? codigo = barcode.rawValue;

          if (codigo == null) return;

          _leido = true;

          Navigator.pop(context, codigo);
        },
      ),
    );
  }
}