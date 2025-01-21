
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Uploadpage extends StatefulWidget {
  const Uploadpage({super.key});

  @override
  State<Uploadpage> createState() => _UploadpageState();
}

class _UploadpageState extends State<Uploadpage> {

  PlatformFile? selectedFile; 
  String testingStr = "Default";
  
  Future pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any
    );
    if (result == null) return;

    setState(() {
      selectedFile = result.files.first;
    });
  }

  void deselectFile(){
    setState(() {
      selectedFile = null;
    });
  }

  Future<void> uploadFile() async {
    Uri uri = Uri.parse("http://192.168.1.115:8080/api/upload");
    
    Uint8List fileByte = selectedFile!.bytes!;
    String fileName = selectedFile!.name;
    
    http.MultipartRequest req = http.MultipartRequest("POST", uri);

    req.files.add(http.MultipartFile.fromBytes(
      "upFile",
      fileByte,
      filename: fileName
    ));

    http.StreamedResponse response = await req.send();
    print(response.statusCode);

    setState(() {
      selectedFile = null;
    });
  }

  Future<void> callGet() async {
    Uri uri = Uri.parse("http://192.168.1.115:8080/api/upload");
    http.Response res = await http.get(uri);
    if (res.statusCode == 202){
      print("accepted");
    } else {
      print("fail !!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Files"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Text
            Text(
              "Upload Your Files",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Selected File Name (if any)
            if (selectedFile != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon : Icon(Icons.delete_forever, color: Colors.red, size: 27,),
                    onPressed: deselectFile,
                  ),
                  Flexible(
                    child: Text(
                      " ${selectedFile!.name}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ElevatedButton(
              onPressed: pickFile,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                "Select File",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),

            // Upload Button
            ElevatedButton(
              onPressed: (selectedFile != null) ? () {
                uploadFile();
                // callGet();
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //       content: Text("Uploading: ${selectedFile!.name}"),
                //   ),
                // );  
              } : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                "Upload File",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
