import 'package:authhub/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:password_strength/password_strength.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Tambahkan import ini
import 'package:http/http.dart' as http; // Tambahkan import ini
import 'dart:convert'; // Tambahkan import ini

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  String gender = 'male';
  DateTime selectedBirthDate = DateTime.now();
  double passwordStrength = 0.0;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void showToast(String message, Color color) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: color,
      textColor: Colors.white,
    );
  }

  Future<void> registerUser() async {
    // Ubah menjadi async
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        birthDateController.text.isEmpty) {
      showToast("Please fill in all the fields!", Colors.red);
    } else if (passwordController.text.length < 6 ||
        confirmPasswordController.text.length < 6) {
      showToast("Password must be at least 6 characters!", Colors.red);
    } else if (passwordController.text != confirmPasswordController.text) {
      showToast("Password and confirmation do not match!", Colors.red);
    } else if (passwordStrength < 0.3) {
      showToast("Password is weak!", Colors.red);
    } else {
      // Kirim data ke backend
      try {
        final response = await http.post(
          Uri.parse('http://localhost:5000/api/register'), // Ganti dengan URL backend Anda
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'name': nameController.text,
            'email': emailController.text,
            'username': usernameController.text,
            'password': passwordController.text,
            'gender': gender,
            'dateofbirth': birthDateController.text,
          }),
        );

        if (response.statusCode == 201) {
          showToast("Registration successful!", Colors.green);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          final responseData = json.decode(response.body);
          showToast(responseData['message'], Colors.red);
        }
      } catch (error) {
        showToast("Failed to connect to the server.", Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Gimmick in the form of a transparent circle
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
          // Register content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  const Center(
                    child: Text(
                      'Register',
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
                    controller: nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Full Name',
                      prefixIcon: const Icon(Icons.person, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: birthDateController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Birth Date',
                      prefixIcon: const Icon(Icons.cake, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today,
                            color: Colors.blue),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedBirthDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedBirthDate = picked;
                              birthDateController.text =
                                  DateFormat('yyyy-MM-dd').format(picked);
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Email',
                      prefixIcon: const Icon(Icons.email, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Username',
                      prefixIcon: const Icon(Icons.person, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Ubah untuk mengatur posisi radio button
                    children: <Widget>[
                      Radio(
                        value: 'female',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value.toString();
                          });
                        },
                        activeColor: Colors
                            .pink, // Ubah warna radio button menjadi lebih terlihat
                      ),
                      const Text(
                        'Female',
                        style: TextStyle(color: Colors.white),
                      ),
                      Radio(
                        value: 'male',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value.toString();
                          });
                        },
                        activeColor: Colors
                            .blue, // Ubah warna radio button menjadi lebih terlihat
                      ),
                      const Text(
                        'Male',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Password',
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        obscureText: !_isPasswordVisible,
                        onChanged: (value) {
                          setState(() {
                            passwordStrength = estimatePasswordStrength(value);
                          });
                        },
                      ),
                      Positioned(
                        right: 10,
                        child: Icon(
                          passwordStrength < 0.3
                              ? Icons.signal_cellular_0_bar
                              : passwordStrength < 0.7
                                  ? Icons.signal_cellular_0_bar
                                  : Icons.signal_cellular_4_bar,
                          color: passwordStrength < 0.3
                              ? Colors.red
                              : passwordStrength < 0.7
                                  ? Colors.yellow
                                  : Colors.green,
                        ),
                      ),
                      Positioned(
                        right: 50,
                        child: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Confirm Password',
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        obscureText: !_isConfirmPasswordVisible,
                        onChanged: (value) {
                          setState(() {
                            if (value == passwordController.text) {
                              showToast("Password and confirmation match!",
                                  Colors.green);
                            } else {
                              showToast(
                                  "Password and confirmation do not match!",
                                  Colors.red);
                            }
                          });
                        },
                      ),
                      const Positioned(
                        right: 10,
                        child: Icon(
                          Icons.signal_cellular_0_bar,
                          color: Colors.red,
                        ),
                      ),
                      Positioned(
                        right: 50,
                        child: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      onPressed: registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Register',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?',
                          style: TextStyle(color: Colors.white)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text('Login',
                            style: TextStyle(
                                color: Colors
                                    .white)), // Ubah warna text button menjadi lebih terlihat
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
