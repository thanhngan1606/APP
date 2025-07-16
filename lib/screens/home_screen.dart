// Import các package cần thiết
import 'package:flutter/material.dart';
import '../service/api_service.dart';
import 'movie_detail_screen.dart';
import 'add_movie_screen.dart';
import 'login_screen.dart';

/// Màn hình chính hiển thị danh sách phim
class HomeScreen extends StatefulWidget {
  final String token; // Token xác thực người dùng
  final String email; // Email người dùng để kiểm tra quyền admin

  const HomeScreen({super.key, required this.token, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> _moviesFuture; // Future lưu danh sách phim

  // Kiểm tra người dùng có phải admin hay không (chỉ admin mới được thêm/sửa phim)
  bool get isAdmin => widget.email == 'mei@email.com';

  @override
  void initState() {
    super.initState();
    _loadMovies(); // Load danh sách phim khi khởi tạo màn hình
  }

  // Hàm gọi API để lấy danh sách phim
  void _loadMovies() {
    _moviesFuture = ApiService.getAllMovies();
  }

  // Hàm reload danh sách phim sau khi thêm/sửa phim
  Future<void> _refreshMovies() async {
    setState(() {
      _loadMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Thanh AppBar phía trên
      appBar: AppBar(
        title: const Text('🎬 Movie App'),
        actions: [
          // Nếu là admin thì hiện nút thêm phim
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                // Mở màn hình thêm phim
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddMovieScreen(token: widget.token),
                  ),
                );
                _refreshMovies(); // Reload sau khi thêm phim
              },
            ),
          // Nút đăng xuất
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),

      // Phần nội dung chính dùng FutureBuilder để chờ load dữ liệu phim
      body: FutureBuilder<List<dynamic>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          // Khi đang loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 54, 174, 244),
              ),
            );
          }
          // Khi có lỗi
          else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          // Khi không có dữ liệu
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có phim nào.'));
          }

          // Khi có dữ liệu phim
          final movies = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 cột
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: movies.length,
            itemBuilder: (_, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () async {
                  // Khi người dùng nhấn vào một phim, điều hướng sang màn hình chi tiết
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailScreen(
                        id: movie['id'],         // ID phim
                        token: widget.token,     // Token người dùng
                        isAdmin: isAdmin,        // Kiểm tra quyền
                        movie: movie,            // Dữ liệu phim
                      ),
                    ),
                  );
                  _refreshMovies(); // Reload danh sách sau khi quay về
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 59, 138, 228),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color.fromARGB(255, 81, 168, 240),
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hiển thị ảnh phim
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: movie['imageUrl'] != null &&
                              movie['imageUrl'].toString().isNotEmpty
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              movie['imageUrl'],
                              fit: BoxFit.cover,
                            ),
                          )
                              : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              // Ảnh mặc định nếu không có ảnh
                              'https://simg.zalopay.com.vn/zlp-website/assets/phim_trung_hay_60_426502c2bb.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Tên phim
                      Text(
                        movie['name'] ?? 'Không rõ tên',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Ngôn ngữ phim
                      Text(
                        'Ngôn ngữ: ${movie['language'] ?? 'Không rõ'}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
