import 'package:flutter/material.dart';
import 'screens/Auth_token.dart';
import 'screens/auth/screens/profile_screen.dart';
import 'screens/register.dart';
import 'screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Pengguna',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(), // Mengatur layar awal ke LoginScreen
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/Auth': (context) => const ProfileScreenAuth(),
        '/profile-auth': (context) => const ProfileScreenAuth(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
