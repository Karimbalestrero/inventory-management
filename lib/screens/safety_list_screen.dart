import 'package:flutter/material.dart';

class SafetyListScreen extends StatefulWidget {
  const SafetyListScreen({super.key});

  @override
  State<SafetyListScreen> createState() => _SafetyListScreenState();
}

class _SafetyListScreenState extends State<SafetyListScreen> {
  @override
  Widget build(BuildContext context) {
    final items = SafetyRepository.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Erfasste Safety-Meldungen'),
        centerTitle: true,
        backgroundColor: const Color(0xFF061826),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF061826),
              Color(0xFF0A2740),
              Color(0xFF0D3B2E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: items.isEmpty
              ? const Center(
                  child: Text(
                    'Noch keine Safety-Meldungen erfasst.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _SafetyCard(
                      item: item,
                      onToggleDone: () {
                        setState(() {
                          item.erledigt = !item.erledigt;
                        });
                      },
                      onDelete: () {
                        setState(() {
                          SafetyRepository.items.removeAt(index);
                        });
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _SafetyCard extends StatelessWidget {
  final SafetyItem item;
  final VoidCallback onToggleDone;
  final VoidCallback onDelete;

  const _SafetyCard({
    required this.item,
    required this.onToggleDone,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.erledigt
            ? Colors.green.withOpacity(0.14)
            : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: item.erledigt
              ? Colors.greenAccent
              : Colors.redAccent.withOpacity(0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: item.erledigt
                      ? const Color(0xFF00C853)
                      : Colors.redAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.erledigt ? 'ERLEDIGT' : 'OFFEN',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                item.datum,
                style: const TextStyle(
                  color: Color(0xFFBFD8E8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Unsichere Situation:\n${item.situation}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Massnahme:\n${item.massnahme}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: onToggleDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: item.erledigt
                      ? Colors.orangeAccent
                      : const Color(0xFF00C853),
                  foregroundColor: Colors.white,
                ),
                child: Text(item.erledigt ? 'Rückgängig' : 'Erledigt'),
              ),
              const Spacer(),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                tooltip: 'Löschen',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SafetyItem {
  final String datum;
  final String name;
  final String situation;
  final String massnahme;
  bool erledigt;

  SafetyItem({
    required this.datum,
    required this.name,
    required this.situation,
    required this.massnahme,
    this.erledigt = false,
  });
}

class SafetyRepository {
  static final List<SafetyItem> items = [];

  static void addSafety(SafetyItem item) {
    items.insert(0, item);
  }
}
