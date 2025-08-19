// Model đại diện cho 1 từ vựng
class Word {
  final String word;
  final String type;
  final String meaning;
  final String example;

  bool isFavorite;
  bool isLearned;

  Word({
    required this.word,
    required this.type,
    required this.meaning,
    required this.example,
    this.isFavorite = false,
    this.isLearned = false,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'],
      type: json['type'],
      meaning: json['meaning'],
      example: json['example'],
      isFavorite: json['isFavorite'] ?? false,
      isLearned: json['isLearned'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'word': word,
        'type': type,
        'meaning': meaning,
        'example': example,
        'isFavorite': isFavorite,
        'isLearned': isLearned,
      };
}
