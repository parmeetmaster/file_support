import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_support_example/screens/file_details.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: ListView(
        children: [
          ElevatedButton(
              onPressed: () {
                move_to_next_screen();
              },
              child: Text("Click to pick file"))
        ],
      ),
    );
  }

  void move_to_next_screen() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File file = File(result!.files.single.path!);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FileDetails(file)));
  }
}
