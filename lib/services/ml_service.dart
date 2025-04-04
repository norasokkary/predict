
import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class MLService {
  late Interpreter _interpreter;
  bool _isModelLoaded = false;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('model.tflite');
      _isModelLoaded = true;
    } catch (e) {
      throw Exception('Failed to load model: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> analyzeImage(File imageFile) async {
    if (!_isModelLoaded) {
      await loadModel();
    }

    try {
      final image = img.decodeImage(imageFile.readAsBytesSync());
      if (image == null) throw Exception('Failed to decode image');

      final resizedImage = img.copyResize(image, width: 224, height: 224);

      // التصحيح هنا: استخدام getPixel() بشكل صحيح
      final input = List.generate(224, (j) =>
          List.generate(224, (k) {
            final pixel = resizedImage.getPixel(j, k);
            return [img.getRed(pixel) / 255.0]; // استخدام img.getRed بدلاً من .r
          }));

          final output = List.filled(1 * 2, 0).reshape([1, 2]);

      _interpreter.run(input, output);

      final confidence = output[0][1].toDouble();
      final hasDiabetes = confidence > 0.5;

      return {
        'hasDiabetes': hasDiabetes,
        'confidence': confidence,
        'message': hasDiabetes
            ? 'Diabetes detected (${(confidence * 100).toStringAsFixed(1)}% confidence)'
            : 'No diabetes detected (${(confidence * 100).toStringAsFixed(1)}% confidence)',
      };
    } catch (e) {
      throw Exception('Image analysis failed: ${e.toString()}');
    }
  }
}