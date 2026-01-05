import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'dart:typed_data';

import 'omnicrypt_sdk_method_channel.dart';

abstract class OmnicryptSdkPlatform extends PlatformInterface {
  /// Constructs a OmnicryptSdkPlatform.
  OmnicryptSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static OmnicryptSdkPlatform _instance = MethodChannelOmnicryptSdk();

  /// The default instance of [OmnicryptSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelOmnicryptSdk].
  static OmnicryptSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OmnicryptSdkPlatform] when
  /// they register themselves.
  static set instance(OmnicryptSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> createKey({String? keyId}) {
    throw UnimplementedError('createKey() has not been implemented.');
  }

  Future<Uint8List> encrypt(Uint8List plaintext, {required String keyId}) {
    throw UnimplementedError('encrypt() has not been implemented.');
  }

  Future<Uint8List> decrypt(Uint8List ciphertext, {required String keyId}) {
    throw UnimplementedError('decrypt() has not been implemented.');
  }
}
