import 'package:flutter/material.dart';
import '../models/word.dart';
import '../services/json_loader.dart';
import '../widgets/vocab_card.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Future<List<Word>> _wordsFuture;

  @override
  void initState() {
    super.initState();
    _wordsFuture = JsonLoader.loadWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📖 Danh sách từ vựng')),
      body: FutureBuilder<List<Word>>(
        future: _wordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi tải dữ liệu: ${snapshot.error}'));
          }

          final words = snapshot.data;

          if (words == null || words.isEmpty) {
            return const Center(child: Text('Không có từ vựng nào.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            itemCount: words.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final word = words[index];
              return VocabCard(
                word: word,
                onTap: () {
                  Navigator.pushNamed(context, '/detail', arguments: word);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FutureBuilder<List<Word>>(
        future: _wordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data!.isNotEmpty) {
            return FloatingActionButton.extended(
              onPressed: () => Navigator.pushNamed(context, '/quiz'),
              icon: const Icon(Icons.quiz),
              label: const Text('Làm Quiz'),
            );
          }
          return const SizedBox.shrink(); // Ẩn nút khi chưa sẵn sàng
        },
      ),
    );
  }
}
