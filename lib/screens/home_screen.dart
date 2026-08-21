import 'package:flutter/material.dart';

import 'inventurcheckliste_screen.dart';
import 'stammdaten_2d_screen.dart';
import 'ma_planung_screen.dart';
import '5s_screen.dart';
import 'kvp_screen.dart';
import 'safety_screen.dart';
import 'inventurcheckliste_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      _CategoryItem('Stammdaten 2D', Icons.qr_code_scanner, const Color(0xFF00C853)),
      _CategoryItem('To-Do-List', Icons.check_circle_outline, const Color(0xFF00BFA5)),
      _CategoryItem('History', Icons.history, const Color(0xFF1E88E5)),
      _CategoryItem('Inventurcheckliste', Icons.fact_check, const Color(0xFF43A047)),
      _CategoryItem('5S', Icons.cleaning_services, const Color(0xFF8E24AA)),
      _CategoryItem('MA-Planung', Icons.calendar_month, const Color(0xFFFDD835)),
      _CategoryItem('KVP', Icons.lightbulb_outline, const Color(0xFFFF7043)),
      _CategoryItem('Safety', Icons.security, const Color(0xFFE53935)),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF061826),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Inventory Management',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 20,
          ),
        ),
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
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Header card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0xFF00E676).withOpacity(0.18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.30),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF00E676),
                              Color(0xFF00C853),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00E676).withOpacity(0.30),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.inventory_2_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Inventory',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Management System',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Newsfeld
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFF00BFA5).withOpacity(0.22),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.campaign_outlined, color: Color(0xFF00E676)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'News: Bitte Tickets mit QR-Code scannen und erledigte Vorgänge direkt abschließen.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GridView.builder(
                    itemCount: categories.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.82,
                    ),
                    itemBuilder: (context, index) {
                      final item = categories[index];

                      return GestureDetector(
                        onTap: () {
                          if (item.title == 'Stammdaten 2D') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Stammdaten2DScreen(),
                              ),
                            );
                          } else if (item.title == 'Inventurcheckliste') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const InventurchecklisteScreen(),
                              ),
                            );
                          } else if (item.title == '5S') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FiveSScreen(),
                              ),
                            );
                          } else if (item.title == 'MA-Planung') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MaPlanungScreen(),
                              ),
                            );
                          } else if (item.title == 'KVP') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const KvpScreen(),
                              ),
                            );
                          } else if (item.title == 'Safety') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SafetyScreen(),
                              ),
                            );
                          } else if (item.title == 'Inventurcheckliste') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const InventurchecklisteScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item.title} kommt als Nächstes.'),
                                backgroundColor: const Color(0xFF00C853),
                              ),
                            );
                          }
                        },
                        child: HoverTile(item: item),
                      );
                    },
                  ),
                ),
              ),

              // Dashboard unten
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _DashboardTile(
                              title: 'Offene Tickets',
                              value: '0',
                              icon: Icons.pending_actions,
                              color: Color(0xFFFFB300),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _DashboardTile(
                              title: 'Erledigt heute',
                              value: '0',
                              icon: Icons.check_circle,
                              color: Color(0xFF00E676),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _DashboardTile(
                              title: 'History',
                              value: '0',
                              icon: Icons.history,
                              color: Color(0xFF1E88E5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _DashboardTile(
                              title: 'Safety',
                              value: 'OK',
                              icon: Icons.security,
                              color: Color(0xFFE53935),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _DashboardTile(
                              title: 'Inventur',
                              value: '0',
                              icon: Icons.fact_check,
                              color: Color(0xFF43A047),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _DashboardTile(
                              title: 'News',
                              value: '1',
                              icon: Icons.campaign,
                              color: Color(0xFF00BFA5),
                            ),
                          ),
                        ],
                      ),
                    ],
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

class _CategoryItem {
  final String title;
  final IconData icon;
  final Color color;

  _CategoryItem(this.title, this.icon, this.color);
}

class HoverTile extends StatefulWidget {
  final _CategoryItem item;

  const HoverTile({super.key, required this.item});

  @override
  State<HoverTile> createState() => _HoverTileState();
}

class _HoverTileState extends State<HoverTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hovered = false;
        });
      },
      child: AnimatedScale(
        scale: _hovered ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: _hovered
                ? Colors.white.withOpacity(0.14)
                : Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? item.color.withOpacity(0.9)
                  : item.color.withOpacity(0.35),
              width: _hovered ? 1.6 : 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? item.color.withOpacity(0.22)
                    : Colors.black.withOpacity(0.22),
                blurRadius: _hovered ? 18 : 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Positioned(
                  right: -16,
                  top: -16,
                  child: Icon(
                    item.icon,
                    size: 68,
                    color: item.color.withOpacity(0.12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icon, color: item.color, size: 20),
                      const SizedBox(height: 6),
                      Text(
                        item.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
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

class _DashboardTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _DashboardTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
