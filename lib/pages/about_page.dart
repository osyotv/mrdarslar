import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Dasturchi va Xavfsizlik", style: TextStyle(color: Colors.greenAccent)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.security, size: 100, color: Colors.greenAccent),
              const SizedBox(height: 20),
              const Text(
                "MUHAMMADZOKIR",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 3),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.greenAccent)),
                child: const Text("Senior Developer", style: TextStyle(color: Colors.greenAccent, fontSize: 18)),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.2), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.redAccent)),
                child: const Text("Kiber Xavfsizlik Mutaxassisi", style: TextStyle(color: Colors.redAccent, fontSize: 18)),
              ),
              const SizedBox(height: 40),
              const Text("MUHAMMADZOKIR GA BOG'LANISH", style: TextStyle(color: Colors.white70, fontSize: 16)),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Telegram url opener can be added here
                },
                icon: const Icon(Icons.telegram),
                label: const Text("@invesstor_uz", style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26D0CE),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
