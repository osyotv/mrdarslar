import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'test_page.dart';
import 'lobby_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int unlockedLevel = 1;
  String userName = "O'quvchi";
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      unlockedLevel = prefs.getInt('unlocked_level') ?? 1;
      userName = prefs.getString('user_name') ?? "O'quvchi";
      userId = prefs.getInt('user_id') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF09090B),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF09090B), Color(0xFF18181B)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('MR Darslari', style: TextStyle(color: Color(0xFF00FF41), fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        const SizedBox(height: 20),
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xFF00FF41),
                          child: Icon(Icons.person, size: 35, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          userName.toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "ID: $userId",
                          style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 12, letterSpacing: 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF00FF41), Color(0xFF6366F1)]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: const Color(0xFF00FF41).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LobbyPage()),
                    );
                  },
                  icon: const Icon(Icons.public, size: 28, color: Colors.white),
                  label: const Text("MUSOBAQA REJIMI", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 20, 24, 10),
              child: Text("O'quv Dasturi", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final level = index + 1;
                final isLocked = level > unlockedLevel;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF18181B), // Zinc-900
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF27272A), width: 1), // Subtle border
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isLocked ? const Color(0xFF27272A) : const Color(0xFF00FF41).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$level',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isLocked ? const Color(0xFF71717A) : const Color(0xFF00FF41),
                        ),
                      ),
                    ),
                    title: Text(
                      'Daraja $level',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isLocked ? const Color(0xFF71717A) : Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      isLocked ? "Qulflangan" : "Testni boshlash",
                      style: TextStyle(color: isLocked ? const Color(0xFF52525B) : const Color(0xFFA1A1AA), fontSize: 13),
                    ),
                    trailing: Icon(
                      isLocked ? Icons.lock_outline : Icons.arrow_forward_ios,
                      color: isLocked ? const Color(0xFF52525B) : const Color(0xFF00FF41),
                      size: 20,
                    ),
                    onTap: () {
                      if (isLocked) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Oldin ${level - 1}-darajani 100% tugating!"), backgroundColor: const Color(0xFF18181B)));
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TestPage(level: level)),
                        ).then((_) => _loadProgress());
                      }
                    },
                  ),
                );
              },
              childCount: 10,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

}
