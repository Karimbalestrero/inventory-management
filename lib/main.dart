import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

import 'screens/stammdaten_2d_screen.dart';
import 'screens/todo_list_screen.dart';
import 'screens/inventurcheckliste_screen.dart';
import 'screens/5s_screen.dart';
import 'screens/ma_planung_screen.dart';
import 'screens/kvp_screen.dart';
import 'screens/safety_screen.dart';
import 'screens/history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController chatController = TextEditingController();

  final List<_ChatMessage> messages = [
    _ChatMessage(
      author: 'System',
      text: 'Willkommen im Team-Chat.',
      isSystem: true,
    ),
  ];

  void _sendChatMessage() {
    final text = chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(
        _ChatMessage(
          author: 'Karim',
          text: text,
        ),
      );
      chatController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      _CategoryItem('Stammdaten 2D', Icons.qr_code_scanner, Colors.white),
      _CategoryItem('To-Do-List', Icons.check_circle_outline, Colors.white),
      _CategoryItem('History', Icons.history, Colors.white),
      _CategoryItem('Inventurcheckliste', Icons.fact_check, Colors.white),
      _CategoryItem('5S', Icons.cleaning_services, Colors.white),
      _CategoryItem('MA-Planung', Icons.calendar_month, Colors.white),
      _CategoryItem('KVP', Icons.lightbulb_outline, Colors.white),
      _CategoryItem('Safety', Icons.security, Colors.white),
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

              // News from Firestore
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('app_config')
                      .doc('news')
                      .snapshots(),
                  builder: (context, snapshot) {
                    String title = 'News';
                    String text = 'Tickets nach Bearbeitung direkt erledigen.';
                    String subtext ='QR-Scan für Artikel, Von- und Nach-Lagerplatz nutzen.';

                    if (snapshot.hasData && snapshot.data!.exists) {
                      final data = snapshot.data!.data();
                      if (data != null) {
                        title = (data['title'] ?? title).toString();
                        text = (data['text'] ?? text).toString();
                        subtext = (data['subtext'] ?? subtext).toString();
                      }
                    }

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF00BFA5).withOpacity(0.22),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.campaign_outlined,
                                  color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11.5,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            subtext,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              height: 1.15,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Kategorien
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GridView.builder(
                    itemCount: categories.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.1,
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

              // Team-Chat
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
                          'Team-Chat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      SizedBox(
                        height: 90,
                        child: ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final msg = messages[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Align(
                                alignment: msg.isSystem
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: msg.isSystem
                                        ? Colors.white.withOpacity(0.10)
                                        : const Color(0xFF00C853).withOpacity(0.22),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    msg.isSystem ? msg.text : '${msg.author}: ${msg.text}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.5,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: chatController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Nachricht eingeben...',
                                hintStyle: const TextStyle(color: Colors.white54),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.08),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _sendChatMessage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00E676),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                            ),
                            child: const Icon(Icons.send, size: 18),
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

class _ChatMessage {
  final String author;
  final String text;
  final bool isSystem;

  _ChatMessage({
    required this.author,
    required this.text,
    this.isSystem = false,
  });
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
              Colors.white.withOpacity(0.12),
              Colors.white.withOpacity(0.06),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withOpacity(0.20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
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
