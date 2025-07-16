import 'package:flutter/material.dart';
import '../service/api_service.dart';
import 'edit_movie_screen.dart';

class MovieDetailScreen extends StatefulWidget {
  final int id;
  final String token;
  final bool isAdmin;
  final Map<String, dynamic> movie;

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
  Map<String, dynamic>? detail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

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
          if (widget.isAdmin)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditMovieScreen(
                      movie: detail ?? widget.movie,
                      token: widget.token,
                    ),
                  ),
                );

                if (updated == true) {
                  fetchDetail(); // reload lại thông tin phim
                }
              },
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            detail?['imageUrl'] != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                detail!['imageUrl'],
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
                : Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.broken_image, size: 60, color: Colors.redAccent),
            ),
            const SizedBox(height: 20),
            Text(
              detail?['name'] ?? 'Không rõ tên',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.language, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text('Ngôn ngữ: ${detail?['language'] ?? '-'}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text('Đánh giá: ${detail?['rating'] ?? '-'}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text('Giá vé: \$${detail?['ticketPrice'] ?? '0'}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.date_range, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text('Ngày chiếu: ${detail?['playingDate']?.toString().substring(0, 10) ?? '-'}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text('Giờ chiếu: ${detail?['playingTime']?.toString().substring(11, 16) ?? '-'}'),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Mô tả:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(
              detail?['description'] ?? 'Không có mô tả.',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
