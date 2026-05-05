import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class MultiplayerPage extends StatefulWidget {
  final String roomCode;
  final int level;
  const MultiplayerPage({super.key, required this.roomCode, required this.level});

  @override
  State<MultiplayerPage> createState() => _MultiplayerPageState();
}

class _MultiplayerPageState extends State<MultiplayerPage> {
  WebSocketChannel? _channel;
  List<dynamic> leaderboard = [];
  List<dynamic> questions = [];
  int currentQIndex = 0;
  int myScore = 0;
  bool isFinished = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _connectWebSocket();
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

  Future<void> _connectWebSocket() async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;
    
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://188.137.251.110:8000/ws/${widget.roomCode}/$userId'),
    );

    _channel!.stream.listen((message) {
      final data = json.decode(message);
      if (data['type'] == 'leaderboard') {
        setState(() {
          leaderboard = data['data'];
        });
      }
    });
  }

  void _checkAnswer(String selected) {
    if (questions[currentQIndex]['answer'] == selected) {
      myScore += 10;
      _channel?.sink.add(json.encode({'type': 'score_update', 'points': 10}));
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
    _channel?.sink.close();
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
                            Text(player['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center, maxLines: 1),
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
