import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InventurchecklisteScreen extends StatefulWidget {
  const InventurchecklisteScreen({super.key});

  @override
  State<InventurchecklisteScreen> createState() =>
      _InventurchecklisteScreenState();
}

class _InventurchecklisteScreenState extends State<InventurchecklisteScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _artikelController = TextEditingController();
  final TextEditingController _lagerplatzController = TextEditingController();
  final TextEditingController _bestandController = TextEditingController();
  final TextEditingController _wertController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _artikelController.dispose();
    _lagerplatzController.dispose();
    _bestandController.dispose();
    _wertController.dispose();
    super.dispose();
  }

  Future<pw.Document> _buildPdf() async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final dateString = DateFormat('dd.MM.yyyy HH:mm').format(now);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Inventurcheckliste',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Container(height: 1, color: PdfColors.green),
                pw.SizedBox(height: 20),
                pw.Text('Datum: $dateString'),
                pw.SizedBox(height: 8),
                pw.Text('Mitarbeiter: ${_nameController.text.trim()}'),
                pw.SizedBox(height: 8),
                pw.Text('Artikelnummer: ${_artikelController.text.trim()}'),
                pw.SizedBox(height: 8),
                pw.Text('Lagerplatz: ${_lagerplatzController.text.trim()}'),
                pw.SizedBox(height: 8),
                pw.Text('Gezählter Bestand: ${_bestandController.text.trim()}'),
                pw.SizedBox(height: 8),
                pw.Text('Wert in CHF: ${_wertController.text.trim()}'),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Prüfung abgeschlossen.',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf;
  }

  Future<void> _sendToBackend() async {
    if (_nameController.text.trim().isEmpty ||
        _artikelController.text.trim().isEmpty ||
        _lagerplatzController.text.trim().isEmpty ||
        _bestandController.text.trim().isEmpty ||
        _wertController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte alle Felder ausfüllen.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final pdf = await _buildPdf();
      final Uint8List pdfBytes = await pdf.save();

      final dateFile = DateFormat('yyyy-MM-dd_HH-mm').format(DateTime.now());
      final fileName = '${_artikelController.text.trim()}_$dateFile.pdf';

      final uri = Uri.parse('http://172.24.208.71:8000/prepare-inventurmail');



      final request = http.MultipartRequest('POST', uri);

      request.fields['name'] = _nameController.text.trim();
      request.fields['artikelnummer'] = _artikelController.text.trim();
      request.fields['lagerplatz'] = _lagerplatzController.text.trim();
      request.fields['bestand'] = _bestandController.text.trim();
      request.fields['wert'] = _wertController.text.trim();

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          pdfBytes,
          filename: fileName,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('E-Mail wurde erfolgreich gesendet.'),
            backgroundColor: Color(0xFF00C853),
          ),
        );

        _nameController.clear();
        _artikelController.clear();
        _lagerplatzController.clear();
        _bestandController.clear();
        _wertController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: ${response.body}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Senden: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
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
        title: const Text('Inventurcheckliste'),
        centerTitle: true,
        backgroundColor: const Color(0xFF061826),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF061826),
              Color(0xFF0B2D4A),
              Color(0xFF0D3B2E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFF00E676).withOpacity(0.18),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Checkliste erfassen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'PDF wird erstellt und per Python-Backend an Outlook gesendet.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildField('Name des Mitarbeiters', _nameController),
              const SizedBox(height: 12),
              _buildField('Artikelnummer', _artikelController),
              const SizedBox(height: 12),
              _buildField('Lagerplatz', _lagerplatzController),
              const SizedBox(height: 12),
              _buildField('Gezählter Bestand', _bestandController),
              const SizedBox(height: 12),
              _buildField('Wert in CHF', _wertController),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _sendToBackend,
                  icon: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(_loading ? 'Sende...' : 'Senden'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
