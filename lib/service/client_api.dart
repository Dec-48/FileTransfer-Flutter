import "dart:typed_data";
import "dart:convert";

import "package:file_picker/file_picker.dart";
import "package:http/http.dart" as http;

class ClientApi {
  final Uri uploadApi = Uri.parse("http://localhost:8080/api/upload");
  final Uri downloadApi = Uri.parse("http://localhost:8080/api/download");
  final String deletePathApi = "http://localhost:8080/api/delete";
  // final Uri deleteApi = Uri.parse("http://localhost:8080/api/delete");

  Future<void> uploadFile(PlatformFile? selectedFile) async {
    Uint8List fileByte = selectedFile!.bytes!;
    String fileName = selectedFile.name;
    
    http.MultipartRequest req = http.MultipartRequest("POST", uploadApi);
    try {
      req.files.add(http.MultipartFile.fromBytes(
        "upFile",
        fileByte,
        filename: fileName
      ));
      http.StreamedResponse response = await req.send();
      print(response.statusCode);
    } catch (e) {
      print("error");
      print(e.toString());
    }
  }

  Future<List<dynamic>> getListFiles() async {
    try {
      http.Response response = await http.get(downloadApi);
      List<dynamic> info = jsonDecode(response.body);
      return info;
    } catch (e) {
      throw e.toString();      
    }
  }

  Future<void> deleteFile(String name) async {
    final Uri deleteApi = Uri.parse("$deletePathApi/$name");
    try {
      http.Response response = await http.get(deleteApi);
      String body = response.body;
      int statusCode = response.statusCode;
      print("$statusCode : $body");
    } catch (e) {
      print("Can't delete");
      throw e.toString();
    }
  }

}