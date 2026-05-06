import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

class MultiplayerPage extends StatefulWidget {
  final String roomCode;
  final int level;
  const MultiplayerPage({super.key, required this.roomCode, required this.level});

  @override
  State<MultiplayerPage> createState() => _MultiplayerPageState();
}

class _MultiplayerPageState extends State<MultiplayerPage> {
  StreamSubscription<DocumentSnapshot>? _roomSubscription;
  List<dynamic> leaderboard = [];
  List<dynamic> questions = [];
  int currentQIndex = 0;
  int myScore = 0;
  bool isFinished = false;
  int userId = 0;
  String userName = "";

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _connectToRoom();
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

  Future<void> _connectToRoom() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id') ?? 0;
    userName = prefs.getString('user_name') ?? "Foydalanuvchi";
    
    // Join room initially
    await FirebaseFirestore.instance.collection('rooms').doc(widget.roomCode).set({
      'scores': {
        userId.toString(): {'name': userName, 'score': 0}
      }
    }, SetOptions(merge: true));

    // Listen to changes
    _roomSubscription = FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomCode)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        if (data.containsKey('scores')) {
          Map<String, dynamic> scores = data['scores'];
          List<dynamic> sortedLeaderboard = [];
          scores.forEach((key, value) {
            sortedLeaderboard.add({
              'user_id': key,
              'name': value['name'],
              'score': value['score']
            });
          });
          sortedLeaderboard.sort((a, b) => b['score'].compareTo(a['score']));
          
          if (mounted) {
            setState(() {
              leaderboard = sortedLeaderboard;
            });
          }
        }
      }
    });
  }

  Future<void> _checkAnswer(String selected) async {
    if (questions[currentQIndex]['answer'] == selected) {
      myScore += 10;
      // Update score in firestore
      await FirebaseFirestore.instance.collection('rooms').doc(widget.roomCode).set({
        'scores': {
          userId.toString(): {'name': userName, 'score': myScore}
        }
      }, SetOptions(merge: true));
    }

    if (currentQIndex < questions.length - 1) {
      setState(() {
        currentQIndex++;
      });
    } else {
      setState(() {
        isFinished = true;
      });
    }
  }

  @override
  void dispose() {
    _roomSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Xona: ${widget.roomCode}'),
        backgroundColor: const Color(0xFF09090B),
      ),
      body: Column(
        children: [
          // Live Leaderboard (Top 3 or scrolling)
          Container(
            height: 120,
            padding: const EdgeInsets.all(10),
            color: const Color(0xFF18181B),
            child: leaderboard.isEmpty
                ? const Center(child: Text("Boshqa o'yinchilar kutilmoqda..."))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: leaderboard.length,
                    itemBuilder: (context, index) {
                      final player = leaderboard[index];
                      final isFirst = index == 0;
                      return Container(
                        width: 150,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: isFirst ? Colors.amber.withOpacity(0.2) : const Color(0xFF27272A),
                          borderRadius: BorderRadius.circular(12),
                          border: isFirst ? Border.all(color: Colors.amber, width: 2) : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isFirst) const Text("👑", style: TextStyle(fontSize: 20)),
                            Text(player['name'] ?? "User", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center, maxLines: 1),
                            Text("${player['score']} ball", style: const TextStyle(color: Colors.greenAccent)),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const Divider(height: 1, color: Color(0xFF27272A)),
          
          // Test Area
          Expanded(
            child: isFinished
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.flag, size: 80, color: Colors.green),
                        const SizedBox(height: 20),
                        const Text("Siz testni yakunladingiz!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        const Text("Boshqa o'yinchilar tugatishini kuting..."),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Chiqish"),
                        )
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Savol: ${currentQIndex + 1}/${questions.length}', style: const TextStyle(color: Colors.white54)),
                            Text('Mening Ballim: $myScore', style: const TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Text(
                          questions[currentQIndex]['question'],
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        Expanded(
                          child: ListView.builder(
                            itemCount: questions[currentQIndex]['options'].length,
                            itemBuilder: (context, index) {
                              String option = questions[currentQIndex]['options'][index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: ElevatedButton(
                                  onPressed: () => _checkAnswer(option),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF18181B),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.all(20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: const BorderSide(color: Color(0xFF27272A)),
                                    ),
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
          ),
        ],
      ),
    );
  }
}
