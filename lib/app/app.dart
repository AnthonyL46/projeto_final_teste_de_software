import 'package:flutter/material.dart';
import 'package:stove_test_project/ui/pages/autimatic_screem.dart';
import 'package:stove_test_project/ui/pages/home_screen.dart';
import 'package:stove_test_project/ui/pages/manual_screem.dart';

class StoveApp extends StatelessWidget {
  const StoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/home": (context) => const HomeScreen(),
        "/autimatic_screem": (context) => const AutimaticScreem(),
        "/manual_screem": (context) => const ManualScreem(),
      },
      initialRoute: '/home',
    );
  }
}
