import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({super.key});

  Future<void> _launchTelegram() async {
    final Uri url = Uri.parse('https://t.me/invesstor_uz');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DASTURCHI HAQIDA')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Hacker avatar
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF00FF41), width: 3),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF00FF41).withOpacity(0.3), blurRadius: 20, spreadRadius: 5)
                ],
                image: const DecorationImage(
                  image: AssetImage('assets/icons/app_icon.png'), // Using the app icon as a placeholder
                  fit: BoxFit.cover,
                )
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Muhammadzokir Rasulov', // Placeholder name, assuming from previous logs or they can change it
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Courier'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Cyber Security & IT Specialist',
              style: TextStyle(fontSize: 18, color: Color(0xFF00FF41), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF008F11)),
              ),
              child: const Text(
                "Men kiberxavfsizlik (Cyber Security) va IT dasturlash bo'yicha mutaxassisman. \n\n"
                "Ushbu ilova Python dasturlash tilini va xavfsizlik asoslarini o'rganishni maqsad qilganlar uchun maxsus, yuqori xavfsizlik standartlari asosida yaratilgan.\n\n"
                "Har qanday IT loyihalar, tizimlar xavfsizligi auditi va hamkorlik uchun men bilan bog'lanishingiz mumkin.",
                style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _launchTelegram,
                icon: const Icon(Icons.telegram, size: 30, color: Colors.black),
                label: const Text(
                  'Bog\'lanish (Telegram)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF41),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
