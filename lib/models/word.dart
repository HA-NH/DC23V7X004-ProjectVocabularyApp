// Model đại diện cho 1 từ vựng
class Word {
  final String word;
  final String type;
  final String meaning;
  final String example;

  Word({required this.word, required this.type, required this.meaning, required this.example});

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'],
      type: json['type'],
      meaning: json['meaning'],
      example: json['example'],
    );
  }

  Map<String, dynamic> toJson() => {
    'word': word,
    'type': type,
    'meaning': meaning,
    'example': example,
  };
}
