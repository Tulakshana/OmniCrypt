# OmniCrypt

A Flutter SDK for secure encryption and decryption of strings on Android devices.

## Overview
OmniCrypt provides a simple, secure API for encrypting and decrypting strings in your Flutter app. It leverages the Android Keystore for key management and AES-GCM for encryption, ensuring sensitive data is protected at rest and in transit.

**Currently, OmniCrypt supports Android only.**

## Features
- Secure encryption and decryption of strings
- Key management using Android Keystore
- Simple Dart API
- Designed for easy integration into any Flutter app
- Follows best practices for security and error handling

## Installation
Add OmniCrypt to your `pubspec.yaml`:

```yaml
dependencies:
  omnicrypt_sdk:
    git:
      url: https://github.com/tulakshana/OmniCrypt.git
```

Then run:

```bash
flutter pub get
```

## Usage
Import the package and use the API in your Dart code:

```dart
import 'package:omnicrypt_sdk/omnicrypt_sdk.dart';
import 'dart:typed_data';

void main() async {
  // Create a new key
  await Omnicrypt.createKey(keyId: 'my-key');

  // Encrypt data
  final plaintext = Uint8List.fromList('Hello, world!'.codeUnits);
  final ciphertext = await Omnicrypt.encrypt(plaintext, keyId: 'my-key');

  // Decrypt data
  final decrypted = await Omnicrypt.decrypt(ciphertext, keyId: 'my-key');
  print(String.fromCharCodes(decrypted)); // Hello, world!
}
```

## Security Notes
- Keys are stored securely in the Android Keystore and never leave the device.
- Sensitive data is never logged or exposed in error messages.
- Always validate and sanitize user input.

## Documentation
- See `AGENTS.md` for development and security guidelines.
- See example app for more usage patterns.

## Contributing
Contributions are welcome! Please read `AGENTS.md` for guidelines before submitting a pull request.

## License
See [LICENSE](LICENSE).
