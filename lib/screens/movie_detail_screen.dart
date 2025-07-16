// Import các package cần thiết
import 'package:flutter/material.dart';
import '../service/api_service.dart';
import 'edit_movie_screen.dart';

/// Màn hình chi tiết phim
class MovieDetailScreen extends StatefulWidget {
  final int id;                          // ID của phim
  final String token;                    // Token xác thực người dùng
  final bool isAdmin;                    // Xác định quyền admin
  final Map<String, dynamic> movie;     // Dữ liệu phim (tạm thời)

  const MovieDetailScreen({
    super.key,
    required this.id,
    required this.token,
    required this.isAdmin,
    required this.movie,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  Map<String, dynamic>? detail; // Dữ liệu chi tiết phim từ API
  bool isLoading = true;        // Trạng thái tải dữ liệu

  @override
  void initState() {
    super.initState();
    fetchDetail(); // Gọi API lấy chi tiết phim khi mở màn hình
  }

  // Hàm gọi API để lấy chi tiết phim
  Future<void> fetchDetail() async {
    try {
      final res = await ApiService.getMovieDetail(widget.id, widget.token);
      setState(() {
        detail = res;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Hiển thị lỗi nếu API thất bại
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải chi tiết: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📽 Chi tiết phim'),
        actions: [
          // Nếu là admin thì hiển thị nút sửa
          if (widget.isAdmin)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                // Điều hướng sang màn hình chỉnh sửa phim
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditMovieScreen(
                      movie: detail ?? widget.movie,
                      token: widget.token,
                    ),
                  ),
                );

                // Nếu sửa thành công thì reload lại dữ liệu
                if (updated == true) {
                  fetchDetail();
                }
              },
            ),
        ],
      ),

      // Nội dung chính
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.red),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị ảnh phim hoặc ảnh mặc định
            detail?['imageUrl'] != null &&
                (detail?['imageUrl'] as String).isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                detail!['imageUrl'],
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://simg.zalopay.com.vn/zlp-website/assets/phim_trung_hay_60_426502c2bb.jpg',
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Tên phim
            Text(
              detail?['name'] ?? 'Không rõ tên',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),

            // Ngôn ngữ
            Row(
              children: [
                const Icon(Icons.language, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text(
                  'Ngôn ngữ: ${detail?['language'] ?? '-'}',
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Đánh giá
            Row(
              children: [
                const Icon(Icons.star, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text(
                  'Đánh giá: ${detail?['rating'] ?? '-'}',
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Giá vé
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text(
                  'Giá vé: \$${detail?['ticketPrice'] ?? '0'}',
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Ngày chiếu
            Row(
              children: [
                const Icon(Icons.date_range, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text(
                  'Ngày chiếu: ${detail?['playingDate']?.toString().substring(0, 10) ?? '-'}',
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Giờ chiếu
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text(
                  'Giờ chiếu: ${detail?['playingTime']?.toString().substring(11, 16) ?? '-'}',
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Mô tả phim
            const Text(
              'Mô tả:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              detail?['description'] ?? 'Không có mô tả.',
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
