import 'dart:io';

import 'package:file_support/file_support.dart';
import 'package:flutter/material.dart';
import 'package:file_support/utils/utils.dart';

class FileDetails extends StatefulWidget {
  late File file;

  FileDetails(File file, {Key? key}) {
    this.file = file;
  }

  @override
  _FileDetailsState createState() => _FileDetailsState();
}

class _FileDetailsState extends State<FileDetails> {
  File? compressimage = null;
  String? base64text = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //setupFileData(widget. file);
    /*  performBase64Test();
    setupImageResolution();*/
    performImageTest();
    // downloadFile();

    /* FileSupport().getMultiPartFromFile(widget.file);*/
    _setBase64();
  }

  _setBase64() async {
    base64text =  await  FileSupport().getBase64FromFile(widget.file);
    setState(() {

    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          SizedBox(
            height: 50,
          ),
          Text("Name of file = ${FileSupport().getFileName(widget.file)}"),
          SizedBox(
            height: 50,
          ),
          Text(
              "File name without Extension = ${FileSupport().getFileNameWithoutExtension(widget.file)}"),

          SizedBox(
            height: 50,
          ),
          Text("File Size = ${FileSupport().getFileSize(file: widget.file)}"),
          SizedBox(
            height: 10,
          ),
          if (compressimage != null) Image.file(compressimage!),
          SizedBox(
            height: 10,
          ),

          ElevatedButton(
              onPressed: () {
                downloadFileandStoreInDownloadFolder();
              },
              child: Text("Download File and Store in download Folder")),
          SizedBox(
            height: 50,
          ),
          Text("File base64 = ${base64text}"),
        ],
      ),
    );
  }

  void setupFileData(File file) {
    FileSupport().getFileName(file);
  }

  void performBase64Test() async {
    String? string = await FileSupport().getBase64FromFile(widget.file);
    print(string);

    File? file = await FileSupport().getFileFromBase64(
        base64string: string!, name: "test", extension: "jpg");

    print(file!.path);
  }

  void setupImageResolution() async {
    FileSupport().getImageReslution(widget.file);
  }

  void performImageTest() async {
    compressimage = await FileSupport().compressImage(widget.file);
    setState(() {});
  }

  void downloadFile() async {
    File? file = await FileSupport().downloadFile(
        url: "https://www.rmp-streaming.com/media/big-buck-bunny-360p.mp4",
        progress: (s) {
          print(" download progress $s");
        },
        storageDirectory: StorageDirectory.downloads);
    print("download file size ${FileSupport().getFileSize(file: file!)}");
  }

  void downloadFileandStoreInDownloadFolder() async {
    String? android_path = "${await FileSupport().getRootFolderPath()}/GHMC/";
    File? file = await FileSupport().downloadCustomLocation(
        url: "https://www.rmp-streaming.com/media/big-buck-bunny-360p.mp4",
        path: android_path,
        filename: "Progress",
        extension: ".mp4",
        progress: (p) {
          p.printinfo;
        });

    print("download file size ${FileSupport().getFileSize(file: file!)}");
  }
}
