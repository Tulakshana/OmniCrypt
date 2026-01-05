import 'dart:typed_data';

import 'package:omnicrypt_sdk/omnicrypt_sdk.dart';

class Storage {
  final Map<String, Uint8List> _storage = {};

  Future<String?> retrieveText(String key) async {
    try {
      // Here you would retrieve the ciphertext from persistent storage
      // For demonstration, we'll just return the decrypted text from memory
      final ciphertext = _storage[key];
      if (ciphertext != null) {
        // Decrypt the text
        final plaintext = await Omnicrypt.decrypt(ciphertext, keyId: key);
        return String.fromCharCodes(plaintext);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> saveText(String key, String text) async {
    try {
      await Omnicrypt.createKey(keyId: key);
      // Encrypt the text
      final plaintext = Uint8List.fromList(text.codeUnits);
      final ciphertext = await Omnicrypt.encrypt(plaintext, keyId: key);
      // Here you would save the ciphertext to persistent storage
      // For demonstration, we'll just store it in memory
      _storage[key] = ciphertext;
      return true;
    } catch (e) {
      return false;
    }
  }
}