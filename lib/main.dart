import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/home_page.dart';
import 'pages/stats_page.dart';
import 'pages/video_page.dart';
import 'pages/auth_page.dart';
import 'pages/about_page.dart';
import 'pages/payment_page.dart';
import 'pages/leaderboard_page.dart';
import 'pages/main_wrapper.dart';
import 'pages/profile_page.dart';
import 'pages/developer_page.dart';
import 'pages/admin_panel_page.dart';
import 'pages/certificate_page.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final hasUser = prefs.getInt('user_id') != null;
  runApp(MRDarslariApp(hasUser: hasUser));
}

class MRDarslariApp extends StatelessWidget {
  final bool hasUser;
  const MRDarslariApp({super.key, required this.hasUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MR Darslari',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF09090B), // Zinc-950 (Premium Deep Black)
        primaryColor: const Color(0xFF00FF41), // Matrix Green
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF09090B),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(color: Color(0xFF00FF41), fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontFamily: 'Courier'),
          iconTheme: IconThemeData(color: Color(0xFF00FF41)),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF41),
          secondary: Color(0xFF008F11), // Darker Green
          surface: Color(0xFF111111), // Slightly lighter black
        ),
        fontFamily: 'Roboto', // Modern sans-serif
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
      ),
      initialRoute: hasUser ? '/home' : '/',
      routes: {
        '/': (context) => const AuthPage(),
        '/home': (context) => const MainWrapper(),
        '/stats': (context) => const StatsPage(),
        '/video': (context) => const VideoPage(),
        '/about': (context) => const AboutPage(),
        '/payment': (context) => const PaymentPage(),
        '/leaderboard': (context) => const LeaderboardPage(),
        '/profile': (context) => const ProfilePage(),
        '/developer': (context) => const DeveloperPage(),
        '/admin': (context) => const AdminPanelPage(),
        '/certificate': (context) => const CertificatePage(),
      },
    );
  }
}
