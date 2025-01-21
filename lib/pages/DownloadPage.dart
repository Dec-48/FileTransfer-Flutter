import 'package:file_transfer/service/client_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Downloadpage extends StatelessWidget {
  ClientApi client = ClientApi();
  Downloadpage({super.key});

  Future<List<dynamic>> fetchListFile() async {
    return await client.getListFiles();
  }

  Future<void> deleteFile() async {
    client.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Download fileList"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchListFile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          } 
          else if (snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          } 
          else {
            List<dynamic> fileList = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: fileList.length,
              itemBuilder: (context, index) {
                final file = fileList[index];
                final fileName = file[0];
                final fileListize = file[1] + " MB";
            
                return Slidable(
                  endActionPane: ActionPane(
                    children: [
                      SlidableAction(
                        onPressed: ,
                      )
                    ],
                  ),
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8.0),
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
                );
              },
            );

          }
        }
      ),
    );
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