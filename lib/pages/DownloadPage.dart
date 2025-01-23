import 'package:file_transfer/service/client_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Downloadpage extends StatefulWidget {

  const Downloadpage({super.key});

  @override
  State<Downloadpage> createState() => _DownloadpageState();
}

class _DownloadpageState extends State<Downloadpage> {
  ClientApi client = ClientApi();

  List<dynamic> fileList = [];
  List<String> deleteList = [];
  bool isLoading = true;

  Future<void> fetchListFile() async {
    fileList = await client.getListFiles();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchListFile();
    super.initState();
  }

  

  void deleteFile(int index) async {
    client.deleteFile(fileList[index][0]);
    setState(() {
      deleteList.add(fileList[index][0]);
      // fileList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading){
      return LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColorDark),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Download fileList"),
          ),
          body: ListView.builder(
                // padding: EdgeInsets.all(16.0),
                itemCount: fileList.length,
                itemBuilder: (context, index) {
                  final file = fileList[index];
                  final fileName = file[0];
                  final fileListize = file[1] + " MB";
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Slidable(
                      endActionPane: ActionPane(
                        extentRatio: 0.15,
                        motion: StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) => deleteFile(index),
                            icon: Icons.delete_forever,
                            backgroundColor: Colors.red,
                            borderRadius: BorderRadius.circular(7),
                          )
                        ],
                      ),
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: ListTile(
                          leading: _buildFileIcon(fileName),
                          title: Text(
                            fileName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            fileListize,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: ElevatedButton.icon(
                            onPressed: () {
                              // Add download logic here
                            },
                            icon: Icon(Icons.download),
                            label: Text("Download"),
                            style: ElevatedButton.styleFrom(
                              elevation: 2,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
      );
    }
  }
        




  // Function to get a file icon based on the file type
  Widget _buildFileIcon(String fileName) {
    if (fileName.endsWith(".pdf")) {
      return Icon(Icons.picture_as_pdf, color: Colors.red, size: 40);
    } else if (fileName.endsWith(".jpg") || fileName.endsWith(".png")) {
      return Icon(Icons.image, color: Colors.blue, size: 40);
    } else if (fileName.endsWith(".zip") || fileName.endsWith(".rar")) {
      return Icon(Icons.archive, color: Colors.orange, size: 40);
    } else {
      return Icon(Icons.insert_drive_file, color: Colors.grey, size: 40);
    }
  }
}