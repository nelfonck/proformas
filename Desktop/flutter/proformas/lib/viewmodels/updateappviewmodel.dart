import 'package:context_holder/context_holder.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdateAppViewModel extends ChangeNotifier {

  double downloadingProgress = 0 ;
  String appUrl = '';
  String fileName = '';

 Future init(String appUrl, String fileName) async {
    this.appUrl = appUrl ;
    this.fileName = fileName ;
    if ( await _askForPermissions() ){
      await downloadFile(appUrl, filename: fileName).onError((error, stackTrace) {
        if(ContextHolder.currentContext.mounted){
         Dlg.showError(ContextHolder.currentContext, error.toString());
        }
      });
    }
  }

  Future<bool> _askForPermissions() async {
    var install = await Permission.requestInstallPackages.status;

    if (install.isGranted) {
      return true;
    }

    install = await Permission.requestInstallPackages.request();

    return install.isGranted;
  }

  Future<void> downloadFile(String url, {String? filename}) async {
    final httpClient = http.Client();

    try {
      final request = http.Request('GET', Uri.parse(url));
      final response = await httpClient.send(request);

      if (response.statusCode != 200) {
        throw Exception(
            "Error al descargar el archivo. Código: ${response.statusCode}");
      }

      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        throw Exception("No se pudo obtener el directorio de almacenamiento.");
      }

      final file = File('${dir.path}/$filename');
      final sink = file.openWrite();

      int downloaded = 0;
      final totalBytes = response.contentLength ?? 0;

      await for (final chunk in response.stream) {
        sink.add(chunk);

        downloaded += chunk.length;

        if (totalBytes > 0) {
          downloadingProgress = (downloaded / totalBytes) * 100;
          notifyListeners();
        }
      }

      await sink.flush();
      await sink.close();

      downloadingProgress = 100;
      notifyListeners();

      OpenResult result = await OpenFile.open(file.path);

      if (result.type != ResultType.done) {
        if (ContextHolder.currentContext.mounted){
          Dlg.showError(ContextHolder.currentContext, result.message);
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      httpClient.close();
    }
  }
}