import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveUrlButton extends StatefulWidget {
  const SaveUrlButton({super.key});

  @override
  SaveUrlButtonState createState() => SaveUrlButtonState();
}

class SaveUrlButtonState extends State<SaveUrlButton> {
  late SharedPreferences prefs;
  late TextEditingController _urlController;
  late String _savedUrl;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        this.prefs = prefs;
        _savedUrl = prefs.getString('fileUrl') ?? '';
        _urlController = TextEditingController(text: _savedUrl);
      });
    });
  }

  void _saveUrl() {
    final newUrl = _urlController.text.trim();
    if (newUrl.isNotEmpty && newUrl != _savedUrl) {
      setState(() {
        _savedUrl = newUrl;
        prefs.setString('fileUrl', _savedUrl);
      });
    }
  }

  void _showUrlDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter File URL'),
          content: TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              hintText: 'Enter a file URL',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _saveUrl,
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: _showUrlDialog,
      tooltip: 'File URL',
    );
  }
}
