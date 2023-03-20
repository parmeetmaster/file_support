import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'file_support_method_channel.dart';

abstract class FileSupportPlatform extends PlatformInterface {
  /// Constructs a FileSupportPlatform.
  FileSupportPlatform() : super(token: _token);

  static final Object _token = Object();

  static FileSupportPlatform _instance = MethodChannelFileSupport();

  /// The default instance of [FileSupportPlatform] to use.
  ///
  /// Defaults to [MethodChannelFileSupport].
  static FileSupportPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FileSupportPlatform] when
  /// they register themselves.
  static set instance(FileSupportPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
