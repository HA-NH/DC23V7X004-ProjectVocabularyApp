import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Word word;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    word = ModalRoute.of(context)!.settings.arguments as Word;
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      word.isFavorite = prefs.getBool('${word.word}_favorite') ?? false;
      word.isLearned = prefs.getBool('${word.word}_learned') ?? false;
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      word.isFavorite = !word.isFavorite;
      prefs.setBool('${word.word}_favorite', word.isFavorite);
    });
  }

  Future<void> _toggleLearned() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      word.isLearned = !word.isLearned;
      prefs.setBool('${word.word}_learned', word.isLearned);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔍 Chi tiết từ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        word.word,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        word.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: word.isFavorite ? Colors.red : null,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                    IconButton(
                      icon: Icon(
                        word.isLearned
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: word.isLearned ? Colors.green : null,
                      ),
                      onPressed: _toggleLearned,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Loại từ: ${word.type}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Nghĩa: ${word.meaning}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 12),
                Text(
                  'Ví dụ: ${word.example}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const Spacer(),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Quay lại'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
