import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:omnicrypt_sdk/omnicrypt_sdk_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelOmnicryptSdk platform = MethodChannelOmnicryptSdk();
  const MethodChannel channel = MethodChannel('omnicrypt_sdk');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          return '42';
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
