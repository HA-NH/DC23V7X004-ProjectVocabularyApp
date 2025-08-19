import 'package:flutter/material.dart';
import '../models/word.dart';
import '../services/json_loader.dart';
import 'result_screen.dart';
import 'dart:math';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Word> _words;
  int _currentIndex = 0;
  int _score = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    final words = await JsonLoader.loadWords();
    words.shuffle(); // xáo trộn danh sách từ
    setState(() {
      _words = words.take(10).toList(); // lấy 10 từ đầu tiên
      _isLoading = false;
    });
  }

  void _answerQuestion(String selectedMeaning) {
    final correct = _words[_currentIndex].meaning;
    if (selectedMeaning == correct) {
      _score++;
    }

    if (_currentIndex < _words.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(score: _score, total: _words.length),
        ),
      );
    }
  }

  List<String> _generateOptions(Word currentWord) {
    final options = <String>[currentWord.meaning];
    final random = Random();

    while (options.length < 4) {
      final candidate = _words[random.nextInt(_words.length)].meaning;
      if (!options.contains(candidate)) {
        options.add(candidate);
      }
    }

    options.shuffle();
    return options;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentWord = _words[_currentIndex];
    final options = _generateOptions(currentWord);

    return Scaffold(
      appBar: AppBar(title: const Text('🧠 Quiz từ vựng')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Câu ${_currentIndex + 1}/${_words.length}',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Text('Từ: ${currentWord.word}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ...options.map((option) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () => _answerQuestion(option),
                child: Text(option),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
