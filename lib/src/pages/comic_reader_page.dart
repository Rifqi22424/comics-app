import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ComicReaderPage extends StatefulWidget {
  final String chapterHref;

  ComicReaderPage({required this.chapterHref});

  @override
  _ComicReaderPageState createState() => _ComicReaderPageState();
}

class _ComicReaderPageState extends State<ComicReaderPage> {
  late Future<List<String>> _panelUrls;

  @override
  void initState() {
    super.initState();
    _panelUrls = _fetchPanelUrls();
  }

  Future<List<String>> _fetchPanelUrls() async {
    final response = await http.get(Uri.parse(
        'https://komikcast-api.vercel.app/read${widget.chapterHref}'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'][0]['panel'];
      return List<String>.from(data);
    } else {
      throw Exception('Failed to load panel images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comic Reader'),
      ),
      body: FutureBuilder(
        future: _panelUrls,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final panelUrls = snapshot.data as List<String>;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var url in panelUrls)
                    Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container();
                      },
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
