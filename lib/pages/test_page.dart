import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TestPage extends StatefulWidget {
  final int level;
  const TestPage({super.key, required this.level});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<dynamic> questions = [];
  int currentQIndex = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  bool isFinished = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final String response = await rootBundle.loadString('assets/tests.json');
    final data = await json.decode(response);
    setState(() {
      questions = data['level_${widget.level}'] ?? [];
      for (var q in questions) {
        (q['options'] as List).shuffle();
      }
    });
  }

  void _checkAnswer(String selected) {
    if (questions[currentQIndex]['answer'] == selected) {
      correctAnswers++;
    } else {
      wrongAnswers++;
    }

    if (currentQIndex < questions.length - 1) {
      setState(() {
        currentQIndex++;
      });
    } else {
      _finishTest();
    }
  }

  Future<void> _finishTest() async {
    setState(() {
      isFinished = true;
    });

    final prefs = await SharedPreferences.getInstance();
    int currentTotal = prefs.getInt('total_score') ?? 0;
    int testsCompleted = prefs.getInt('tests_completed') ?? 0;
    int currentUnlocked = prefs.getInt('unlocked_level') ?? 1;
    int userId = prefs.getInt('user_id') ?? 0;

    await prefs.setInt('total_score', currentTotal + correctAnswers);
    await prefs.setInt('tests_completed', testsCompleted + 1);

    int newUnlocked = currentUnlocked;
    double percentage = (correctAnswers / questions.length) * 100;
    
    // YAKKAXON REJIMDA 70% TOPSHIRILISHI SHART
    if (percentage >= 70 && currentUnlocked <= widget.level && widget.level < 10) {
      newUnlocked = widget.level + 1;
      await prefs.setInt('unlocked_level', newUnlocked);
    }

    // Serverga yuborish
    if (userId > 0) {
      try {
        await http.post(
          Uri.parse('http://188.137.251.110:8000/update_progress'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'user_id': userId,
            'score_increment': correctAnswers,
            'new_unlocked_level': newUnlocked,
          }),
        );
      } catch (e) {
        // Ignor qilamiz, offline bo'lsa server ishlamaydi.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('${widget.level}-Daraja')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (isFinished) {
      double percentage = (correctAnswers / questions.length) * 100;
      bool passed = percentage >= 70;
      return Scaffold(
        appBar: AppBar(title: const Text('Natija')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                passed ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                size: 100,
                color: passed ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 20),
              const Text('Sizning Natijangiz', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text('$correctAnswers / ${questions.length}', style: const TextStyle(fontSize: 20, color: Colors.white70)),
              Text('${percentage.toInt()}%', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: passed ? Colors.green : Colors.red)),
              const SizedBox(height: 20),
              Text(
                passed ? "Ajoyib! Keyingi daraja ochildi." : "Keyingi darajaga o'tish uchun kamida 70% topishingiz shart!",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF26D0CE), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                child: const Text('Asosiy Menyu', style: TextStyle(fontSize: 18)),
              )
            ],
          ),
        ),
      );
    }

    final q = questions[currentQIndex];
    double progress = (currentQIndex) / questions.length;

    return Scaffold(
      appBar: AppBar(title: Text('${widget.level}-Daraja')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('✅ To\'g\'ri: $correctAnswers', style: const TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
                Text('❌ Xato: $wrongAnswers', style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[800], color: const Color(0xFF26D0CE), minHeight: 10)),
                const SizedBox(width: 15),
                Text('${currentQIndex + 1}/${questions.length}', style: const TextStyle(color: Colors.white54)),
              ],
            ),
            const SizedBox(height: 40),
            Text(q['question'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
            const SizedBox(height: 40),
            Expanded(
              child: ListView.builder(
                itemCount: q['options'].length,
                itemBuilder: (context, index) {
                  String option = q['options'][index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: ElevatedButton(
                      onPressed: () => _checkAnswer(option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E1E1E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.white24)),
                      ),
                      child: Text(option, style: const TextStyle(fontSize: 18)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
