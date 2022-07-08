import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_support_example/screens/canvas_maker.dart';
import 'package:file_support_example/screens/file_details.dart';
import 'package:file_support_example/screens/first_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:file_support/file_support.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home:ImageGenerator() ,
      home: FirstScreen(),
    );
  }
}
