import 'package:flutter/material.dart';
import 'home_page.dart';
import 'video_page.dart';
import 'leaderboard_page.dart';
import 'payment_page.dart';
import 'profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _listenForNewVideos();
  }

  void _listenForNewVideos() {
    FirebaseFirestore.instance.collection('notifications').doc('latest_video').snapshots().listen((snapshot) async {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        if (data.containsKey('timestamp')) {
          final Timestamp serverTs = data['timestamp'] as Timestamp;
          final prefs = await SharedPreferences.getInstance();
          final int lastSeenTs = prefs.getInt('last_video_ts') ?? 0;
          
          if (serverTs.millisecondsSinceEpoch > lastSeenTs && lastSeenTs != 0) { // Don't show on very first install
            if (mounted) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF111111),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Color(0xFF00FF41))),
                  title: const Text('Yangi Video!', style: TextStyle(color: Color(0xFF00FF41))),
                  content: Text('Admin yangi dars qo\'shdi: \n\n"${data['title']}"', style: const TextStyle(color: Colors.white)),
                  actions: [
                    TextButton(
                      onPressed: () {
                        prefs.setInt('last_video_ts', serverTs.millisecondsSinceEpoch);
                        Navigator.pop(context);
                        setState(() { _currentIndex = 1; }); // Go to videos page
                      },
                      child: const Text('Ko\'rish', style: TextStyle(color: Color(0xFF00FF41))),
                    )
                  ],
                ),
              );
            }
          } else if (lastSeenTs == 0) {
            prefs.setInt('last_video_ts', serverTs.millisecondsSinceEpoch);
          }
        }
      }
    });
  }

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
          selectedItemColor: const Color(0xFF00FF41),
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
