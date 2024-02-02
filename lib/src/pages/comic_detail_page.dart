import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:komikcast_app/src/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/comicDetailData.dart';
import 'comic_reader_page.dart';
import 'package:http/http.dart' as http;

class ComicDetailPage extends StatefulWidget {
  final String comicHref;
  final String comicChapter;

  ComicDetailPage({required this.comicHref, required this.comicChapter});

  @override
  _ComicDetailPageState createState() => _ComicDetailPageState();
}

class _ComicDetailPageState extends State<ComicDetailPage> {
  late Future<Map<String, dynamic>> _comicDetails;
  bool isLiked = false; // Track whether the comic is liked or not

  @override
  void initState() {
    super.initState();
    _comicDetails = _fetchComicDetails();
  }

  Future<Map<String, dynamic>> _fetchComicDetails() async {
    // Assume ComicDetailData class is defined and works as expected
    final detailData = ComicDetailData(
        apiUrl: 'https://komikcast-api.vercel.app/detail${widget.comicHref}');
    return detailData.fetchComicDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: _comicDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Text(snapshot.data!['data']['title']);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _comicDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final comicDetails = snapshot.data!['data'];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          isLiked = !isLiked;
                        });
                        _sendLikeStatus(comicDetails);
                      },
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.network(
                            comicDetails['thumbnail'],
                            height: 350,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Rating: ${comicDetails['rating']}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Status: ${comicDetails['status']}'),
                    Text('Type: ${comicDetails['type']}'),
                    Text('Released: ${comicDetails['released']}'),
                    Text('Author: ${comicDetails['author']}'),
                    SizedBox(height: 16),
                    Text('Genres:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: [
                        for (var genre in comicDetails['genre'])
                          Chip(
                            label: Text(genre['title']),
                          ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text('Description:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(comicDetails['description']),
                    SizedBox(height: 16),
                    Text('Chapters:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    for (var chapter in comicDetails['chapter'])
                      ListTile(
                        title: Text(chapter['title']),
                        subtitle: Text(chapter['date']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ComicReaderPage(
                                chapterHref: chapter['href'],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              );
            }
          },
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
        'type': comic['type'],
        'chapter': widget.comicChapter,
        'rating': comic['rating'],
        'href': widget.comicHref,
        'thumbnail': comic['thumbnail'],
      };

      // Send a POST request to your server's postComic endpoint
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
