import 'package:authhub/screens/Auth_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'register.dart';
import 'auth/screens/profile_screen.dart'; // Pastikan path ini benar
import 'package:authhub/screens/Auth_token.dart'; // Ganti dengan path yang sesuai

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberPassword = false; // Tambahkan variabel untuk mengatur checkbox
  bool _isPasswordVisible = false; // Tambahkan variabel untuk mengatur visibilitas password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background dengan gradien
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Gimmick berupa lingkaran transparan
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ),
          // Konten login
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: RichText(
                      text: const TextSpan(
                        text: 'By signing in you are agreeing\n',
                        style: TextStyle(color: Colors.white70),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'our Term and privacy policy',
                            style: TextStyle(color: Colors.lightBlue),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Email Address',
                      prefixIcon: const Icon(Icons.email, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberPassword, // Ubah value menjadi _rememberPassword
                            onChanged: (value) {
                              setState(() {
                                _rememberPassword = value!; // Ubah _rememberPassword berdasarkan value yang diterima
                              });
                            },
                          ),
                          const Text('Remember password', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: const Text('Forget password', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async { 
                        if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill in all the fields'),
                            ),
                          );
                        } else {
                          print('Attempting to login with email: ${_emailController.text}');
                          final response = await http.post(
                            Uri.parse('http://localhost:5000/api/login'), 
                            headers: {
                              'Content-Type': 'application/json',
                            },
                            body: json.encode({
                              'email': _emailController.text,
                              'password': _passwordController.text,
                            }),
                          );

                          print('Response status: ${response.statusCode}');
                          if (response.statusCode == 200) {
                            final responseData = json.decode(response.body);
                            print('Login successful: ${responseData['token']}');
                            final authService = AuthService();
                            await authService.saveToken(responseData['token']);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const ProfileScreenAuth()),
                            );
                          } else if (response.statusCode == 404) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Email not found. Please try again.'),
                              ),
                            );
                          } else if (response.statusCode == 401) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Incorrect password. Please try again.'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('An error occurred. Please try again.'),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?', style: TextStyle(color: Colors.white)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.phone, color: Colors.white),
                        onPressed: () {
                          // Tambahkan fungsi untuk menghubungi nomor telepon
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.email, color: Colors.white),
                        onPressed: () {
                          // Tambahkan fungsi untuk mengirim email
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.facebook, color: Colors.white),
                        onPressed: () {
                          // Tambahkan fungsi untuk login dengan Facebook
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.code, color: Colors.white),
                        onPressed: () {
                          // Tambahkan fungsi untuk login dengan GitHub
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}