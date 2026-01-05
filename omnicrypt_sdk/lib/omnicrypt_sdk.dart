
import 'dart:typed_data';

import 'omnicrypt_sdk_platform_interface.dart';

class Omnicrypt {
  static Future<String> createKey({String? keyId}) {
    return OmnicryptSdkPlatform.instance.createKey(keyId: keyId);
  }

  static Future<Uint8List> encrypt(Uint8List plaintext, {required String keyId}) {
    return OmnicryptSdkPlatform.instance.encrypt(plaintext, keyId: keyId);
  }

  static Future<Uint8List> decrypt(Uint8List ciphertext, {required String keyId}) {
    return OmnicryptSdkPlatform.instance.decrypt(ciphertext, keyId: keyId);
  }
}
