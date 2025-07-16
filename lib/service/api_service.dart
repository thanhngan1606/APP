import 'dart:convert';               // Để mã hóa/giải mã JSON
import 'package:http/http.dart' as http;  // Thư viện gửi HTTP request

class ApiService {
  // Base URL của server
  static const String baseUrl = 'http://exceit20122-001-site1.qtempurl.com';

  /// Đăng nhập người dùng, trả về access_token nếu thành công
  static Future<String?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/users/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "Password": password, // ⚠️ Chữ "Password" viết hoa theo API backend
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['access_token'];
    }
    return null; // Trả về null nếu login thất bại
  }

  /// Lấy toàn bộ danh sách phim (không cần token)
  static Future<List<dynamic>> getAllMovies() async {
    final url = Uri.parse('$baseUrl/api/movies/AllMovies');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Không thể lấy danh sách phim");
  }

  /// Lấy chi tiết phim theo ID (yêu cầu token)
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

  /// Thêm phim mới (yêu cầu token)
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

  /// Cập nhật phim (PUT) – yêu cầu token
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
