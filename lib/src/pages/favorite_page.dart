import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:komikcast_app/src/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'comic_detail_page.dart';

class FavoriteList extends StatefulWidget {
  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  Future<List<Map<String, dynamic>>> fetchFavoriteComics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getInt('userId').toString();
    print(userId);
    final apiUrl =
        'http://${AppConfig.ipAddress}:3000/comics/$userId/favorites';
    print(apiUrl);

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load favorite comics');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: fetchFavoriteComics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final List<Map<String, dynamic>> favoriteComics =
                snapshot.data as List<Map<String, dynamic>>;

            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
              ),
              itemCount: favoriteComics.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> comic = favoriteComics[index];
                return FavoriteComicCard(comic: comic);
              },
            );
          }
        },
      ),
    );
  }
}

class FavoriteComicCard extends StatelessWidget {
  final Map<String, dynamic> comic;

  FavoriteComicCard({required this.comic});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ComicDetailPage(
                comicHref: comic['href'], comicChapter: comic['chapter']),
          ),
        );
        print('Comic tapped: ${comic['title']}');
      },
      child: Card(
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              comic['thumbnail'],
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comic['title'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  if (comic.containsKey('rating'))
                    Text('Rating: ${comic['rating']}'),
                  if (comic.containsKey('chapter'))
                    Text('Chapter: ${comic['chapter']}'),
                  if (comic.containsKey('type')) Text('Type: ${comic['type']}'),
                  if (comic.containsKey('genre'))
                    Text('Genre: ${comic['genre']}'),
                  if (comic.containsKey('year')) Text('Year: ${comic['year']}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
