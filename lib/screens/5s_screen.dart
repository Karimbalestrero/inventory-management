import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '5s_list_screen.dart';

class FiveSScreen extends StatefulWidget {
  const FiveSScreen({super.key});

  @override
  State<FiveSScreen> createState() => _FiveSScreenState();
}

class _FiveSScreenState extends State<FiveSScreen> {
  final TextEditingController datumController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String selectedKategorie = 'Sortieren';
  XFile? vorherFoto;
  XFile? nachherFoto;

  final List<String> kategorien = const [
    'Sortieren',
    'Systematisieren',
    'Säubern',
    'Standardisieren',
    'Selbstdisziplin',
  ];

  @override
  void initState() {
    super.initState();
    datumController.text = _today();
  }

  @override
  void dispose() {
    datumController.dispose();
    super.dispose();
  }

  String _today() {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(now.day)}.${two(now.month)}.${now.year}';
  }

  Future<XFile?> _takePhoto() async {
    try {
      return await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
    } catch (_) {
      return null;
    }
  }

  void _saveItem() {
    if (datumController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte ein Datum eingeben.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    FiveSRepository.addItem(
      FiveSItem(
        datum: datumController.text.trim(),
        kategorie: selectedKategorie,
        vorherFotoPath: vorherFoto?.path,
        nachherFotoPath: nachherFoto?.path,
      ),
    );

    setState(() {
      datumController.text = _today();
      selectedKategorie = 'Sortieren';
      vorherFoto = null;
      nachherFoto = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('5S-Eintrag gespeichert.'),
        backgroundColor: Color(0xFF00C853),
      ),
    );
  }

  Widget _photoBox({
    required String label,
    required XFile? file,
    required VoidCallback onTakePhoto,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTakePhoto,
        child: Container(
          height: 170,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.10)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  color: Colors.black.withOpacity(0.20),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: file == null
                      ? const Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white54,
                            size: 36,
                          ),
                        )
                      : Image.file(
                          File(file.path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('5S erfassen'),
        centerTitle: true,
        backgroundColor: const Color(0xFF061826),
        actions: [
          IconButton(
            tooltip: 'Erfasste 5S-Einträge',
            icon: const Icon(Icons.list_alt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FiveSListScreen(),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Neuer 5S-Eintrag',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),

                      TextField(
                        controller: datumController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Datum',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.08),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        value: selectedKategorie,
                        items: kategorien
                            .map(
                              (k) => DropdownMenuItem(
                                value: k,
                                child: Text(k),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedKategorie = val ?? kategorien.first;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Kategorie',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.08),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          _photoBox(
                            label: 'Vorher-Foto aufnehmen',
                            file: vorherFoto,
                            onTakePhoto: () async {
                              final photo = await _takePhoto();
                              if (photo != null) {
                                setState(() {
                                  vorherFoto = photo;
                                });
                              }
                            },
                          ),
                          _photoBox(
                            label: 'Nachher-Foto aufnehmen',
                            file: nachherFoto,
                            onTakePhoto: () async {
                              final photo = await _takePhoto();
                              if (photo != null) {
                                setState(() {
                                  nachherFoto = photo;
                                });
                              }
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _saveItem,
                          icon: const Icon(Icons.save),
                          label: const Text('5S-Eintrag speichern'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00C853),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
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
                                builder: (_) => const FiveSListScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.view_list),
                          label: const Text('Erfasste 5S-Einträge'),
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
