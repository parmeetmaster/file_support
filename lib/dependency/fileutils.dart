import 'dart:io';

import 'package:file_support/dependency/type.dart';
import 'package:file_support/file_support.dart';
import 'package:logger/logger.dart';
import 'package:mime_type/mime_type.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import '../utils/utils.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_support/dependency/fileutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart' as httparser;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:path/path.dart' as p;
import 'filesize.dart';

mixin FileUtils {
  /// its help to get file category like image zip etc
  String getFileType(File? file) {
    if (file == null) {
      "File can'nt be null".printerror;
    }
    String? mimeType = mime(file!.absolute.path);
    String mimee = mimeType!.split('/')[0];
    String type = mimeType.split('/')[1];
    "MIME TYPE ${mimeType}  , ${mimee}, ${type} ".printinfo;
    return mimee;
  }

  /// its used to get multipart file from any extension.
  Future<MultipartFile>? getMultiPartFromFile(File file) async {
    String? mimeType = mime(file.absolute.path);
    String mimee = mimeType!.split('/')[0];
    String type = mimeType.split('/')[1];
    print("MIME TYPE ${mimeType}  , ${mimee}, ${type} ");
    var pic = await MultipartFile.fromFile(file.path,
        filename: file.path.split("/").last,
        contentType: MediaType(mimee, type));
    return pic;
  }

  /// This method user to get http multipart request file
  Future<http.MultipartFile>? getHttpMutipartFile(
      {required String field, required File file}) async {
    String? mimeType = mime(file.absolute.path);
    String mimee = mimeType!.split('/')[0];
    String type = mimeType.split('/')[1];
    print("MIME TYPE ${mimeType}  , ${mimee}, ${type} ");

    var pic = http.MultipartFile.fromBytes('picture', file.readAsBytesSync(),
        filename: file.path.split("/").last,
        contentType: httparser.MediaType(mimee, type));
    return pic;
  }

  /// This function is used for get file name with extension
  String? getFileName(File file) {
    return file.path.split('/').last;
  }

  /// This function is used for get file name with extension from text ***************
  String? getFileNameFromText(String text) {
    return text.split('/').last;
  }

  /// This is used to get file extension
  String? getFileExtension(File file) {
    return p.extension(file.path, 2);
  }

  /// this function is used to get file name without extension
  String? getFileNameWithoutExtension(File file) {
    return file.path.split("/").last;
  }

  /// this function is used to convert any file to base 64 string
  Future<String?> getBase64FromFile(File file) async {
    Uint8List imageBytes = await file.readAsBytes();
    debugPrint(base64Encode(imageBytes));
    String base64String = base64Encode(imageBytes);
    return base64String;
  }

  /// this function convert base64 to file with 3 inputs base64 string , name for comming file, and extension
  Future<File?> getFileFromBase64(
      {required String base64string,
      required String name,
      required String extension}) async {
    final decodedBytes = base64Decode(base64string);
    Directory tempdirectory = await pp.getTemporaryDirectory();

    File file = File("${tempdirectory.path}/${name}.${extension}");
    file.writeAsBytes(decodedBytes);
    return file;
  }

  /// this function return size of any file in flutter
  String? getFileSize({required File file}) {
    print(file.lengthSync());
    return "${FileSize().getSize(file.lengthSync())}";
  }

  ///This used to write Byte data to file like image is compress or download it will
  Future<File?> writeFiletoTemporaryDirectory(
      {ByteData? data, String? extension = ""}) async {
    if (data == null) return null;
    final buffer = data.buffer;
    Directory tempDir = await pp.getTemporaryDirectory();
    String tempPath = tempDir.path;
    String uuid = Uuid().v4();
    var filePath = tempPath + '/${uuid}.${extension}';
    return new File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  ///This used to write Byte data to file like image is compress or download it will
  Future<File?> writeUint8ListtoTemporaryDirectory(
      {Uint8List? data, String? extension = ""}) async {
    if (data == null) return null;
    Directory tempDir = await pp.getTemporaryDirectory();
    String tempPath = tempDir.path;
    String uuid = Uuid().v4();
    var filePath = tempPath + '/${uuid}.${extension}';
    return new File(filePath).writeAsBytes(data);
  }

  /// This function used for downlaod file from url and use locally for serveral purposes
  /// url is http location where file avaiblable for downlaod
  /// Progress is callback tell about download progress
  /// Storage directory tell where to download file currruntly avaiable for android devices only
  Future<File?> downloadFile(
      {String? url,
      Function(String)? progress,
      pp.StorageDirectory? storageDirectory}) async {
    Dio dio = new Dio();

    if (url == null) {
      "Download Location cant be null".printerror;
      return null;
    }

    List<Directory>? tempDir =
        await pp.getExternalStorageDirectories(type: storageDirectory);

    String? urlFileType = getUrlFileExtension(url);

    String fullPath = tempDir!.first.path + "/${Uuid().v4()}${urlFileType}";
    fullPath.printinfo;
    File file = new File("");
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            if (progress != null)
              progress((received / total * 100).toStringAsFixed(0));
          }
        },
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response.headers);
      file = File(fullPath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
      return null;
    }
    return file;
  }

  /// use to download file download folder
  Future<File?> downloadFileInDownloadFolderAndroid(
      {required String? url,
      Function(String)? progress,
      required String filename,
      required String extension}) async {
    String? android_path = "${await getDownloadFolderPath()}/";
    File? file = await downloadCustomLocation(
        url: url,
        path: android_path,
        filename: filename,
        extension: extension,
        progress: progress);
    return file;
  }

  /// this is used to download any location in as per user wants
  /// in case directory not exist it will create automatically
  Future<File?> downloadCustomLocation(
      {required String? url,
      Function(String)? progress,
      required String filename,
      required String extension,
      required path}) async {
    Dio dio = new Dio();

    if (url == null) {
      "Download Location cant be null".printerror;
      return null;
    }

    String? android_path = path;
    android_path!.printwarn;

    Directory directory = await new Directory(android_path);
    // create directory if not exist
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    directory;

    String fullPath = android_path + filename + "${extension}";
    fullPath.printinfo;
    File file = new File("");
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            if (progress != null)
              progress((received / total * 100).toStringAsFixed(0));
          }
        },
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response.headers);
      file = File(fullPath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
    return file;
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  /// This tell user about where is download directory located in flutter
  Future<String?>? getDownloadFolderPath() async {
    Directory? directory;

    try {
      if (Platform.isAndroid) {
        if (await requestPermission(Permission.storage)) {
          directory = (await pp.getExternalStorageDirectory())!;
          String newPath = "";
          print(directory);
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/Download";
          directory = Directory(newPath);
        } else {
          return "";
        }
      } else {
        if (await requestPermission(Permission.photos)) {
          directory = await pp.getApplicationDocumentsDirectory();
        } else {
          return "";
        }
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        return directory.path;
      }
    } catch (e) {
      print(e);
    }
    if (directory == null) return null;

    return directory.path;
  }

  /// This tell user about where root directory located in flutter ****************
  Future<String?>? getRootFolderPath() async {
    Directory? directory;

    try {
      if (Platform.isAndroid) {
        if (await requestPermission(Permission.storage)) {
          directory = (await pp.getExternalStorageDirectory())!;
          String newPath = "";
          print(directory);
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          directory = Directory(newPath);
        } else {
          return "";
        }
      } else {
        if (await requestPermission(Permission.photos)) {
          directory = await pp.getApplicationDocumentsDirectory();
        } else {
          return "";
        }
      }

      /*    if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        return directory.path;
      }*/
    } catch (e) {
      print(e);
    }
    if (directory == null) return null;

    return directory.path;
  }

  /// https://retroportalstudio.medium.com/saving-files-to-application-folder-and-gallery-in-flutter-e9be2ebee92a
  Future<File?> downloadFileIos(
      {String? url,
      Function(String)? progress,
      pp.StorageDirectory? storageDirectory}) async {
    Dio dio = new Dio();

    if (url == null) {
      "Download Location cant be null".printerror;
      return null;
    }

    Directory? tempDir = await pp.getExternalStorageDirectory();

    String? urlFileType = getUrlFileExtension(url);

    String fullPath = tempDir!.path + "/${Uuid().v4()}${urlFileType}";
    fullPath.printinfo;
    File file = new File("");
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            if (progress != null)
              progress((received / total * 100).toStringAsFixed(0));
          }
        },
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response.headers);
      file = File(fullPath);
      fullPath.printwarn;
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
      return null;
    }
    return file;
  }

  // This is used to get file extension ********
  String? getUrlFileExtension(String url) {
    return p.extension(url, 2);
  }

  /// pending add on git
  /// get Image type via category like image zip etc

}
