import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:authhub/screens/Auth_token.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Definisi kelas UserProfile
class UserProfile {
  String username;
  String name;
  String gender;
  String email;
  String dateOfBirth;

  UserProfile({
    required this.username,
    required this.name,
    required this.gender,
    required this.email,
    required this.dateOfBirth,
  });
}

class ProfileScreenAuth extends StatelessWidget {
  const ProfileScreenAuth({super.key});

  Future<String?> getToken() async {
    final authService = AuthService();
    return await authService.getToken();
  }

  Future<Map<String, dynamic>?> fetchUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/user-profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user profile: ${response.statusCode}');
    }
  }

  // Fungsi untuk menambah data pengguna
  Future<void> addUserProfile(UserProfile userProfile) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/user-profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': userProfile.username,
        'name': userProfile.name,
        'gender': userProfile.gender,
        'email': userProfile.email,
        'dateofbirth': userProfile.dateOfBirth,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create user profile: ${response.body}');
    }
  }

  // Fungsi untuk memperbarui data pengguna
  Future<void> updateUserProfile(UserProfile userProfile) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('http://localhost:5000/api/user-profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': userProfile.username,
        'name': userProfile.name,
        'gender': userProfile.gender,
        'email': userProfile.email,
        'dateofbirth': userProfile.dateOfBirth,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user profile: ${response.body}');
    }
  }

  // Fungsi untuk menghapus data pengguna
  Future<void> deleteUserProfile(String username) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('http://localhost:5000/api/user-profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user profile: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Error: Token not found.'));
        }

        String token = snapshot.data!;

        return Scaffold(
          body: Stack(
            children: [
              // Background gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              // Profile content
              FutureBuilder<Map<String, dynamic>?>(
                future: fetchUserProfile(token),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                      child: Text(
                        'User not found.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                  }

                  final userProfile = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        // Baris untuk Welcome dan Username
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Welcome text dengan animasi
                            TweenAnimationBuilder<double>(
                              duration: const Duration(seconds: 1),
                              tween: Tween<double>(begin: 0.8, end: 1.0),
                              curve: Curves.easeInOut,
                              builder: (context, scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: Text(
                                    'Welcome, ${userProfile['name']}!',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                            
                            // Username dan Profile Picture
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '${userProfile['username']}',
                                  style: const TextStyle(fontSize: 18, color: Colors.white),
                                ),
                                const SizedBox(width: 10),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  child: Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Menampilkan informasi pengguna
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: Icon(Icons.settings),
                                onPressed: () {
                                  // Tambahkan logika untuk ikon ini
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.notifications),
                                onPressed: () {
                                  // Tambahkan logika untuk ikon ini
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.help),
                                onPressed: () {
                                  // Tambahkan logika untuk ikon ini
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.logout),
                                onPressed: () {
                                  // Tambahkan logika untuk ikon ini
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Menambahkan Card baru untuk pusat bantuan dan lainnya
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: 100, // Tinggi Card
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'pengaturan akun',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Divider(color: Colors.black, thickness: 2),
                                Text(
                                  'Hapus Akun',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Logout button
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Tambahkan logika untuk logout
                              final authService = AuthService();
                              authService.deleteToken();
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Interactive Footer Gimmick
                        Center(
                          child: Text(
                            'You are now logged in!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
