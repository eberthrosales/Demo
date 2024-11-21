import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ApiService {
  static const String apiUrl = "http://192.168.171.103:3000/upload";  // Dirección IP de tu PC

  static Future<bool> uploadFile(File file) async {
    try {
      var uri = Uri.parse(apiUrl);
      var request = http.MultipartRequest('POST', uri);

      // Obtiene el tipo MIME del archivo
      var mimeType = lookupMimeType(file.path)?.split('/');
      var fileStream = http.MultipartFile(
        'file',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: file.uri.pathSegments.last,
        contentType: MediaType(mimeType?[0] ?? 'application', mimeType?[1] ?? 'octet-stream'),
      );

      request.files.add(fileStream);

      var response = await request.send();

      if (response.statusCode == 200) {
        return true;  // Archivo subido con éxito
      } else {
        print('Error al subir el archivo: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error al subir archivo: $e');
      return false;
    }
  }
}
