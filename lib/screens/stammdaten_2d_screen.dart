import 'package:flutter/material.dart';

import '../services/app_history.dart';

class Stammdaten2DScreen extends StatefulWidget {
  const Stammdaten2DScreen({super.key});

  @override
  State<Stammdaten2DScreen> createState() => _Stammdaten2DScreenState();
}

class _Stammdaten2DScreenState extends State<Stammdaten2DScreen> {
  final TextEditingController artikelController = TextEditingController();
  final TextEditingController vonController = TextEditingController();
  final TextEditingController nachController = TextEditingController();
  final TextEditingController mitarbeiterController = TextEditingController();

  final List<TicketItem> openTickets = [];
  final List<TicketItem> doneTickets = [];

  int ticketCounter = 1;
  String searchQuery = '';
  bool showDoneTickets = false;

  @override
  void dispose() {
    artikelController.dispose();
    vonController.dispose();
    nachController.dispose();
    mitarbeiterController.dispose();
    super.dispose();
  }

  void _createTicket() {
    final artikel = artikelController.text.trim();
    final von = vonController.text.trim();
    final nach = nachController.text.trim();
    final mitarbeiter = mitarbeiterController.text.trim();

    if (artikel.isEmpty ||
        von.isEmpty ||
        nach.isEmpty ||
        mitarbeiter.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte alle Felder ausfüllen.')),
      );
      return;
    }

    final newTicket = TicketItem(
      ticketNumber: ticketCounter++,
      artikel: artikel,
      von: von,
      nach: nach,
      mitarbeiter: mitarbeiter,
      createdAt: DateTime.now(),
    );

    setState(() {
      openTickets.insert(0, newTicket);
    });

    AppHistory.add(
      user: 'karim.balestrero@mt.com',
      category: 'Stammdaten 2D',
      action: 'Ticket erstellt',
      description: 'Artikel: $artikel | Von: $von | Nach: $nach',
    );

