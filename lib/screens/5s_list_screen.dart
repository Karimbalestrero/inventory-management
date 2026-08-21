import 'dart:io';
import 'package:flutter/material.dart';

class FiveSListScreen extends StatefulWidget {
  const FiveSListScreen({super.key});

  @override
  State<FiveSListScreen> createState() => _FiveSListScreenState();
}

class _FiveSListScreenState extends State<FiveSListScreen> {
  @override
  Widget build(BuildContext context) {
    final items = FiveSRepository.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Erfasste 5S-Einträge'),
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
                    'Noch keine 5S-Einträge erfasst.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _FiveSCard(
                      item: item,
                      onDelete: () {
                        setState(() {
                          FiveSRepository.items.removeAt(index);
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

class _FiveSCard extends StatelessWidget {
  final FiveSItem item;
  final VoidCallback onDelete;

  const _FiveSCard({
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    Widget photoWidget(String title, String? path) {
      return Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.10)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  color: Colors.black.withOpacity(0.20),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: path == null
                      ? const Center(
                          child: Icon(Icons.image_not_supported_outlined,
                              color: Colors.white54),
                        )
                      : Image.file(
                          File(path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
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
                child: const Text(
                  '5S',
                  style: TextStyle(
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
            item.kategorie,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              photoWidget('Vorher', item.vorherFotoPath),
              photoWidget('Nachher', item.nachherFotoPath),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              tooltip: 'Löschen',
            ),
          ),
        ],
      ),
    );
  }
}

class FiveSItem {
  final String datum;
  final String kategorie;
  final String? vorherFotoPath;
  final String? nachherFotoPath;

  FiveSItem({
    required this.datum,
    required this.kategorie,
    this.vorherFotoPath,
    this.nachherFotoPath,
  });
}

class FiveSRepository {
  static final List<FiveSItem> items = [];

  static void addItem(FiveSItem item) {
    items.insert(0, item);
  }
}
