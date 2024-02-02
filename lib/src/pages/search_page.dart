import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/comic_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  _fetchSearchResults(String keyword) async {
    final apiUrl = 'https://komikcast-api.vercel.app/search?keyword=$keyword';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      setState(() {
        _searchResults = List<Map<String, dynamic>>.from(data);
      });
    } else {
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32))),
              hintText: 'Enter keyword...',
              prefixIcon: Icon(Icons.search),
            ),
            onSubmitted: (value) {
              _fetchSearchResults(value);
            },
          ),
        ),
        Expanded(
          child: _searchResults.isNotEmpty
              ? ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return ComicCard(
                      comic: _searchResults[index],
                      cardSize: 300,
                    );
                  },
                )
              : Center(
                  child: Text('No results found'),
                ),
        ),
      ],
    );
  }
}
