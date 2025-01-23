import 'package:file_transfer/pages/DownloadPage.dart';
import 'package:file_transfer/pages/HomePage.dart';
import 'package:file_transfer/pages/UploadPage.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MainApp());
}



class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FileTransfer (Locally)",
      home: Homepage(),
      theme: ThemeData.dark(useMaterial3: true),
      routes: {
        "" : (context) => Homepage(),
        "/upload" : (context) => Uploadpage(),
        "/download" : (context) => Downloadpage()
      },
    );
  }
}
