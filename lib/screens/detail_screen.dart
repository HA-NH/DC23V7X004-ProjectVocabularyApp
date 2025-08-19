import 'package:flutter/material.dart';
import '../models/word.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Word word = ModalRoute.of(context)!.settings.arguments as Word;

    return Scaffold(
      appBar: AppBar(title: const Text('🔍 Chi tiết từ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(word.word,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Loại từ: ${word.type}',
                    style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                const SizedBox(height: 12),
                Text('Nghĩa: ${word.meaning}',
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 12),
                Text('Ví dụ: ${word.example}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey)),
                const Spacer(),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Quay lại'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
