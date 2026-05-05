import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  Future<void> _fetchLeaderboard() async {
    try {
      final response = await http.get(Uri.parse('http://188.137.251.110:8000/leaderboard'));
      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Umumiy Reyting')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(child: Text("Hozircha reyting bo'sh yoki server ishlamayapti."))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final isFirst = index == 0;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: isFirst ? Colors.amber.withOpacity(0.2) : const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(15),
                        border: isFirst ? Border.all(color: Colors.amber, width: 2) : null,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isFirst ? Colors.amber : const Color(0xFF26D0CE),
                          child: isFirst
                              ? const Text("👑", style: TextStyle(fontSize: 20))
                              : Text("${index + 1}", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        ),
                        title: Text(
                          user['name'],
                          style: TextStyle(fontWeight: FontWeight.bold, color: isFirst ? Colors.amber : Colors.white),
                        ),
                        subtitle: Text("${user['level']}-daraja"),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Ball", style: TextStyle(color: Colors.white54, fontSize: 12)),
                            Text("${user['score']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
