import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const ResultScreen({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎉 Kết quả')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Bạn đã trả lời đúng $score / $total câu!',
                  style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')),
                icon: const Icon(Icons.home),
                label: const Text('Về trang chính'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
