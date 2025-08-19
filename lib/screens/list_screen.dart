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
    _wordsFuture = JsonLoader.loadWords(); // Load dữ liệu từ JSON
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📖 Danh sách từ vựng')),
      body: FutureBuilder<List<Word>>(
        future: _wordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Hiển thị loading
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi tải dữ liệu: ${snapshot.error}')); // Xử lý lỗi
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có từ vựng nào.'));
          }

          final words = snapshot.data!;
          return ListView.builder(
            itemCount: words.length,
            itemBuilder: (context, index) {
              final word = words[index];
              return VocabCard(
                word: word,
                onTap: () {
                  // Điều hướng sang màn hình chi tiết
                  Navigator.pushNamed(context, '/detail', arguments: word);
                },
              );
            },
          );
        },
      ),
    );
  }
}
