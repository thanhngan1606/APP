// Import thư viện Flutter và service API
import 'package:flutter/material.dart';
import '../service/api_service.dart';

/// Màn hình sửa thông tin phim (chỉ dành cho Admin)
class EditMovieScreen extends StatefulWidget {
  final Map<String, dynamic> movie; // Dữ liệu phim được truyền vào
  final String token; // Token xác thực

  const EditMovieScreen({
    super.key,
    required this.movie,
    required this.token,
  });

  @override
  State<EditMovieScreen> createState() => _EditMovieScreenState();
}

class _EditMovieScreenState extends State<EditMovieScreen> {
  // Form key để validate form
  final _formKey = GlobalKey<FormState>();

  // Các controller cho các trường nhập liệu
  late TextEditingController nameCtrl;
  late TextEditingController languageCtrl;
  late TextEditingController ratingCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController imageCtrl;

  @override
  void initState() {
    super.initState();

    // Khởi tạo controller với giá trị hiện tại của phim
    nameCtrl = TextEditingController(text: widget.movie['name'] ?? '');
    languageCtrl = TextEditingController(text: widget.movie['language'] ?? '');
    ratingCtrl = TextEditingController(
      text: widget.movie['rating']?.toString() ?? '0',
    );
    priceCtrl = TextEditingController(
      text: widget.movie['ticketPrice']?.toString() ?? '0',
    );
    imageCtrl = TextEditingController(text: widget.movie['imageUrl'] ?? '');
  }

  /// Hàm xử lý cập nhật phim khi nhấn nút
  void handleEdit() async {
    // Nếu form không hợp lệ thì thoát
    if (!_formKey.currentState!.validate()) return;

    // Gửi dữ liệu lên API để cập nhật phim
    final success = await ApiService.editMovie(
      token: widget.token,
      id: widget.movie['id'],
      name: nameCtrl.text,
      language: languageCtrl.text,
      rating: int.tryParse(ratingCtrl.text) ?? 0,
      ticketPrice: double.tryParse(priceCtrl.text) ?? 0,
      imageUrl: imageCtrl.text,
    );

    if (success) {
      // Nếu thành công, hiển thị thông báo và quay lại màn trước
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Cập nhật phim thành công')),
      );
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.pop(context);
    } else {
      // Nếu thất bại, hiển thị lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Sửa phim thất bại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('✏️ Sửa phim'),
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

              // Trường nhập ngôn ngữ phim
              TextFormField(
                controller: languageCtrl,
                decoration: const InputDecoration(
                  labelText: 'Ngôn ngữ',
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
              const SizedBox(height: 12),

              // Trường nhập đánh giá phim
              TextFormField(
                controller: ratingCtrl,
                decoration: const InputDecoration(
                  labelText: 'Đánh giá (1-5)',
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
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              // Trường nhập giá vé
              TextFormField(
                controller: priceCtrl,
                decoration: const InputDecoration(
                  labelText: 'Giá vé',
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
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              // Trường nhập URL ảnh phim
              TextFormField(
                controller: imageCtrl,
                decoration: const InputDecoration(
                  labelText: 'URL hình ảnh',
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

              // Nút cập nhật phim
              ElevatedButton(
                onPressed: handleEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'Cập nhật phim',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
