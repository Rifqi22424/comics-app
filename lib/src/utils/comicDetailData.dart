import 'dart:convert';
import 'package:http/http.dart' as http;

class ComicDetailData {
  final String apiUrl;

  ComicDetailData({required this.apiUrl});

  Future<Map<String, dynamic>> fetchComicDetails() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load comic details');
    }
  }
}
