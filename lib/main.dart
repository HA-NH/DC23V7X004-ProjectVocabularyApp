import 'package:flutter/material.dart';
import 'screens/list_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';

void main() {
  runApp(const VocabularyApp());
}

class VocabularyApp extends StatelessWidget {
  const VocabularyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vocabulary Learning App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const ListScreen(),
        '/detail': (context) => const DetailScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/result': (context) =>
            const ResultScreen(score: 0, total: 0), // placeholder
      },
    );
  }
}
