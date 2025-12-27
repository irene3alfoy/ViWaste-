import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../providers/auth_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../models/pantry_item_model.dart';
import '../inventory/add_item_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  String? _scannedText;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                'Add Items to Pantry',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 32),
              _buildScannerOptions(),
              const SizedBox(height: 32),
              if (_selectedImage != null) _buildImagePreview(),
              if (_scannedText != null) _buildScannedItemsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScannerOptions() {
    return Column(
      children: [
        _buildOptionCard(
          icon: Icons.camera_alt,
          title: 'Scan Bill (OCR)',
          subtitle: 'Capture bill photo to extract items',
          onTap: () => _scanBillWithOCR(),
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          icon: Icons.add_circle,
          title: 'Manual Entry',
          subtitle: 'Add items manually',
          onTap: () => _navigateToAddItem(),
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          icon: Icons.photo_library,
          title: 'Choose from Gallery',
          subtitle: 'Select image from gallery',
          onTap: () => _pickImageFromGallery(),
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.green[700]),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _scanBillWithOCR() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _isProcessing = true;
      });

      try {
        final inputImage = InputImage.fromFile(_selectedImage!);
        final textRecognizer = GoogleMlKit.vision.textRecognizer();
        final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

        setState(() {
          _scannedText = recognizedText.text;
          _isProcessing = false;
        });

        textRecognizer.close();
        _showExtractedItemsDialog();
      } catch (e) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _isProcessing = true;
      });

      try {
        final inputImage = InputImage.fromFile(_selectedImage!);
        final textRecognizer = GoogleMlKit.vision.textRecognizer();
        final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

        setState(() {
          _scannedText = recognizedText.text;
          _isProcessing = false;
        });

        textRecognizer.close();
        _showExtractedItemsDialog();
      } catch (e) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showExtractedItemsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Extracted Items'),
        content: SingleChildScrollView(
          child: Text(_scannedText ?? 'No text extracted'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _parseAndAddItems();
            },
            child: const Text('Add Items'),
          ),
        ],
      ),
    );
  }

  void _parseAndAddItems() {
    List<String> lines = (_scannedText ?? '').split('\n');
    for (String line in lines) {
      if (line.trim().isNotEmpty && line.length > 2) {
        _navigateToAddItem(suggestedName: line.trim());
      }
    }
  }

  void _navigateToAddItem({String? suggestedName}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddItemScreen(suggestedName: suggestedName),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            _selectedImage!,
            height: 300,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16),
        if (_isProcessing)
          const CircularProgressIndicator()
        else if (_scannedText != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('Items detected: ${_scannedText?.split('\n').length ?? 0}'),
          ),
      ],
    );
  }

  Widget _buildScannedItemsList() {
    List<String> items = (_scannedText ?? '').split('\n');
    return Column(
      children: [
        const SizedBox(height: 24),
        const Text('Detected Items:', style: TextStyle(fontWeight: FontWeight.bold)),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            if (items[index].trim().isEmpty) return const SizedBox.shrink();
            return ListTile(
              title: Text(items[index].trim()),
              trailing: IconButton(
                icon: const Icon(Icons.add, color: Colors.green),
                onPressed: () => _navigateToAddItem(suggestedName: items[index].trim()),
              ),
            );
          },
        ),
      ],
    );
  }
}

