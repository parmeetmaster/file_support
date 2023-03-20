
import 'package:file_support/dependency/fileutils.dart';
import 'package:file_support/dependency/image.dart';

import 'file_support_platform_interface.dart';

class FileSupport  with ImageOperations, FileUtils{
  Future<String?> getPlatformVersion() {
    return FileSupportPlatform.instance.getPlatformVersion();
  }
}
