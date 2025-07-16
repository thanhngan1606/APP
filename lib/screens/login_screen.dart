// Import thư viện Flutter cần thiết
import 'package:flutter/material.dart';
// Import service để gọi API đăng nhập
import '../service/api_service.dart';
// Import màn hình sau đăng nhập
import 'home_screen.dart';
import 'dart:ui';

/// Widget màn hình đăng nhập cho ứng dụng Movie App
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller cho ô nhập email
  final emailCtrl = TextEditingController();
  // Controller cho ô nhập mật khẩu
  final passCtrl = TextEditingController();
  // Biến dùng để bật/tắt chế độ ẩn mật khẩu
  bool _obscurePass = true;

  /// Hàm xử lý đăng nhập
  void handleLogin() async {
    // Gọi API đăng nhập và nhận token
    final token = await ApiService.login(emailCtrl.text, passCtrl.text);

    // Nếu đăng nhập thành công, chuyển sang HomeScreen
    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(token: token, email: emailCtrl.text),
        ),
      );
    } else {
      // Nếu thất bại, hiển thị SnackBar thông báo lỗi
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đăng nhập thất bại!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Lấy theme hiện tại

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Thiết lập background dạng gradient xanh nước biển
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF90CAF9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // Canh giữa nội dung
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 370,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              // Giao diện các thành phần trong form đăng nhập
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  // Icon tiêu đề ứng dụng
                  const Center(
                    child: Icon(
                      Icons.movie_filter_rounded,
                      size: 60,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Tiêu đề chào mừng
                  Text(
                    "Chào mừng BABI!",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: const Color(0xFF1976D2),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Phụ đề giới thiệu
                  const Text(
                    "Khám phá thế giới trình là gì!!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1976D2),
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Ô nhập email
                  TextField(
                    controller: emailCtrl,
                    style: const TextStyle(color: Color(0xFF1976D2)),
                    cursorColor: Color(0xFF1976D2),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Color(0xFF1976D2),
                      ),
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Color(0xFF1976D2)),
                      filled: true,
                      fillColor: Color(0xFFF3F6FA),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF1976D2)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF1976D2),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  // Ô nhập mật khẩu
                  TextField(
                    controller: passCtrl,
                    obscureText: _obscurePass,
                    style: const TextStyle(color: Color(0xFF1976D2)),
                    cursorColor: Color(0xFF1976D2),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF1976D2),
                      ),
                      labelText: 'Mật khẩu',
                      labelStyle: const TextStyle(color: Color(0xFF1976D2)),
                      filled: true,
                      fillColor: const Color(0xFFF3F6FA),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF1976D2)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF1976D2),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      // Nút hiển thị/ẩn mật khẩu
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePass
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Color(0xFF1976D2),
                        ),
                        onPressed:
                            () => setState(() => _obscurePass = !_obscurePass),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Nút đăng nhập
                  ElevatedButton(
                    onPressed: handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
