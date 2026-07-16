import 'package:flutter/foundation.dart';
import '../models/movie.dart';

class HistoryEntry {
  final Movie movie;
  final DateTime viewedAt;

  HistoryEntry({required this.movie, required this.viewedAt});
}

class HistoryManager extends ChangeNotifier {
  HistoryManager._internal();
  static final HistoryManager instance = HistoryManager._internal();

  final List<HistoryEntry> _entries = [];

  List<HistoryEntry> get entries => List.unmodifiable(_entries.reversed);

  bool get isEmpty => _entries.isEmpty;

  void addToHistory(Movie movie) {
    _entries.add(HistoryEntry(movie: movie, viewedAt: DateTime.now()));
    notifyListeners();
  }

  void clearHistory() {
    _entries.clear();
    notifyListeners();
  }
}
