import 'package:flutter/material.dart';
import 'package:manager_test_task/main.dart';
import 'package:manager_test_task/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _onGetStarted(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenSplash', true);
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ClipPath(
              clipper: WaveClipper(topWave: true),
              child: Container(
                height: 250,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: WaveClipper(topWave: false),
              child: Container(
                height: 500,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  const Text(
                    'Task Management',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Image.asset(
                    'assets/images/task_illustration.png',
                    height: 250,
                  ),
                  const Spacer(flex: 4),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 60,
            right: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () => _onGetStarted(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    shadowColor: AppColors.primaryBlue.withOpacity(0.4),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'The best way to organize your tasks and boost your productivity.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final bool topWave;
  WaveClipper({required this.topWave});

  @override
  Path getClip(Size size) {
    var path = Path();
    if (topWave) {
      path.lineTo(0, size.height * 0.8);
      path.cubicTo(
        size.width * 0.3, size.height * 0.2,
        size.width * 0.5, size.height * 0.9,
        size.width, size.height * 0.7,
      );
      path.lineTo(size.width, 0);
    } else {
      path.moveTo(0, size.height * 0.4);
      path.cubicTo(
        size.width * 0.4, size.height * 0,
        size.width * 0.5, size.height * 0.8,
        size.width, size.height * 0.45,
      );
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}