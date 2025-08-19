import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word.dart';
import '../services/json_loader.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Future<List<Word>> _wordsFuture;
  List<Word> _allWords = [];
  List<Word> _filteredWords = [];
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = [];

  String _selectedType = 'Tất cả';
  String _selectedStatus = 'Tất cả';

  final List<String> _types = ['Tất cả', 'noun', 'verb', 'adjective'];
  final List<String> _statusFilters = ['Tất cả', 'Yêu thích', 'Đã học'];

  @override
  void initState() {
    super.initState();
    _wordsFuture = _loadWordsWithStatus();
    _searchController.addListener(_onSearchChanged);
  }

  Future<List<Word>> _loadWordsWithStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final words = await JsonLoader.loadWords();

    for (var word in words) {
      word.isFavorite = prefs.getBool('${word.word}_favorite') ?? false;
      word.isLearned = prefs.getBool('${word.word}_learned') ?? false;
    }

    _allWords = words;
    _filteredWords = words;
    return words;
  }

  Future<void> _saveWordStatus(Word word) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${word.word}_favorite', word.isFavorite);
    await prefs.setBool('${word.word}_learned', word.isLearned);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    if (query.isNotEmpty && !_recentSearches.contains(query)) {
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 5) _recentSearches.removeLast();
    }

    setState(() {
      _filteredWords = _allWords.where((word) {
        final matchesQuery =
            word.word.toLowerCase().contains(query) ||
            word.meaning.toLowerCase().contains(query);
        final matchesType =
            _selectedType == 'Tất cả' || word.type == _selectedType;
        final matchesStatus =
            _selectedStatus == 'Tất cả' ||
            (_selectedStatus == 'Yêu thích' && word.isFavorite) ||
            (_selectedStatus == 'Đã học' && word.isLearned);
        return matchesQuery && matchesType && matchesStatus;
      }).toList();
    });
  }

  void _onTypeChanged(String? newType) {
    if (newType == null) return;
    setState(() {
      _selectedType = newType;
      _onSearchChanged();
    });
  }

  void _onStatusChanged(String? newStatus) {
    if (newStatus == null) return;
    setState(() {
      _selectedStatus = newStatus;
      _onSearchChanged();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildHighlightedText(String text, String query) {
    if (query.isEmpty) return Text(text);

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final startIndex = lowerText.indexOf(lowerQuery);

    if (startIndex == -1) return Text(text);

    final endIndex = startIndex + query.length;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text.substring(0, startIndex),
            style: const TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: text.substring(endIndex),
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text;

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

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: '🔍 Tìm từ hoặc nghĩa...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Loại từ:'),
                        const SizedBox(width: 12),
                        DropdownButton<String>(
                          value: _selectedType,
                          items: _types.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: _onTypeChanged,
                        ),
                        const SizedBox(width: 24),
                        const Text('Trạng thái:'),
                        const SizedBox(width: 12),
                        DropdownButton<String>(
                          value: _selectedStatus,
                          items: _statusFilters.map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                          onChanged: _onStatusChanged,
                        ),
                      ],
                    ),
                    if (_recentSearches.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 8,
                          children: _recentSearches.map((term) {
                            return ActionChip(
                              label: Text(term),
                              onPressed: () {
                                _searchController.text = term;
                                _searchController.selection =
                                    TextSelection.fromPosition(
                                      TextPosition(offset: term.length),
                                    );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: _filteredWords.isEmpty
                    ? const Center(child: Text('Không tìm thấy từ nào.'))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: _filteredWords.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 4),
                        itemBuilder: (context, index) {
                          final word = _filteredWords[index];
                          return Card(
                            child: ListTile(
                              leading: const Icon(
                                Icons.book,
                                color: Colors.blue,
                              ),
                              title: _buildHighlightedText(word.word, query),
                              subtitle: _buildHighlightedText(
                                word.meaning,
                                query,
                              ),
                              trailing: Wrap(
                                spacing: 8,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      word.isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: word.isFavorite
                                          ? Colors.red
                                          : null,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        word.isFavorite = !word.isFavorite;
                                      });
                                      _saveWordStatus(word);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      word.isLearned
                                          ? Icons.check_circle
                                          : Icons.check_circle_outline,
                                      color: word.isLearned
                                          ? Colors.green
                                          : null,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        word.isLearned = !word.isLearned;
                                      });
                                      _saveWordStatus(word);
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/detail',
                                  arguments: word,
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
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
