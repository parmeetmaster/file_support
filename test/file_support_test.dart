import 'package:flutter_test/flutter_test.dart';
import 'package:file_support/file_support.dart';
import 'package:file_support/file_support_platform_interface.dart';
import 'package:file_support/file_support_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFileSupportPlatform
    with MockPlatformInterfaceMixin
    implements FileSupportPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FileSupportPlatform initialPlatform = FileSupportPlatform.instance;

  test('$MethodChannelFileSupport is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFileSupport>());
  });

  test('getPlatformVersion', () async {
    FileSupport fileSupportPlugin = FileSupport();
    MockFileSupportPlatform fakePlatform = MockFileSupportPlatform();
    FileSupportPlatform.instance = fakePlatform;

    expect(await fileSupportPlugin.getPlatformVersion(), '42');
  });
}
