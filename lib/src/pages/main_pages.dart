import 'package:flutter/material.dart';

import 'favorite_page.dart';
import 'genre_page.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'settings_page.dart';

class MainScreens extends StatefulWidget {
  @override
  _MainScreensState createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    String appBarTitle = _getAppBarTitle();

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ComicList(),
          SearchPage(),
          GenrePage(),
          FavoriteList(),
          SettingsPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Genre',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        fixedColor: Colors.blue, // Set the color for the selected item
        unselectedItemColor: Colors.grey,
        // showUnselectedLabels: true,
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Komik List';
      case 1:
        return 'Search Komik';
      case 2:
        return 'Genre Komik';
      case 3:
        return 'Favorite Komik';
      case 4:
        return 'Settings';
      default:
        return 'Unknown';
    }
  }
}