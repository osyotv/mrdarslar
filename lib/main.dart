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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        primaryColor: const Color(0xFF3B82F6), // Premium Blue
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF09090B),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 0.5),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3B82F6),
          secondary: Color(0xFF6366F1), // Indigo
          surface: Color(0xFF18181B), // Zinc-900 (Cards)
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
      },
    );
  }
}
