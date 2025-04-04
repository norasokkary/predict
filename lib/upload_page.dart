import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nora/services/ml_service.dart';
import 'package:nora/results_page.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final ImagePicker _imagePicker = ImagePicker();
  final MLService _mlService = MLService();
  XFile? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery, // الاكتفاء بالمعرض فقط
        imageQuality: 85,
        maxWidth: 800,
      );
      if (image != null) {
        setState(() => _selectedImage = image);
      }
    } catch (e) {
      _showError('حدث خطأ أثناء اختيار الصورة');
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) {
      _showError('الرجاء اختيار صورة أولاً');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _mlService.analyzeImage(File(_selectedImage!.path));

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(
            predictionResult: result,
          ),
        ),
      );
    } catch (e) {
      _showError('فشل في تحليل الصورة: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('فحص اعتلال الشبكية السكري'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _selectedImage == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_library, size: 60),
                    onPressed: _pickImage,
                  ),
                  const SizedBox(height: 20),
                  const Text('اختر صورة من المعرض'),
                ],
              )
                  : Image.file(File(_selectedImage!.path)),
            ),
            ElevatedButton(
              onPressed: _analyzeImage,
              child: const Text('بدء التحليل'),
            ),
          ],
        ),
      ),
    );
  }
}