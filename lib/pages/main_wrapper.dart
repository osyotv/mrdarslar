import 'package:flutter/material.dart';
import 'home_page.dart';
import 'video_page.dart';
import 'leaderboard_page.dart';
import 'payment_page.dart';
import 'about_page.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const VideoPage(),
    const LeaderboardPage(),
    const PaymentPage(),
    const AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF27272A), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: const Color(0xFF09090B),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF3B82F6),
          unselectedItemColor: const Color(0xFFA1A1AA),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Asosiy"),
            BottomNavigationBarItem(icon: Icon(Icons.play_circle_filled), label: "Darslar"),
            BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: "Reyting"),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "To'lov"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
          ],
        ),
      ),
    );
  }
}
