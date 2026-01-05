import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'omnicrypt_sdk_platform_interface.dart';

/// An implementation of [OmnicryptSdkPlatform] that uses method channels.
class MethodChannelOmnicryptSdk extends OmnicryptSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('omnicrypt_sdk');

  @override
  Future<String> createKey({String? keyId}) async {
    final result = await methodChannel.invokeMethod<String>(
      'createKey',
      {'keyId': keyId},
    );
    return result!;
  }

  @override
  Future<Uint8List> encrypt(Uint8List plaintext, {required String keyId}) async {
    final result = await methodChannel.invokeMethod<Uint8List>(
      'encrypt',
      {'plaintext': plaintext, 'keyId': keyId},
    );
    return result!;
  }

  @override
  Future<Uint8List> decrypt(Uint8List ciphertext, {required String keyId}) async {
    final result = await methodChannel.invokeMethod<Uint8List>(
      'decrypt',
      {'ciphertext': ciphertext, 'keyId': keyId},
    );
    return result!;
  }
}
