import 'dart:async';
import 'package:flutter/material.dart';
import 'package:komikcast_app/src/pages/login_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToMainScreen();
  }

  Future<void> _navigateToMainScreen() async {
    await Future.delayed(Duration(seconds: 2)); // Tunda selama 2 detik
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) => LoginPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlutterLogo(
          size: 200.0,
        ),
      ),
    );
  }
}
