import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_config.dart';
import '../pages/comic_detail_page.dart';


class ComicCard extends StatefulWidget {
  final Map<String, dynamic> comic;
  final double cardSize;

  ComicCard({required this.comic, required this.cardSize});

  @override
  State<ComicCard> createState() => _ComicCardState();
}

class _ComicCardState extends State<ComicCard> {
  bool isLiked = false; // Track whether the comic is liked or not
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ComicDetailPage(
                comicHref: widget.comic['href'], comicChapter: 'Ch.371'),
          ),
        );
        print('Comic tapped: ${widget.comic['title']}');
      },
      child: Card(
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Image.network(
                  widget.comic['thumbnail'],
                  height: widget.cardSize,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                    _sendLikeStatus(widget.comic);
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.comic['title'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  if (widget.comic.containsKey('rating'))
                    Text('Rating: ${widget.comic['rating']}'),
                  if (widget.comic.containsKey('chapter'))
                    Text('Chapter: ${widget.comic['chapter']}'),
                  if (widget.comic.containsKey('type'))
                    Text('Type: ${widget.comic['type']}'),
                  if (widget.comic.containsKey('genre'))
                    Text(
                      'Genre: ${widget.comic['genre']}',
                      style: TextStyle(fontSize: 8),
                    ),
                  if (widget.comic.containsKey('year'))
                    Text('Year: ${widget.comic['year']}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendLikeStatus(final Map<String, dynamic> comic) async {
    try {
      // Extract the comic ID from the comic map
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getInt('userId').toString();
      print(userId);

      // Prepare the request body
      Map<String, dynamic> requestBody = {
        'title': comic['title'],
        'type': comic['type'] ?? 'Manhwa',
        'chapter': comic['chapter'] ?? 'Ch.371',
        'rating': comic['rating'] ?? '7.66',
        'href': comic['href'],
        'thumbnail': comic['thumbnail'],
      };

      // Send a POST request to your server's postComic endpoint
      print('http://${AppConfig.ipAddress}:3000/comics/$userId');
      final response = await http.post(
        Uri.parse('http://${AppConfig.ipAddress}:3000/comics/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Like status sent successfully!');
      } else {
        print(
            'Failed to send like status. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending like status: $error');
    }
  }
}
