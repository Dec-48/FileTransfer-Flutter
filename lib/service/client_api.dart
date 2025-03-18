import "dart:typed_data";
import "dart:convert";
import "dart:io";

import "package:file_picker/file_picker.dart";
import "package:file_saver/file_saver.dart";
import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;
import 'package:logger/logger.dart';

class ClientApi {
  Logger logger = Logger();
  final String uploadPathApi = "http://192.168.1.111:8080/api/upload";
  final String downloadPathApi = "http://192.168.1.111:8080/api/download";
  final String deletePathApi = "http://192.168.1.111:8080/api/delete";
  bool dowloadPermit = false;

  Future<void> uploadFile(PlatformFile? selectedFile) async {
    bool forWeb = true;
    if (forWeb){
      Uint8List fileByte = selectedFile!.bytes!;
      String fileName = selectedFile.name;
      final Uri uploadApi = Uri.parse(uploadPathApi);
      http.MultipartRequest req = http.MultipartRequest("POST", uploadApi);
      try {
        req.files.add(http.MultipartFile.fromBytes(
          "upFile",
          fileByte,
          filename: fileName
        ));
        http.StreamedResponse response = await req.send();
        String? body = response.reasonPhrase;
        int statusCode = response.statusCode;
        // logger.i("$statusCode : $body");
      } catch (e) {
        // logger.i(e.toString());
      }
    } else { //! probably work for only windows ???
      Uint8List fileByte = await File(selectedFile!.path!).readAsBytes();
      String fileName = selectedFile.name;
      final Uri uploadApi = Uri.parse(uploadPathApi);
      http.MultipartRequest req = http.MultipartRequest("POST", uploadApi);
      try {
        req.files.add(http.MultipartFile.fromBytes(
          "upFile",
          fileByte,
          filename: fileName
        ));
        http.StreamedResponse response = await req.send();
        String? body = response.reasonPhrase;
        int statusCode = response.statusCode;
        logger.i("$statusCode : $body");
      } catch (e) {
        logger.i(e.toString());
      }
    }
  }



  Future<List<dynamic>> getListFiles() async {
    final Uri downloadApi = Uri.parse(downloadPathApi);
    http.Response response = await http.get(downloadApi);
    try {
      List<dynamic> info = jsonDecode(response.body);
      String body = response.body;
      int statusCode = response.statusCode;
      // logger.i("$statusCode : $body");
      return info;
    } catch (e) {
      // logger.e("error occur in getListFIles");
      throw e.toString();      
    }
  }

  Future<void> deleteFile(String name) async {
    final Uri deleteApi = Uri.parse("$deletePathApi/$name");
    http.Response response = await http.delete(deleteApi);
    // try {
      // String body = response.body;
      // int statusCode = response.statusCode;
      // logger.i("$statusCode : $body");
    // } catch (e) {
      // logger.e("error occur in deleteFile");
      // throw e.toString();
    // }
  }

  Future<void> downloadFile(String fileName) async {
    try {
      LinkDetails ld = LinkDetails(
        link: "$downloadPathApi/$fileName", 
        method: "GET"
      );
      String x = await FileSaver.instance.saveFile(
        name: fileName,
        link: ld
      );
    } catch (e) {
      // logger.e(e.toString());
    }
  }

}