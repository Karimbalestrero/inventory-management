class HistoryEntry {
  final DateTime timestamp;
  final String user;
  final String category;
  final String action;
  final String description;

  HistoryEntry({
    required this.timestamp,
    required this.user,
    required this.category,
    required this.action,
    required this.description,
  });
}

class AppHistory {
  static final List<HistoryEntry> _entries = [];

  static void add({
    required String user,
    required String category,
    required String action,
    required String description,
  }) {
    _entries.insert(
      0,
      HistoryEntry(
        timestamp: DateTime.now(),
        user: user,
        category: category,
        action: action,
        description: description,
      ),
    );
  }

  static List<HistoryEntry> get entries => List.unmodifiable(_entries);

  static void clear() {
    _entries.clear();
  }
}
