import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://exceit20122-001-site1.qtempurl.com';

  static Future<String?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/users/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "Password": password}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['access_token'];
    }
    return null;
  }

  static Future<List<dynamic>> getAllMovies() async {
    final url = Uri.parse('$baseUrl/api/movies/AllMovies');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Không thể lấy danh sách phim");
  }

  static Future<Map<String, dynamic>> getMovieDetail(int id, String token) async {
    final url = Uri.parse('$baseUrl/api/movies/MovieDetail/$id');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Không thể lấy chi tiết phim");
  }

  static Future<bool> addMovie({
    required String token,
    required String name,
    required String imageUrl,
  }) async {
    final url = Uri.parse('$baseUrl/api/movies/');
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..fields['imageUrl'] = imageUrl;

    final response = await request.send();
    return response.statusCode == 200;
  }

  static Future<bool> editMovie({
    required String token,
    required int id,
    required String name,
    required String language,
    required int rating,
    required double ticketPrice,
    required String imageUrl,
  }) async {
    final url = Uri.parse('$baseUrl/api/movies/$id');
    final request = http.MultipartRequest('PUT', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..fields['language'] = language
      ..fields['rating'] = rating.toString()
      ..fields['ticketPrice'] = ticketPrice.toString()
      ..fields['imageUrl'] = imageUrl;

    final response = await request.send();
    return response.statusCode == 200;
  }
}
