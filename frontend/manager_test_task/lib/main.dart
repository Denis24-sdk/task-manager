import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:manager_test_task/providers/task_provider.dart';
import 'package:manager_test_task/screens/login_screen.dart';
import 'package:manager_test_task/screens/splash_screen.dart';
import 'package:manager_test_task/screens/task_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color lightBlueBackground = Color(0xFFF0F4F8);
  static const Color cardBackground = Color(0xFFF5F5F7);
  static const Color primaryText = Color(0xFF333333);
  static const Color secondaryText = Color(0xFF888888);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        title: 'Task Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.lightBlueBackground,
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryBlue,
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryText),
            bodyMedium: TextStyle(color: AppColors.secondaryText),
          ),
        ),
        home: const AuthCheck(),
      ),
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

enum AuthStatus { unknown, splash, unauthenticated, authenticated }

class _AuthCheckState extends State<AuthCheck> {

  Future<AuthStatus> _getInitialStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenSplash = prefs.getBool('hasSeenSplash') ?? false;

    if (!hasSeenSplash) {
      return AuthStatus.splash;
    }

    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'auth_token');
    if (token != null) {
      return AuthStatus.authenticated;
    } else {
      return AuthStatus.unauthenticated;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthStatus>(
      future: _getInitialStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        switch (snapshot.data) {
          case AuthStatus.splash:
            return const SplashScreen();
          case AuthStatus.authenticated:
            return const TaskListScreen();
          case AuthStatus.unauthenticated:
            return const LoginScreen();
          default:
            return const LoginScreen();
        }
      },
    );
  }
}
