import 'package:flutter/material.dart';
import '../models/word.dart';

// Widget hiển thị 1 từ vựng trong danh sách
class VocabCard extends StatelessWidget {
  final Word word;
  final VoidCallback onTap;

  const VocabCard({super.key, required this.word, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.book, color: Colors.blue),
        title: Text(word.word),
        subtitle: Text(word.meaning, maxLines: 1, overflow: TextOverflow.ellipsis),
        onTap: onTap,
      ),
    );
  }
}
