import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final List<Map<String, String>> wrongAnswers;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    this.wrongAnswers = const [],
  });

  @override
  Widget build(BuildContext context) {
    final double percent = (score / total) * 100;

    return Scaffold(
      appBar: AppBar(title: const Text('🎉 Kết quả')),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('🎯', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 24,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Bạn đã hoàn thành Quiz!',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '$score / $total câu đúng',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tỷ lệ chính xác: ${percent.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ✅ Hiển thị câu sai nếu có
              if (wrongAnswers.isNotEmpty) ...[
                const Text(
                  'Các câu bạn đã làm sai:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: wrongAnswers.length,
                  itemBuilder: (context, index) {
                    final item = wrongAnswers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🔹 Từ: ${item['word'] ?? ''}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('✅ Đáp án đúng: ${item['correct'] ?? ''}'),
                          Text('❌ Bạn chọn: ${item['selected'] ?? ''}'),
                          const Divider(),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],

              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Làm lại Quiz'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/quiz');
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text('Về trang chính'),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
