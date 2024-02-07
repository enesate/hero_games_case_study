import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hero_games_case_study/src/features/auth/presentation/home_page.dart';
import 'package:hero_games_case_study/src/features/auth/presentation/login_page.dart';
import 'package:hero_games_case_study/src/features/auth/presentation/register_page.dart';
import 'package:hero_games_case_study/src/features/auth/presentation/splash_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hero Games Case Study',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
