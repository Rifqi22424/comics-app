import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:komikcast_app/src/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_pages.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscureText = true;

  Future<void> _loginUser() async {
    const String apiUrl = 'http://${AppConfig.ipAddress}:3000/login';

    // Mengambil nilai dari TextField
    String email = emailController.text;
    String password = passwordController.text;

    // Membuat data payload untuk dikirim ke backend
    Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    // Mengirim permintaan HTTP POST ke endpoint login
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // Login berhasil
        print('Login successful!');
        // Mendapatkan ID dari respons API
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final int userId = responseData['userId'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('userId', userId);
        print(userId);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreens(),
          ),
        );
      } else {
        print('Login failed. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during login: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    isObscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscureText = !isObscureText;
                    });
                  },
                ),
                border: OutlineInputBorder(),
              ),
              obscureText: isObscureText,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _loginUser,
              child: Text(
                'Login',
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
                text: "Belum punya akun? ",
                style: TextStyle(
                  color: Colors.grey, // Sesuaikan dengan warna tema
                ),
                children: [
                  TextSpan(
                    text: "Register disini",
                    style: TextStyle(
                      color: Colors.blue, // Sesuaikan dengan warna tema
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
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
