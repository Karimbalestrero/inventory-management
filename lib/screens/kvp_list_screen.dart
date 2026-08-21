import 'package:flutter/material.dart';

class KvpListScreen extends StatefulWidget {
  const KvpListScreen({super.key});

  @override
  State<KvpListScreen> createState() => _KvpListScreenState();
}

class _KvpListScreenState extends State<KvpListScreen> {
  @override
  Widget build(BuildContext context) {
    final kvps = KvpRepository.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Erfasste KVPs'),
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
          child: kvps.isEmpty
              ? const Center(
                  child: Text(
                    'Noch keine KVPs erfasst.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: kvps.length,
                  itemBuilder: (context, index) {
                    final item = kvps[index];
                    return _KvpCard(
                      item: item,
                      onToggleDone: () {
                        setState(() {
                          item.erledigt = !item.erledigt;
                        });
                      },
                      onDelete: () {
                        setState(() {
                          KvpRepository.items.removeAt(index);
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

class _KvpCard extends StatelessWidget {
  final KvpItem item;
  final VoidCallback onToggleDone;
  final VoidCallback onDelete;

  const _KvpCard({
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
              : const Color(0xFF00E676).withOpacity(0.25),
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
                  color: const Color(0xFF00C853),
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
          Text(
            'Verbesserungspotenzial:\n${item.verbesserung}',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Was muss getan werden:\n${item.wasMussGetanWerden}',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Wer: ${item.wer}',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Bis wann: ${item.bisWann}',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Lösungsvorschlag:\n${item.loesungsvorschlag}',
            style: const TextStyle(color: Colors.white),
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

class KvpItem {
  final String name;
  final String datum;
  final String verbesserung;
  final String wasMussGetanWerden;
  final String wer;
  final String bisWann;
  final String loesungsvorschlag;
  bool erledigt;

  KvpItem({
    required this.name,
    required this.datum,
    required this.verbesserung,
    required this.wasMussGetanWerden,
    required this.wer,
    required this.bisWann,
    required this.loesungsvorschlag,
    this.erledigt = false,
  });
}

class KvpRepository {
  static final List<KvpItem> items = [];

  static void addKvp(KvpItem item) {
    items.insert(0, item);
  }
}
