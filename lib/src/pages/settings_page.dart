// settingsPage.dart

import 'package:flutter/material.dart';
import 'package:komikcast_app/src/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // User Profile Section
          _buildProfileSection(context),
          Divider(), // A line to separate sections

          // Settings Options
          _buildSettingsTile(
            isRed: false,
            context,
            label: 'FAQ',
            onPressed: () {
              _showMessage(context, 'FAQ button pressed');
            },
          ),
          _buildSettingsTile(
            isRed: false,
            context,
            label: 'Report Bug',
            onPressed: () {
              _showMessage(context, 'Report Bug button pressed');
            },
          ),
          _buildSettingsTile(
            isRed: false,
            context,
            label: 'Feedback',
            onPressed: () {
              _showMessage(context, 'Feedback button pressed');
            },
          ),
          _buildSettingsTile(
            isRed: false,
            context,
            label: 'Notifications',
            onPressed: () {
              _showMessage(context, 'Notifications button pressed');
            },
          ),
          _buildSettingsTile(
            isRed: false,
            context,
            label: 'Language',
            onPressed: () {
              _showMessage(context, 'Language button pressed');
            },
          ),
          _buildSettingsTile(
            isRed: false,
            context,
            label: 'Appearance',
            onPressed: () {
              _showMessage(context, 'Appearance button pressed');
            },
          ),
          Divider(), // A line to separ // A line to separate sections

          // Logout Option
          _buildSettingsTile(
            isRed: true,
            context,
            label: 'Logout',
            onPressed: () {
              _showLogoutConfirmation(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    // Menampilkan dialog konfirmasi
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog konfirmasi
                _logout(context); // Lakukan logout setelah konfirmasi
              },
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) async {
    // Hapus semua halaman sebelumnya dari stack
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('userId', 0);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) => LoginPage()), // Ganti dengan halaman login Anda
      (Route<dynamic> route) => false,
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    // Placeholder user information (replace with actual user data)
    String userName = 'John Doe';
    String userEmail = 'john.doe@example.com';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey, // Placeholder color
          radius: 50,
        ),
        SizedBox(height: 10),
        Text(
          userName,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          userEmail,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        SizedBox(height: 20),
        Divider(), // A line to separate sections
      ],
    );
  }

  Widget _buildSettingsTile(BuildContext context,
      {required String label,
      required VoidCallback onPressed,
      required bool isRed}) {
    return isRed
        ? ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              bottomLeft: Radius.circular(32),
            ),
            child: ListTile(
              tileColor: Colors.redAccent,
              title: Text(
                label,
                style: TextStyle(color: isRed ? Colors.white : Colors.black),
              ),
              onTap: onPressed,
            ),
          )
        : ListTile(
            tileColor: Colors.transparent,
            title: Text(
              label,
              style: TextStyle(color: isRed ? Colors.white : Colors.black),
            ),
            onTap: onPressed,
          );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
