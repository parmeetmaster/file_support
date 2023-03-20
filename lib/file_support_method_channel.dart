import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'file_support_platform_interface.dart';

/// An implementation of [FileSupportPlatform] that uses method channels.
class MethodChannelFileSupport extends FileSupportPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('file_support');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
