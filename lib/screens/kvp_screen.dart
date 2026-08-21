import 'package:flutter/material.dart';
import 'kvp_list_screen.dart';

class KvpScreen extends StatefulWidget {
  const KvpScreen({super.key});

  @override
  State<KvpScreen> createState() => _KvpScreenState();
}

class _KvpScreenState extends State<KvpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController datumController = TextEditingController();
  final TextEditingController verbesserungController = TextEditingController();
  final TextEditingController wasController = TextEditingController();
  final TextEditingController werController = TextEditingController();
  final TextEditingController bisWannController = TextEditingController();
  final TextEditingController loesungController = TextEditingController();

  @override
  void initState() {
    super.initState();
    datumController.text = _today();
  }

  @override
  void dispose() {
    nameController.dispose();
    datumController.dispose();
    verbesserungController.dispose();
    wasController.dispose();
    werController.dispose();
    bisWannController.dispose();
    loesungController.dispose();
    super.dispose();
  }

  String _today() {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(now.day)}.${two(now.month)}.${now.year}';
  }

  void _saveKvp() {
    if (nameController.text.trim().isEmpty ||
        datumController.text.trim().isEmpty ||
        verbesserungController.text.trim().isEmpty ||
        wasController.text.trim().isEmpty ||
        werController.text.trim().isEmpty ||
        bisWannController.text.trim().isEmpty ||
        loesungController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte alle Felder ausfüllen.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    KvpRepository.addKvp(
      KvpItem(
        name: nameController.text.trim(),
        datum: datumController.text.trim(),
        verbesserung: verbesserungController.text.trim(),
        wasMussGetanWerden: wasController.text.trim(),
        wer: werController.text.trim(),
        bisWann: bisWannController.text.trim(),
        loesungsvorschlag: loesungController.text.trim(),
      ),
    );

    setState(() {
      nameController.clear();
      datumController.text = _today();
      verbesserungController.clear();
      wasController.clear();
      werController.clear();
      bisWannController.clear();
      loesungController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('KVP gespeichert.'),
        backgroundColor: Color(0xFF00C853),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KVP erfassen'),
        centerTitle: true,
        backgroundColor: const Color(0xFF061826),
        actions: [
          IconButton(
            tooltip: 'Erfasste KVPs',
            icon: const Icon(Icons.list_alt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const KvpListScreen(),
                ),
              );
            },
          ),
        ],
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Neue KVP-Karte',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _field('Name', nameController),
                      const SizedBox(height: 10),
                      _field('Datum', datumController),
                      const SizedBox(height: 10),
                      _field(
                        'Verbesserungspotenzial',
                        verbesserungController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 10),
                      _field(
                        'Was muss getan werden',
                        wasController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 10),
                      _field('Wer', werController),
                      const SizedBox(height: 10),
                      _field('Bis wann', bisWannController),
                      const SizedBox(height: 10),
                      _field(
                        'Lösungsvorschlag',
                        loesungController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveKvp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00C853),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('KVP speichern'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const KvpListScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.view_list),
                          label: const Text('Erfasste KVPs'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
