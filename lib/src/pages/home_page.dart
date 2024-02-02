import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/comic_card.dart';

class ComicList extends StatefulWidget {
  @override
  State<ComicList> createState() => _ComicListState();
}

class _ComicListState extends State<ComicList> {
  late Future<List<Map<String, dynamic>>> _futureComicsRec;
  late Future<List<Map<String, dynamic>>> _futureComicsPop;

  @override
  void initState() {
    super.initState();
    _futureComicsRec = _fetchComics();
    _futureComicsPop = _fetchComicsPop();
  }

  Future<List<Map<String, dynamic>>> _fetchComics() async {
    final response = await http
        .get(Uri.parse('https://komikcast-api.vercel.app/recommended'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load comics');
    }
  }

  Future<List<Map<String, dynamic>>> _fetchComicsPop() async {
    final response =
        await http.get(Uri.parse('https://komikcast-api.vercel.app/popular'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load comics');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SectionTitle(title: 'Recommended Comics'),
        ComicGrid(futureComics: _futureComicsRec, gridCount: 2),
        SectionTitle(title: 'Popular Comics'),
        ComicGrid(gridCount: 2, futureComics: _futureComicsPop),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ComicGrid extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> futureComics;
  final int gridCount;

  ComicGrid({required this.gridCount, required this.futureComics});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureComics,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final List<Map<String, dynamic>> comics =
              snapshot.data as List<Map<String, dynamic>>;
          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridCount,
              childAspectRatio: 0.6,
            ),
            itemCount: comics.length,
            itemBuilder: (context, index) {
              return ComicCard(
                comic: comics[index],
                cardSize: 150,
              );
            },
          );
        }
      },
    );
  }
}