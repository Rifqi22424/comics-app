import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:komikcast_app/src/pages/comic_detail_page.dart';

class GenrePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GenreList(),
    );
  }
}

class GenreList extends StatefulWidget {
  @override
  _GenreListState createState() => _GenreListState();
}

class _GenreListState extends State<GenreList> {
  List<Map<String, dynamic>> _genres = [];
  String? _selectedGenre; // Initialize with an empty string

  List<Map<String, dynamic>> _genreComics = [];

  @override
  void initState() {
    super.initState();
    _fetchGenres();
  }

  _fetchGenres() async {
    const apiUrl = 'https://komikcast-api.vercel.app/genre';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      setState(() {
        _genres = List<Map<String, dynamic>>.from(data);
        // if (_genres.isNotEmpty) {
        //   // Set the initial value to the first genre
        //   // _selectedGenre = _genres[1]['title'];
        //   // _fetchGenreComics(_selectedGenre);
        // }
      });
    } else {
      throw Exception('Failed to load genres');
    }
  }

  _fetchGenreComics(String genre) async {
    final apiUrl = 'https://komikcast-api.vercel.app/genre/$genre?page=1';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      setState(() {
        _genreComics = List<Map<String, dynamic>>.from(data);
      });
    } else {
      throw Exception('Failed to load genre comics');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              // Tambahkan logika ketika dropdown ditekan (opsional)
              print("Dropdown Pressed");
            },
            child: DropdownButton<String>(
              hint: Text('Select Genre'),
              value: _selectedGenre,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGenre = newValue!;
                  _fetchGenreComics(_selectedGenre!);
                });
              },
              items: _genres
                  .where((genre) => genre['title'] != 'Shounen Ai (14)')
                  .map((Map<String, dynamic> genre) {
                return DropdownMenuItem<String>(
                  value: genre['href'],
                  child: Text(genre['title']),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          child: _genreComics.isNotEmpty
              ? ListView.builder(
                  itemCount: _genreComics.length,
                  itemBuilder: (context, index) {
                    return ComicCard(comic: _genreComics[index]);
                  },
                )
              : Center(
                  child: Text('No comics found for the selected genre'),
                ),
        ),
      ],
    );
  }
}

class ComicCard extends StatelessWidget {
  final Map<String, dynamic> comic;

  ComicCard({required this.comic});

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
              height: 300,
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
