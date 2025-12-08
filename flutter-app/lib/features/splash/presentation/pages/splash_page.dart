import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const String _introSeenKey = 'intro_seen';

  @override
  void initState() {
    super.initState();
    _checkIntroAndNavigate();
  }

  Future<void> _checkIntroAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final introSeen = prefs.getBool(_introSeenKey) ?? false;

    if (introSeen) {
      // Intro zaten görüldüyse direkt onboarding'e git
      context.go('/onboarding');
    } else {
      // İlk açılışsa intro'ya git
      context.go('/intro');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_bag,
                size: 60,
                color: Color(0xFFCCFF00),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'E-Commerce',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFCCFF00)),
            ),
          ],
        ),
      ),
    );
  }
}

