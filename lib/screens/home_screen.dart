import 'package:airfintech_task1/screens/display_screen.dart';
import 'package:airfintech_task1/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    firstFetch(context);
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
