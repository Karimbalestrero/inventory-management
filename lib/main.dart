import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'screens/stammdaten_2d_screen.dart';
import 'screens/todo_list_screen.dart';
import 'screens/inventurcheckliste_screen.dart';
import 'screens/5s_screen.dart';
import 'screens/ma_planung_screen.dart';
import 'screens/kvp_screen.dart';
import 'screens/safety_screen.dart';
import 'screens/history_screen.dart';

void main() {
  runApp(const InventoryManagementApp());
}

class InventoryManagementApp extends StatelessWidget {
  const InventoryManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory Management',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF061826),
      ),
      home: const HomeScreen(),
    );
  }
}

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
              const SizedBox(height: 8),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF00E676).withOpacity(0.22),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00E676), Color(0xFF00C853)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00E676).withOpacity(0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.inventory_2_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Inventory',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 1),
                            Text(
                              'Management System',
                              style: TextStyle(
                                color: Color(0xFFBFD8E8),
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // News
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF00BFA5).withOpacity(0.22),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.campaign_outlined, color: Color(0xFF00E676), size: 16),
                          SizedBox(width: 6),
                          Text(
                            'News',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Tickets nach Bearbeitung direkt erledigen.',
                        style: TextStyle(color: Colors.white, fontSize: 11.5, height: 1.15),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'QR-Scan für Artikel, Von- und Nach-Lagerplatz nutzen.',
                        style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.15),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Categories
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GridView.builder(
                    itemCount: categories.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                      childAspectRatio: 1.02,
                    ),
                    itemBuilder: (context, index) {
                      final item = categories[index];
                      return CategoryTile(
                        title: item.title,
                        icon: item.icon,
                        color: item.color,
                        onTap: () {
                          if (item.title == 'Stammdaten 2D') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Stammdaten2DScreen(),
                              ),
                            );
                          } else if (item.title == 'History') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HistoryScreen(),
                              ),
                            );
                          } else if (item.title == 'To-Do-List') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TodoListScreen(),
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
                          }
                        },
                      );
                    },
                  ),
                ),
              ),

              // Dashboard
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // KPI cards
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                        childAspectRatio: 2.8,
                        children: const [
                          _DashboardKpiCard(
                            title: 'Offene Tickets',
                            value: '12',
                            icon: Icons.pending_actions,
                            color: Color(0xFFFFB300),
                          ),
                          _DashboardKpiCard(
                            title: 'Erledigt',
                            value: '24',
                            icon: Icons.check_circle,
                            color: Color(0xFF00E676),
                          ),
                          _DashboardKpiCard(
                            title: 'Überfällig',
                            value: '3',
                            icon: Icons.warning_amber_rounded,
                            color: Color(0xFFE53935),
                          ),
                          _DashboardKpiCard(
                            title: 'Safety offen',
                            value: '2',
                            icon: Icons.security,
                            color: Color(0xFFE53935),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      SizedBox(
                        height: 120,
                        child: Row(
                          children: const [
                            Expanded(child: _DashboardBarChartCard()),
                            SizedBox(width: 8),
                            Expanded(child: _DashboardPieChartCard()),
                          ],
                        ),
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

class CategoryTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.11),
              Colors.white.withOpacity(0.06),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: color.withOpacity(0.18)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.22),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9.5,
                  height: 1.1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _DashboardKpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 9.5,
                    height: 1.05,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardBarChartCard extends StatelessWidget {
  const _DashboardBarChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Balken',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10,
                minY: 0,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white.withOpacity(0.08),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _buildBarGroup(0, 6, const Color(0xFFFFB300)),
                  _buildBarGroup(1, 8, const Color(0xFF00E676)),
                  _buildBarGroup(2, 3, const Color(0xFFE53935)),
                ],
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      interval: 5,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 8,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 18,
                      getTitlesWidget: (value, meta) {
                        const labels = ['O', 'E', 'S'];
                        if (value.toInt() < 0 || value.toInt() > 2) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          labels[value.toInt()],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 8,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 12,
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.95),
              color.withOpacity(0.55),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ],
    );
  }
}

class _DashboardPieChartCard extends StatelessWidget {
  const _DashboardPieChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kreis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 18,
                sections: [
                  PieChartSectionData(
                    value: 72,
                    color: const Color(0xFF00E676),
                    radius: 18,
                    title: '',
                  ),
                  PieChartSectionData(
                    value: 18,
                    color: const Color(0xFFFFB300),
                    radius: 18,
                    title: '',
                  ),
                  PieChartSectionData(
                    value: 10,
                    color: const Color(0xFFE53935),
                    radius: 18,
                    title: '',
                  ),
                ],
              ),
            ),
          ),
          const Center(
            child: Text(
              '72% erledigt',
              style: TextStyle(color: Colors.white70, fontSize: 10.5),
            ),
          ),
        ],
      ),
    );
  }
}
