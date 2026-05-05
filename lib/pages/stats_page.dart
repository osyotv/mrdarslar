import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int totalScore = 0;
  int testsCompleted = 0;
  int unlockedLevel = 1;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      totalScore = prefs.getInt('total_score') ?? 0;
      testsCompleted = prefs.getInt('tests_completed') ?? 0;
      unlockedLevel = prefs.getInt('unlocked_level') ?? 1;
    });
  }

  String get rank {
    if (unlockedLevel == 10 && testsCompleted >= 10) return "Ekspert (Senior)";
    if (unlockedLevel >= 7) return "Kuchli (Middle)";
    if (unlockedLevel >= 4) return "O'rtacha (Junior)";
    return "Boshlang'ich";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mening Statistikam')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.account_circle, size: 80, color: Color(0xFF26D0CE)),
                  const SizedBox(height: 10),
                  const Text("Foydalanuvchi", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("Daraja: $rank", style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildStatBox("Umumiy Ball", totalScore.toString(), Icons.stars, Colors.amber)),
                const SizedBox(width: 20),
                Expanded(child: _buildStatBox("Testlar", testsCompleted.toString(), Icons.quiz, Colors.blue)),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("O'zlashtirish jarayoni", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  LinearProgressIndicator(
                    value: unlockedLevel / 10,
                    minHeight: 10,
                    backgroundColor: Colors.grey[800],
                    color: const Color(0xFF26D0CE),
                  ),
                  const SizedBox(height: 10),
                  Text("10 ta darajadan $unlockedLevel-darajadasiz", style: const TextStyle(color: Colors.white54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
