import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file_support/file_support.dart';

void main() {
  const MethodChannel channel = MethodChannel('file_support');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FileSupport.platformVersion, '42');
  });
}
