# AuthHub

**AuthHub** adalah aplikasi pengguna berbasis **Flutter** yang memungkinkan pengguna untuk **mendaftar, masuk, dan mengelola profil** mereka dengan mudah. Aplikasi ini dirancang dengan **UI responsif**, **keamanan JWT**, dan **pengelolaan sesi pengguna** yang andal.

## 📌 Fitur Utama

✅ **Pendaftaran Pengguna**  
Pengguna dapat mendaftar dengan mengisi informasi seperti:
- Nama lengkap
- Email
- Username
- Password
- Gender
- Tanggal lahir

Data pendaftaran dikirim ke backend melalui **HTTP POST request**. Jika berhasil, pengguna akan diarahkan ke layar login.

✅ **Login & Autentikasi**  
Pengguna dapat masuk dengan **email dan password** mereka. Jika berhasil, **token JWT** akan disimpan menggunakan **SharedPreferences** untuk menjaga sesi pengguna tetap aktif.

✅ **Pengelolaan Profil**  
Setelah login, pengguna dapat:
- Melihat data profil mereka
- Memperbarui informasi profil
- Menghapus akun mereka

Data diambil dari backend menggunakan **token autentikasi** yang tersimpan.

✅ **Keamanan & Otentikasi**  
- Menggunakan **JSON Web Token (JWT)** untuk melindungi endpoint API.
- Token disimpan secara lokal menggunakan **SharedPreferences** untuk memastikan sesi tetap aman.

✅ **UI Responsif & Modern**  
- Dibangun dengan **Flutter Widgets** untuk tampilan yang menarik.
- Menggunakan **gradien, animasi, dan elemen interaktif** untuk pengalaman pengguna yang lebih baik.

## 📂 Struktur Aplikasi
Aplikasi ini terdiri dari beberapa layar utama:
1. **RegisterScreen** → Layar pendaftaran pengguna.
2. **LoginScreen** → Layar login pengguna.
3. **ProfileScreenAuth** → Layar profil pengguna setelah login.

Navigasi antar layar dikelola menggunakan **MaterialApp** untuk pengalaman yang mulus.

## 🚀 Teknologi yang Digunakan
- **Flutter** untuk pengembangan aplikasi.
- **Dart** sebagai bahasa pemrograman utama.
- **HTTP API** untuk komunikasi dengan backend.
- **SharedPreferences** untuk penyimpanan token autentikasi.
- **JWT** untuk keamanan sesi pengguna.

Dengan arsitektur ini, **AuthHub** memberikan pengalaman pengguna yang **mudah, aman, dan efisien** dalam mengelola akun mereka. 🎉