    artikelController.clear();
    vonController.clear();
    nachController.clear();
    mitarbeiterController.clear();
  }

  void _markDone(int index) {
    final ticket = openTickets[index];

    setState(() {
      openTickets.removeAt(index);
      ticket.done = true;
      ticket.doneAt = DateTime.now();
      doneTickets.insert(0, ticket);
    });

    AppHistory.add(
      user: 'karim.balestrero@mt.com',
      category: 'Stammdaten 2D',
      action: 'Ticket erledigt',
      description: 'Artikel: ${ticket.artikel} | Ticket #${ticket.ticketNumber}',
    );
  }

  void _deleteOpenTicket(int index) {
    final ticket = openTickets[index];

    AppHistory.add(
      user: 'karim.balestrero@mt.com',
      category: 'Stammdaten 2D',
      action: 'Offenes Ticket gelöscht',
      description: 'Artikel: ${ticket.artikel} | Ticket #${ticket.ticketNumber}',
    );

    setState(() {
      openTickets.removeAt(index);
    });
  }

  void _deleteDoneTicket(int index) {
    final ticket = doneTickets[index];

    AppHistory.add(
      user: 'karim.balestrero@mt.com',
      category: 'Stammdaten 2D',
      action: 'Erledigtes Ticket gelöscht',
      description: 'Artikel: ${ticket.artikel} | Ticket #${ticket.ticketNumber}',
    );

    setState(() {
      doneTickets.removeAt(index);
    });
  }

  void _fillField(TextEditingController controller, String value) {
    setState(() {
      controller.text = value;
    });
  }

  String _formatDateTime(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}.${two(dt.month)}.${dt.year} ${two(dt.hour)}:${two(dt.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final List<TicketItem> visibleTickets =
        showDoneTickets ? doneTickets : openTickets;

    final filteredTickets = visibleTickets.where((ticket) {
      final q = searchQuery.toLowerCase();
      return ticket.artikel.toLowerCase().contains(q) ||
          ticket.von.toLowerCase().contains(q) ||
          ticket.nach.toLowerCase().contains(q) ||
          ticket.mitarbeiter.toLowerCase().contains(q) ||
          ticket.ticketNumber.toString().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stammdaten 2D'),
        backgroundColor: const Color(0xFF061826),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: isWide
                ? Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: _TicketForm(
                          artikelController: artikelController,
                          vonController: vonController,
                          nachController: nachController,
                          mitarbeiterController: mitarbeiterController,
                          onCreateTicket: _createTicket,
                          onScanArtikel: () {
                            _fillField(artikelController, 'QR-ARTIKEL');
                          },
                          onScanVon: () {
                            _fillField(vonController, 'QR-VON-LAGERPLATZ');
                          },
                          onScanNach: () {
                            _fillField(nachController, 'QR-NACH-LAGERPLATZ');
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 5,
                        child: _TicketList(
                          tickets: filteredTickets,
                          showDoneTickets: showDoneTickets,
                          onToggleDoneList: () {
                            setState(() {
                              showDoneTickets = !showDoneTickets;
                            });
                          },
                          onDone: _markDone,
                          onDeleteOpen: _deleteOpenTicket,
                          onDeleteDone: _deleteDoneTicket,
                          formatDateTime: _formatDateTime,
                          onSearchChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _TicketForm(
                        artikelController: artikelController,
                        vonController: vonController,
                        nachController: nachController,
                        mitarbeiterController: mitarbeiterController,
                        onCreateTicket: _createTicket,
                        onScanArtikel: () {
                          _fillField(artikelController, 'QR-ARTIKEL');
                        },
                        onScanVon: () {
                          _fillField(vonController, 'QR-VON-LAGERPLATZ');
                        },
                        onScanNach: () {
                          _fillField(nachController, 'QR-NACH-LAGERPLATZ');
                        },
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: _TicketList(
                          tickets: filteredTickets,
                          showDoneTickets: showDoneTickets,
                          onToggleDoneList: () {
                            setState(() {
                              showDoneTickets = !showDoneTickets;
                            });
                          },
                          onDone: _markDone,
                          onDeleteOpen: _deleteOpenTicket,
                          onDeleteDone: _deleteDoneTicket,
                          formatDateTime: _formatDateTime,
                          onSearchChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _TicketForm extends StatelessWidget {
  final TextEditingController artikelController;
  final TextEditingController vonController;
  final TextEditingController nachController;
  final TextEditingController mitarbeiterController;
  final VoidCallback onCreateTicket;
  final VoidCallback onScanArtikel;
  final VoidCallback onScanVon;
  final VoidCallback onScanNach;

  const _TicketForm({
    required this.artikelController,
    required this.vonController,
    required this.nachController,
    required this.mitarbeiterController,
    required this.onCreateTicket,
    required this.onScanArtikel,
    required this.onScanVon,
    required this.onScanNach,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Neues Ticket',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          _InputFieldWithScan(
            label: 'Artikel',
            controller: artikelController,
            onScan: onScanArtikel,
          ),
          const SizedBox(height: 10),
          _InputFieldWithScan(
            label: 'Von Lagerplatz',
            controller: vonController,
            onScan: onScanVon,
          ),
          const SizedBox(height: 10),
          _InputFieldWithScan(
            label: 'Nach Lagerplatz',
            controller: nachController,
            onScan: onScanNach,
          ),
          const SizedBox(height: 10),
          _InputField(
            label: 'Mitarbeiter',
            controller: mitarbeiterController,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onCreateTicket,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Ticket erstellen'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketList extends StatelessWidget {
  final List<TicketItem> tickets;
  final bool showDoneTickets;
  final VoidCallback onToggleDoneList;
  final void Function(int index) onDone;
  final void Function(int index) onDeleteOpen;
  final void Function(int index) onDeleteDone;
  final String Function(DateTime) formatDateTime;
  final ValueChanged<String> onSearchChanged;

  const _TicketList({
    required this.tickets,
    required this.showDoneTickets,
    required this.onToggleDoneList,
    required this.onDone,
    required this.onDeleteOpen,
    required this.onDeleteDone,
    required this.formatDateTime,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                showDoneTickets ? 'Erledigte Tickets' : 'Offene Tickets',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onToggleDoneList,
                child: Text(
                  showDoneTickets
                      ? 'Offene Tickets anzeigen'
                      : 'Erledigte Tickets anzeigen',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            onChanged: onSearchChanged,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Suchen...',
              hintStyle: const TextStyle(color: Color(0xFFBFD8E8)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.08),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.white70),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: tickets.isEmpty
                ? Center(
                    child: Text(
                      showDoneTickets
                          ? 'Noch keine erledigten Tickets.'
                          : 'Noch keine offenen Tickets.',
                      style: const TextStyle(color: Color(0xFFBFD8E8)),
                    ),
                  )
                : ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = tickets[index];
                      return TicketCard(
                        ticket: ticket,
                        showDoneActions: showDoneTickets,
                        onDone: ticket.done ? null : () => onDone(index),
                        onDelete: showDoneTickets
                            ? () => onDeleteDone(index)
                            : () => onDeleteOpen(index),
                        formatDateTime: formatDateTime,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _InputField({
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFBFD8E8)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _InputFieldWithScan extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onScan;

  const _InputFieldWithScan({
    required this.label,
    required this.controller,
    required this.onScan,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFBFD8E8)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          onPressed: onScan,
          icon: const Icon(Icons.qr_code_scanner, color: Colors.greenAccent),
          tooltip: 'QR scannen',
        ),
      ),
    );
  }
}

class TicketItem {
  final int ticketNumber;
  final String artikel;
  final String von;
  final String nach;
  final String mitarbeiter;
  final DateTime createdAt;
  DateTime? doneAt;
  bool done;

  TicketItem({
    required this.ticketNumber,
    required this.artikel,
    required this.von,
    required this.nach,
    required this.mitarbeiter,
    required this.createdAt,
    this.doneAt,
    this.done = false,
  });
}

class TicketCard extends StatelessWidget {
  final TicketItem ticket;
  final bool showDoneActions;
  final VoidCallback? onDone;
  final VoidCallback onDelete;
  final String Function(DateTime) formatDateTime;

  const TicketCard({
    super.key,
    required this.ticket,
    required this.showDoneActions,
    required this.onDone,
    required this.onDelete,
    required this.formatDateTime,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = ticket.done;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDone
            ? Colors.green.withOpacity(0.14)
            : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone
              ? Colors.greenAccent
              : const Color(0xFF00E676).withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C853),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Ticket #${ticket.ticketNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                isDone ? 'ERLEDIGT' : 'OFFEN',
                style: TextStyle(
                  color: isDone ? Colors.greenAccent : Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            ticket.artikel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text('Von: ${ticket.von}', style: const TextStyle(color: Colors.white)),
          Text('Nach: ${ticket.nach}', style: const TextStyle(color: Colors.white)),
          Text(
            'Mitarbeiter: ${ticket.mitarbeiter}',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Erstellt: ${formatDateTime(ticket.createdAt)}',
            style: const TextStyle(
              color: Color(0xFFBFD8E8),
              fontSize: 12,
            ),
          ),
          if (ticket.doneAt != null)
            Text(
              'Erledigt: ${formatDateTime(ticket.doneAt!)}',
              style: const TextStyle(
                color: Color(0xFFBFD8E8),
                fontSize: 12,
              ),
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (!showDoneActions && !isDone)
                ElevatedButton(
                  onPressed: onDone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Erledigt'),
                ),
              const Spacer(),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                tooltip: 'Ticket löschen',
              ),
            ],
          ),
          if (isDone)
            const Text(
              'Ticket abgeschlossen',
              style: TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
