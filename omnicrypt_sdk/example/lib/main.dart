import 'package:example/storage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp(storage: Storage()));
}

class MyApp extends StatelessWidget {
  final Storage storage;

  const MyApp({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniCrypt Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(storage: storage),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Storage storage;
  const MyHomePage({super.key, required this.storage});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _message = '';

  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _keyController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _encrypt() async {
    if (_keyController.text.isEmpty) {
      setState(() {
        _message = 'Please enter a key.';
      });
    } else if (_contentController.text.isEmpty) {
      setState(() {
        _message = 'Please enter content to encrypt.';
      });
    } else {
      bool success = await widget.storage.saveText(_keyController.text, _contentController.text);
      _contentController.text = '';
      _keyController.text = '';
      setState(() {
        _message = success ? 'Content encrypted and saved successfully.' : 'Failed to save content.';
      });
    }
  }

  void _decrypt() async {
    if (_keyController.text.isEmpty) {
      setState(() {
        _message = 'Please enter a key.';
      });
    } else {
      String? text = await widget.storage.retrieveText(_keyController.text);
      _contentController.text = '';
      _keyController.text = '';
      setState(() {
        _message = text ?? 'Failed to retrieve content.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OmniCrypt Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(labelText: 'Enter Key'),
                controller: _keyController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(labelText: 'Enter Content'),
                controller: _contentController,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _encrypt,
              child: const Text('Encrypt & Save'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _decrypt,
              child: const Text('Decrypt & Retrieve'),
            ),
            Text( 
              _message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
