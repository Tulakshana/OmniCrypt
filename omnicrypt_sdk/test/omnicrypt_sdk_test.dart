import 'package:flutter_test/flutter_test.dart';
import 'package:omnicrypt_sdk/omnicrypt_sdk.dart';
import 'package:omnicrypt_sdk/omnicrypt_sdk_platform_interface.dart';
import 'package:omnicrypt_sdk/omnicrypt_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'dart:typed_data';

class MockOmnicryptSdkPlatform
    with MockPlatformInterfaceMixin
    implements OmnicryptSdkPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String> createKey({String? keyId}) => Future.value(keyId ?? 'mock-key');

  @override
  Future<Uint8List> encrypt(Uint8List plaintext, {required String keyId}) =>
      Future.value(Uint8List.fromList([1, 2, 3]));

  @override
  Future<Uint8List> decrypt(Uint8List ciphertext, {required String keyId}) =>
      Future.value(Uint8List.fromList([4, 5, 6]));
}

void main() {
  final OmnicryptSdkPlatform initialPlatform = OmnicryptSdkPlatform.instance;

  test('$MethodChannelOmnicryptSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOmnicryptSdk>());
  });

  test('createKey', () async {
    MockOmnicryptSdkPlatform fakePlatform = MockOmnicryptSdkPlatform();
    OmnicryptSdkPlatform.instance = fakePlatform;

    expect(await Omnicrypt.createKey(keyId: 'test-key'), 'test-key');
  });

  test('encrypt', () async {
    MockOmnicryptSdkPlatform fakePlatform = MockOmnicryptSdkPlatform();
    OmnicryptSdkPlatform.instance = fakePlatform;

    final plaintext = Uint8List.fromList([1, 2, 3]);
    expect(await Omnicrypt.encrypt(plaintext, keyId: 'test-key'), Uint8List.fromList([1, 2, 3]));
  });

  test('decrypt', () async {
    MockOmnicryptSdkPlatform fakePlatform = MockOmnicryptSdkPlatform();
    OmnicryptSdkPlatform.instance = fakePlatform;

    final ciphertext = Uint8List.fromList([1, 2, 3]);
    expect(await Omnicrypt.decrypt(ciphertext, keyId: 'test-key'), Uint8List.fromList([4, 5, 6]));
  });
}
