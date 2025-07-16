// Import thư viện Flutter và API service
import 'package:flutter/material.dart';
import '../service/api_service.dart';

/// Màn hình thêm phim mới (chỉ dành cho Admin)
class AddMovieScreen extends StatefulWidget {
  final String token; // Token xác thực gửi từ HomeScreen

  const AddMovieScreen({super.key, required this.token});

  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  // Key dùng để xác thực form
  final _formKey = GlobalKey<FormState>();
  // Controller cho ô nhập tên phim
  final nameCtrl = TextEditingController();
  // Controller cho ô nhập URL ảnh
  final imageCtrl = TextEditingController();

  /// Hàm xử lý thêm phim khi nhấn nút
  void handleAdd() async {
    // Nếu form không hợp lệ thì thoát
    if (!_formKey.currentState!.validate()) return;

    // Gọi API thêm phim
    final success = await ApiService.addMovie(
      token: widget.token,
      name: nameCtrl.text,
      imageUrl: imageCtrl.text,
    );

    if (success) {
      // Thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 Thêm phim thành công')),
      );

      // Chờ 1 giây rồi quay về màn hình trước đó
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.pop(context);
    } else {
      // Thông báo thất bại
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Thêm phim thất bại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Lấy theme hiện tại

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm phim mới'),
        backgroundColor: Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Trường nhập tên phim
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tên phim',
                  labelStyle: TextStyle(color: Color(0xFF1976D2)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1976D2)),
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1976D2), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                ),
                style: const TextStyle(color: Color(0xFF1976D2)),
                cursorColor: Color(0xFF1976D2),
                validator: (val) => val!.isEmpty ? 'Không để trống' : null,
              ),
              const SizedBox(height: 12),
              // Trường nhập URL ảnh phim (tùy chọn)
              TextFormField(
                controller: imageCtrl,
                decoration: const InputDecoration(
                  labelText: 'URL hình ảnh (tuỳ chọn)',
                  labelStyle: TextStyle(color: Color(0xFF1976D2)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1976D2)),
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1976D2), width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                ),
                style: const TextStyle(color: Color(0xFF1976D2)),
                cursorColor: Color(0xFF1976D2),
              ),
              const SizedBox(height: 24),
              // Nút thêm phim
              ElevatedButton(
                onPressed: handleAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
                child: const Text('Thêm phim', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
