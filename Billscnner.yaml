import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../models/pantry_item.dart';
import '../inventory/add_item.dart';

class BillScanner extends StatefulWidget {
  const BillScanner({super.key});

  @override
  State<BillScanner> createState() => _BillScannerState();
}

class _BillScannerState extends State<BillScanner> {
  String _scannedText = "";
  List<String> _extractedItems = [];
  bool _isProcessing = false;

  Future<void> _scanBill() async {
    final img = await ImagePicker().pickImage(source: ImageSource.camera);
    if (img == null) return;

    setState(() => _isProcessing = true);

    try {
      final input = InputImage.fromFilePath(img.path);
      final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final result = await recognizer.processImage(input);

      setState(() {
        _scannedText = result.text;
        _extractedItems = _parseItems(_scannedText);
      });

      recognizer.close();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    setState(() => _isProcessing = false);
  }

  List<String> _parseItems(String text) {
    List<String> items = [];
    List<String> lines = text.split('\n');

    for (String line in lines) {
      line = line.trim();
      if (line.isNotEmpty && line.length > 2) {
        // Remove common bill markers
        if (!line.contains('Rs') &&
            !line.contains('Total') &&
            !line.contains('Date') &&
            !line.contains('Bill') &&
            !line.contains('₹')) {
          items.add(line);
        }
      }
    }

    return items;
  }

  Future<void> _pickFromGallery() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img == null) return;

    setState(() => _isProcessing = true);

    try {
      final input = InputImage.fromFilePath(img.path);
      final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final result = await recognizer.processImage(input);

      setState(() {
        _scannedText = result.text;
        _extractedItems = _parseItems(_scannedText);
      });

      recognizer.close();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bill Scanner")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _isProcessing ? null : _scanBill,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Scan Bill (Camera)"),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _isProcessing ? null : _pickFromGallery,
              icon: const Icon(Icons.photo_library),
              label: const Text("Pick from Gallery"),
            ),
            const SizedBox(height: 20),
            if (_isProcessing) const Center(child: CircularProgressIndicator()),
            if (_extractedItems.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Detected Items:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _extractedItems.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(_extractedItems[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_circle),
                            onPressed: () => _addItemToInventory(
                                _extractedItems[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            if (_scannedText.isNotEmpty && _extractedItems.isEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Raw Scanned Text:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(_scannedText),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _addItemToInventory(String itemName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddItem(suggestedName: itemName),
      ),
    );
  }
}
