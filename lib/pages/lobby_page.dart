import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'multiplayer_page.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({super.key});

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  final TextEditingController _codeController = TextEditingController();
  bool isLoading = false;

  Future<void> _createRoom() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('user_id') ?? 0;
      int level = prefs.getInt('unlocked_level') ?? 1;

      final roomCode = (10000 + (DateTime.now().millisecondsSinceEpoch % 90000)).toString();

      await FirebaseFirestore.instance.collection('rooms').doc(roomCode).set({
        'host_id': userId,
        'level': level,
        'created_at': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiplayerPage(roomCode: roomCode, level: level),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tarmoq xatosi: $e')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _joinRoom() {
    String code = _codeController.text.trim();
    if (code.length >= 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiplayerPage(roomCode: code, level: 1), // Real app should fetch level from server
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kodni to\'g\'ri kiriting')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Musobaqa Kutish Xonasi')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.people_alt, size: 80, color: Color(0xFF3B82F6)),
              const SizedBox(height: 20),
              const Text("Do'stlaringiz bilan musobaqalashing!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 40),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _createRoom,
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text("YANGI XONA OCHISH", style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 60),
                      ),
                    ),
              const SizedBox(height: 40),
              const Text("Yoki mavjud xonaga kiring:", style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 10),
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  hintText: 'Xona kodini kiriting',
                  filled: true,
                  fillColor: const Color(0xFF18181B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, letterSpacing: 5),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _joinRoom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 60),
                ),
                child: const Text("XONAGA QO'SHILISH", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
