import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  String firstName = "";
  String lastName = "";
  String phone = "";
  bool isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => isLoading = true);

    try {
      final int userId = DateTime.now().millisecondsSinceEpoch % 100000; // Unique enough integer ID
      
      await FirebaseFirestore.instance.collection('users').doc(userId.toString()).set({
        'id': userId,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'total_score': 0,
        'unlocked_level': 1,
        'created_at': FieldValue.serverTimestamp(),
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', userId);
      await prefs.setString('user_name', "$firstName $lastName");
      
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tarmoq xatosi: $e')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.code, size: 80, color: Color(0xFF26D0CE)),
                const SizedBox(height: 20),
                const Text("Python Master", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const Text("Musobaqalarga ulanish uchun ro'yxatdan o'ting", style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 40),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Ismingiz', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? "Ismni kiriting" : null,
                  onSaved: (v) => firstName = v!,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Familiyangiz', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? "Familiyani kiriting" : null,
                  onSaved: (v) => lastName = v!,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Telefon raqamingiz', border: OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                  validator: (v) => v!.isEmpty ? "Raqamni kiriting" : null,
                  onSaved: (v) => phone = v!,
                ),
                const SizedBox(height: 30),
                isLoading
                    ? const CircularProgressIndicator(color: Color(0xFF26D0CE))
                    : ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: const Color(0xFF26D0CE),
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Kirish', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
