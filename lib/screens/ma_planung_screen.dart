import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MaPlanungScreen extends StatefulWidget {
  const MaPlanungScreen({super.key});

  @override
  State<MaPlanungScreen> createState() => _MaPlanungScreenState();
}

enum CalendarViewMode { year, month, week }

class _MaPlanungScreenState extends State<MaPlanungScreen> {
  CalendarViewMode _viewMode = CalendarViewMode.year;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bemerkungController = TextEditingController();
  final TextEditingController vonController = TextEditingController();
  final TextEditingController bisController = TextEditingController();

  String selectedTyp = 'Ferien';

  final List<String> typListe = const [
    'Ferien',
    'Krankheit',
    'Schulung',
    'Sonstiges',
  ];

  final Map<DateTime, List<Abwesenheit>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  void dispose() {
    nameController.dispose();
    bemerkungController.dispose();
    vonController.dispose();
    bisController.dispose();
    super.dispose();
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _formatDate(DateTime date) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(date.day)}-${two(date.month)}-${date.year}';
  }

  DateTime? _parseDate(String input) {
    try {
      final parts = input.trim().split('-');
      if (parts.length != 3) return null;

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'Ferien':
        return Colors.greenAccent;
      case 'Krankheit':
        return Colors.redAccent;
      case 'Schulung':
        return Colors.blueAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  List<Abwesenheit> _getEventsForDay(DateTime day) {
    return _events[_normalizeDate(day)] ?? [];
  }

  void _addAbwesenheit() {
    final name = nameController.text.trim();
    final von = _parseDate(vonController.text.trim());
    final bis = _parseDate(bisController.text.trim());
    final bemerkung = bemerkungController.text.trim();

    if (name.isEmpty || von == null || bis == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte Name, Von und Bis korrekt ausfüllen.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (bis.isBefore(von)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('"Bis" darf nicht vor "Von" liegen.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final item = Abwesenheit(
      name: name,
      typ: selectedTyp,
      von: von,
      bis: bis,
      bemerkung: bemerkung,
    );

    for (
      DateTime day = _normalizeDate(von);
      !day.isAfter(_normalizeDate(bis));
      day = day.add(const Duration(days: 1))
    ) {
      final key = _normalizeDate(day);
      _events.putIfAbsent(key, () => []);
      _events[key]!.add(item);
    }

    setState(() {
      nameController.clear();
      bemerkungController.clear();
      vonController.clear();
      bisController.clear();
      selectedTyp = 'Ferien';
      _selectedDay = von;
      _focusedDay = von;
      _viewMode = CalendarViewMode.year;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abwesenheit gespeichert.'),
        backgroundColor: Color(0xFF00C853),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    String? hintText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white38),
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

  Widget _viewModeButton({
    required String label,
    required CalendarViewMode mode,
    required IconData icon,
  }) {
    final selected = _viewMode == mode;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _viewMode = mode;
            if (mode == CalendarViewMode.month) {
              _calendarFormat = CalendarFormat.month;
            } else if (mode == CalendarViewMode.week) {
              _calendarFormat = CalendarFormat.week;
            }
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF00C853)
                : Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? const Color(0xFF00E676)
                  : Colors.white.withOpacity(0.12),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legendItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 12, bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _miniMonthCell(DateTime day, {bool isHeader = false}) {
    final events = _getEventsForDay(day);
    final hasEvent = events.isNotEmpty;

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: hasEvent
            ? _colorForType(events.first.typ).withOpacity(0.20)
            : Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: hasEvent
              ? _colorForType(events.first.typ).withOpacity(0.55)
              : Colors.white.withOpacity(0.05),
          width: 0.8,
        ),
      ),
      child: Text(
        isHeader ? _weekdayShort(day.weekday) : '${day.day}',
        style: TextStyle(
          color: isHeader
              ? Colors.white70
              : hasEvent
                  ? Colors.white
                  : Colors.white60,
          fontSize: isHeader ? 10 : 11,
          fontWeight: isHeader ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
    );
  }

  String _weekdayShort(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'M';
      case DateTime.tuesday:
        return 'D';
      case DateTime.wednesday:
        return 'M';
      case DateTime.thursday:
        return 'D';
      case DateTime.friday:
        return 'F';
      case DateTime.saturday:
        return 'S';
      case DateTime.sunday:
        return 'S';
      default:
        return '';
    }
  }

  Widget _buildYearView() {
    final year = _focusedDay.year;

    final monthNames = const [
      'Januar',
      'Februar',
      'März',
      'April',
      'Mai',
      'Juni',
      'Juli',
      'August',
      'September',
      'Oktober',
      'November',
      'Dezember',
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime(year - 1, 1, 1);
                  });
                },
                icon: const Icon(Icons.chevron_left, color: Colors.white),
              ),
              Expanded(
                child: Text(
                  '$year',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime(year + 1, 1, 1);
                  });
                },
                icon: const Icon(Icons.chevron_right, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 12,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              final month = index + 1;
              final firstDayOfMonth = DateTime(year, month, 1);
              final daysInMonth = DateTime(year, month + 1, 0).day;
              final firstWeekday = firstDayOfMonth.weekday;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _viewMode = CalendarViewMode.month;
                    _calendarFormat = CalendarFormat.month;
                    _focusedDay = DateTime(year, month, 1);
                    _selectedDay = DateTime(year, month, 1);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF00E676).withOpacity(0.15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        monthNames[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('M', style: TextStyle(color: Colors.white54, fontSize: 9)),
                          Text('D', style: TextStyle(color: Colors.white54, fontSize: 9)),
                          Text('M', style: TextStyle(color: Colors.white54, fontSize: 9)),
                          Text('D', style: TextStyle(color: Colors.white54, fontSize: 9)),
                          Text('F', style: TextStyle(color: Colors.white54, fontSize: 9)),
                          Text('S', style: TextStyle(color: Colors.white54, fontSize: 9)),
                          Text('S', style: TextStyle(color: Colors.white54, fontSize: 9)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 42,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                          ),
                          itemBuilder: (context, cellIndex) {
                            final dayNumber = cellIndex - (firstWeekday - 1) + 1;
                            if (dayNumber < 1 || dayNumber > daysInMonth) {
                              return Container();
                            }

                            final currentDay = DateTime(year, month, dayNumber);
                            final events = _getEventsForDay(currentDay);
                            final hasEvent = events.isNotEmpty;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDay = currentDay;
                                  _focusedDay = currentDay;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: hasEvent
                                      ? _colorForType(events.first.typ).withOpacity(0.18)
                                      : Colors.white.withOpacity(0.03),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: hasEvent
                                        ? _colorForType(events.first.typ).withOpacity(0.5)
                                        : Colors.white.withOpacity(0.04),
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  '$dayNumber',
                                  style: TextStyle(
                                    color: hasEvent
                                        ? Colors.white
                                        : Colors.white60,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          const Text(
            'Die farbigen Tage zeigen Abwesenheiten an. Tippe auf einen Monat für die Detailansicht.',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthCalendar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: TableCalendar<Abwesenheit>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2035, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: CalendarFormat.month,
        availableCalendarFormats: const {
          CalendarFormat.month: 'Monat',
        },
        startingDayOfWeek: StartingDayOfWeek.monday,
        eventLoader: _getEventsForDay,
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: Color(0xFF00C853),
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: Colors.orangeAccent,
            shape: BoxShape.circle,
          ),
          defaultTextStyle: const TextStyle(color: Colors.white),
          weekendTextStyle: const TextStyle(color: Colors.white70),
          outsideTextStyle: const TextStyle(color: Colors.white24),
        ),
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
        ),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }

  Widget _buildWeekView() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: TableCalendar<Abwesenheit>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2035, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: CalendarFormat.week,
        availableCalendarFormats: const {
          CalendarFormat.week: 'Woche',
        },
        startingDayOfWeek: StartingDayOfWeek.monday,
        eventLoader: _getEventsForDay,
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: Color(0xFF00C853),
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: Colors.orangeAccent,
            shape: BoxShape.circle,
          ),
          defaultTextStyle: const TextStyle(color: Colors.white),
          weekendTextStyle: const TextStyle(color: Colors.white70),
          outsideTextStyle: const TextStyle(color: Colors.white24),
        ),
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
        ),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedEvents = _getEventsForDay(_selectedDay ?? DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('MA-Planung'),
        centerTitle: true,
        backgroundColor: const Color(0xFF061826),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: const Color(0xFF0A2740),
                  title: const Text(
                    'Legende',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _legendRow('Ferien', Colors.greenAccent),
                      _legendRow('Krankheit', Colors.redAccent),
                      _legendRow('Schulung', Colors.blueAccent),
                      _legendRow('Sonstiges', Colors.orangeAccent),
                    ],
                  ),
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
                Row(
                  children: [
                    _viewModeButton(
                      label: 'Jahr',
                      mode: CalendarViewMode.year,
                      icon: Icons.calendar_view_month,
                    ),
                    const SizedBox(width: 8),
                    _viewModeButton(
                      label: 'Monat',
                      mode: CalendarViewMode.month,
                      icon: Icons.calendar_month,
                    ),
                    const SizedBox(width: 8),
                    _viewModeButton(
                      label: 'Woche',
                      mode: CalendarViewMode.week,
                      icon: Icons.view_week,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (_viewMode == CalendarViewMode.year)
                  _buildYearView()
                else if (_viewMode == CalendarViewMode.month)
                  _buildMonthCalendar()
                else
                  _buildWeekView(),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Abwesenheit erfassen',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildInputField('Mitarbeitername', nameController),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedTyp,
                        items: typListe
                            .map(
                              (typ) => DropdownMenuItem(
                                value: typ,
                                child: Text(typ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedTyp = value ?? 'Ferien';
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Abwesenheitstyp',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.08),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        dropdownColor: const Color(0xFF0A2740),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      _buildInputField(
                        'Von (DD-MM-YYYY)',
                        vonController,
                        hintText: '20-08-2026',
                      ),
                      const SizedBox(height: 10),
                      _buildInputField(
                        'Bis (DD-MM-YYYY)',
                        bisController,
                        hintText: '24-08-2026',
                      ),
                      const SizedBox(height: 10),
                      _buildInputField(
                        'Bemerkung',
                        bemerkungController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _addAbwesenheit,
                          icon: const Icon(Icons.save),
                          label: const Text('Abwesenheit speichern'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00C853),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Einträge für ${_formatDate(_selectedDay ?? DateTime.now())}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (selectedEvents.isEmpty)
                        const Text(
                          'Keine Abwesenheiten für diesen Tag.',
                          style: TextStyle(color: Colors.white70),
                        )
                      else
                        ...selectedEvents.map((item) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _colorForType(item.typ).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _colorForType(item.typ).withOpacity(0.5),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _colorForType(item.typ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        item.typ,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Mitarbeiter: ${item.name}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                if (item.bemerkung.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Bemerkung: ${item.bemerkung}',
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                ],
                                const SizedBox(height: 4),
                                Text(
                                  'Zeitraum: ${_formatDate(item.von)} bis ${_formatDate(item.bis)}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          );
                        }),
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

  Widget _legendRow(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class Abwesenheit {
  final String name;
  final String typ;
  final DateTime von;
  final DateTime bis;
  final String bemerkung;

  Abwesenheit({
    required this.name,
    required this.typ,
    required this.von,
    required this.bis,
    required this.bemerkung,
  });
}
