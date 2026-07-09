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

 init(String appUrl, String fileName) async {
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

  Future<bool> _askForPermissions() async{
    PermissionStatus installPackages = await Permission.requestInstallPackages.status;
    PermissionStatus storage = await Permission.storage.status;

    if ( storage.isGranted && installPackages.isGranted ){
      return true;
    } else if ( storage.isDenied && installPackages.isDenied){
      if ( await Permission.storage.request().isGranted ){
        if ( await Permission.requestInstallPackages.request().isGranted ){
          return true;
        } else {
          return false;
        }
      }
    } else if ( storage.isGranted && installPackages.isDenied ){
      if ( await Permission.requestInstallPackages.request().isGranted ){
        return true;
      } else {
        return false;
      }
    } else if ( storage.isDenied && installPackages.isGranted ){
      if ( await Permission.storage.request().isGranted ){
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  Future downloadFile(String url, {String? filename}) async {
    var httpClient = http.Client();
    var request =  http.Request('GET', Uri.parse(url));
    var response = httpClient.send(request);
    final dir = (await getExternalStorageDirectory())?.path;

    List<List<int>> chunks =  [];
    int downloaded = 0;

    response.asStream().listen((http.StreamedResponse r) {

      r.stream.listen((List<int> chunk) {

        downloadingProgress = downloaded / r.contentLength! * 100;
        notifyListeners();

        chunks.add(chunk);
        downloaded += chunk.length;
      }, onDone: () async {
        
        downloadingProgress = downloaded / r.contentLength! * 100;
        notifyListeners();
        // Save the file
        File file =  File('$dir/$filename');
        final Uint8List bytes = Uint8List(r.contentLength!);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }
        await file.writeAsBytes(bytes); 
        OpenResult result = await OpenFile.open('$dir/$filename');  
        if ( result.type != ResultType.done ){
          // ignore: use_build_context_synchronously
          Dlg.showError(ContextHolder.currentContext, result.message);
        }
        return;       
    });
    });
  }
}