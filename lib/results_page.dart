import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  final Map<String, dynamic> predictionResult;

  const ResultsPage({
    super.key,
    required this.predictionResult,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasDiabetes = predictionResult['hasDiabetes'];
    final double confidence = predictionResult['confidence'];
    final String message = predictionResult['message'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                hasDiabetes ? Icons.warning : Icons.check_circle,
                size: 80,
                color: hasDiabetes ? Colors.orange : Colors.green,
              ),
              const SizedBox(height: 20),
              Text(
                hasDiabetes ? 'Diabetes Detected' : 'No Diabetes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: hasDiabetes ? Colors.orange : Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Confidence: ${(confidence * 100).toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}