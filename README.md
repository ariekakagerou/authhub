# authhub

Aplikasi ini adalah aplikasi pengguna berbasis Flutter yang memungkinkan pengguna untuk mendaftar, masuk, dan mengelola profil mereka. Berikut adalah penjelasan singkat tentang bagaimana aplikasi ini bekerja:
1. Struktur Aplikasi:
Aplikasi ini terdiri dari beberapa layar, termasuk layar pendaftaran (RegisterScreen), layar login (LoginScreen), dan layar profil pengguna (ProfileScreenAuth).
Aplikasi menggunakan MaterialApp untuk mengatur tema dan navigasi antar layar.
2. Pendaftaran Pengguna:
Pengguna dapat mendaftar dengan mengisi informasi seperti nama, email, username, password, gender, dan tanggal lahir.
Data pendaftaran dikirim ke backend melalui HTTP POST request. Jika pendaftaran berhasil, pengguna akan diarahkan ke layar login.
3. Login Pengguna:
Pengguna dapat masuk dengan memasukkan email dan password mereka.
Aplikasi mengirimkan permintaan login ke backend. Jika berhasil, token otentikasi disimpan menggunakan SharedPreferences untuk sesi pengguna.
4. Mengelola Profil:
Setelah login, pengguna dapat melihat dan mengelola profil mereka di ProfileScreenAuth.
Aplikasi mengambil data profil pengguna dari backend menggunakan token yang disimpan. Pengguna dapat memperbarui atau menghapus profil mereka.
Keamanan:
Aplikasi menggunakan token JWT (JSON Web Token) untuk mengautentikasi pengguna dan melindungi endpoint API.
Token disimpan secara lokal di perangkat menggunakan SharedPreferences, sehingga pengguna tetap terautentikasi selama sesi aplikasi.
UI Responsif:
Aplikasi menggunakan widget Flutter untuk membuat antarmuka pengguna yang responsif dan menarik, termasuk penggunaan gradien, animasi, dan elemen interaktif.
Dengan struktur ini, aplikasi memberikan pengalaman pengguna yang mulus dan aman dalam mengelola akun dan profil mereka.
