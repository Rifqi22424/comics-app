import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:komikcast_app/src/app_config.dart';
import 'package:komikcast_app/src/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  // Status untuk menentukan apakah teks tersembunyi atau tidak
  bool isObscureText = true;

  Future<void> _registerUser() async {
    const String apiUrl = 'http://${AppConfig.ipAddress}:3000/register';

    // Mengambil nilai dari TextField
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    // Membuat data payload untuk dikirim ke backend
    Map<String, dynamic> data = {
      'username': username,
      'email': email,
      'password': password,
    };

    // Mengirim permintaan HTTP POST ke endpoint registrasi
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // Registrasi berhasil
        print('Registration successful!');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } else {
        // Registrasi gagal
        print('Registration failed. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during registration: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                // Tambahkan ikon untuk menonaktifkan/mengaktifkan teks tersembunyi
                suffixIcon: IconButton(
                  icon: Icon(
                    isObscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    // Toggle status teks tersembunyi
                    setState(() {
                      isObscureText = !isObscureText;
                    });
                  },
                ),
              ),
              obscureText: isObscureText, // Menggunakan status isObscureText
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _registerUser,
              child: Text(
                'Register',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // Sesuaikan dengan warna tema
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            SizedBox(height: 16.0),
            RichText(
              text: TextSpan(
                text: "Sudah punya akun? ",
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "Login disini",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Navigasi ke halaman pendaftaran (RegisterPage)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
