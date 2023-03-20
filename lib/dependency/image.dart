import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:file_support/model/FileData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart' as httparser;
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'dart:ui' as ui;
import '../file_support.dart';
import '../utils/utils.dart';
import 'fileutils.dart';

mixin ImageOperations {
  /// This tell user about image resolution
  Future<FileData> getImageReslution(File file) async {
// Or any other way to get a File instance.
    String imageType = FileSupport().getFileType(file);
    if (imageType.toLowerCase() != "image") {
      "Images only have resolution, No other file have resolution".printerror;
      return FileData();
    }
    var decodedImage = await decodeImageFromList(file.readAsBytesSync());
    print("Image Resolution is");
    "Width ${decodedImage.width}, Height${decodedImage.height}".printinfo;
    return FileData(
        imagewidth: decodedImage.width, imageheight: decodedImage.height);
  }

  /// This function is used for convert image file to Multipart to uplaod using Dio
  Future<MultipartFile>? getMultiPartImage(File file) async {
    var pic = await MultipartFile.fromFile(file.path,
        filename: file.path.split("/").last,
        contentType:
            httparser.MediaType.parse("image/${file.path.split(".").last}"));
    return pic;
  }

  /// This function is used to get compress image

  Future<File?> compressImage(File file,
      {int? quality = 50, int? rotate = 0}) async {
    String? str = FileSupport().getFileExtension(file);

    ("The file extension of image" + str!).printinfo;
    if (FileSupport().getFileType(file).toLowerCase() != "image") {
      "Only Images are used for compression".printinfo;
      return null;
    }

    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: quality!,
      rotate: rotate!,
    );
    print("Compress data is${file.lengthSync()}");
    print("Compress data is${result!.length}");

    File? compressimage = await FileSupport()
        .writeUint8ListtoTemporaryDirectory(
            data: result, extension: FileSupport().getFileExtension(file));

    return compressimage;
  }

  ///todo pending
  /// this function is used to generate random image for testing ui without adding images in asset folder
  void generateImage() async {
    final Random rd = new Random();
    double kCanvasSize = 500;
    final color = Colors.primaries[rd.nextInt(Colors.primaries.length)];

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder,
        Rect.fromPoints(Offset(0.0, 0.0), Offset(kCanvasSize, kCanvasSize)));

    final stroke = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, kCanvasSize, kCanvasSize), stroke);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(
          rd.nextDouble() * kCanvasSize * 0.5,
          rd.nextDouble() * kCanvasSize * 0.5,
        ),
        70.0,
        paint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(200, 200);
    final pngBytes = await img.toByteData(format: ImageByteFormat.png);
    /*  setState(() {
      imgBytes = pngBytes!;
    });*/
  }
}
