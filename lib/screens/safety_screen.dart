import 'package:flutter/material.dart';
import 'safety_list_screen.dart';

class SafetyScreen extends StatefulWidget {
  const SafetyScreen({super.key});

  @override
  State<SafetyScreen> createState() => _SafetyScreenState();
}

class _SafetyScreenState extends State<SafetyScreen> {
  final TextEditingController datumController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController situationController = TextEditingController();
  final TextEditingController massnahmeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    datumController.text = _today();
  }

  @override
  void dispose() {
    datumController.dispose();
    nameController.dispose();
    situationController.dispose();
    massnahmeController.dispose();
    super.dispose();
  }

  String _today() {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(now.day)}.${two(now.month)}.${now.year}';
  }

  void _saveSafety() {
    if (datumController.text.trim().isEmpty ||
        nameController.text.trim().isEmpty ||
        situationController.text.trim().isEmpty ||
        massnahmeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte alle Felder ausfüllen.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    SafetyRepository.addSafety(
      SafetyItem(
        datum: datumController.text.trim(),
        name: nameController.text.trim(),
        situation: situationController.text.trim(),
        massnahme: massnahmeController.text.trim(),
      ),
    );

    setState(() {
      nameController.clear();
      situationController.clear();
      massnahmeController.clear();
      datumController.text = _today();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Safety-Meldung gespeichert.'),
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
        title: const Text('Safety erfassen'),
        centerTitle: true,
        backgroundColor: const Color(0xFF061826),
        actions: [
          IconButton(
            tooltip: 'Erfasste Safety-Meldungen',
            icon: const Icon(Icons.list_alt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SafetyListScreen(),
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
                          'Neue unsichere Situation',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _field('Datum', datumController),
                      const SizedBox(height: 10),
                      _field('Name', nameController),
                      const SizedBox(height: 10),
                      _field(
                        'Unsichere Situation',
                        situationController,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 10),
                      _field(
                        'Massnahme',
                        massnahmeController,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveSafety,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00C853),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Safety speichern'),
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
                                builder: (_) => const SafetyListScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.view_list),
                          label: const Text('Erfasste Safety-Meldungen'),
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
