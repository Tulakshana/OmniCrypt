# AI Agent Guidelines for OmniCrypt

This document provides context and guidelines for AI coding assistants working with OmniCrypt.

## Project Overview

The SDK provides a comprehensive solution for encryption in a Flutter app.

The project is written in Dart and currently supports only Android.

## Repository Structure

```text
OmniCrypt/
├── omnicrypt_sdk/lib/              # Dart API
├── omnicrypt_sdk/android/          # Android native code
├── omnicrypt_sdk/example/          # Example app
├── omnicrypt_sdk/test/             # Test directory
```

## Development Guidelines

### Testing Requirements

- **Mocking**: Use subclasses where required. Do not use 3rd party libraries.
- **Coverage**: Ensure tests cover both success and failure scenarios.

## Build & Test Commands

```bash
# Clean Flutter
flutter clean

# Fetch dependencies
flutter pub get

# Run tests
flutter test

# List all available devices/emulators (currently running)
flutter devices

# List all emulators (including the ones that aren't running)
flutter emulators

# Launch emulator
flutter emulators --launch <emulator id>
```

## Security Considerations

- **Authentication & Authorization**: Never store user credentials or tokens in plaintext.
- **Sensitive Data Handling**: Always sanitize logs and error messages.
- **Input Validation**: Validate and sanitize all user input to prevent injection attacks.
- **Least Privilege**: Request only the minimum permissions required. Avoid requesting unnecessary device permissions.
- **Dependency Management**: Monitor for and address known vulnerabilities in third-party libraries.
- **Error Handling**: Do not leak sensitive information in error messages or stack traces.

## Documentation

- **README.md**: Getting started and installation

## AI Agent Best Practices

When assisting with this codebase:
- **Preserve patterns**:
  - Maintain existing architectural and coding patterns.
  - Use consistent error handling strategies.
  - Adhere to established naming conventions and file organization.
  - When adding or modifying code, follow the structure and style of surrounding code to ensure consistency.
- **Test coverage**: Always include tests for new functionality
- **Security**: Never compromise security
- **Error handling**: 
  - Provide clear, actionable error messages
  - try-catch blocks should always catch specific errors. If we are catching an error we should know what.
- **3rd party packages**: Always try to use Flutter's built-in capabilities

## Getting Help
- **Flutter**: https://docs.flutter.dev/
- **Dart**: https://dart.dev/docs

## Example Workflows

### Adding a New Feature
1. Implement the feature
2. Add or update unit tests in the appropriate test directory.
3. Run tests