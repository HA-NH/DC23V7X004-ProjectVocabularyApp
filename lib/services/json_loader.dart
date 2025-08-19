import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/word.dart';

// Service để load dữ liệu từ file JSON
class JsonLoader {
  static Future<List<Word>> loadWords() async {
    final data = await rootBundle.loadString('assets/words.json');
    final List<dynamic> jsonResult = json.decode(data);
    return jsonResult
        .map((e) => Word.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
