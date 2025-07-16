// Import thư viện Flutter cần thiết
import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Import màn hình đăng nhập làm màn hình đầu tiên

// Hàm main - điểm bắt đầu của ứng dụng Flutter
void main() {
  runApp(const MovieApp()); // Chạy widget gốc MovieApp
}

/// Widget gốc của ứng dụng
class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App', // Tên ứng dụng
      debugShowCheckedModeBanner: false, // Tắt banner "Debug" góc trên phải

      // Thiết lập theme tổng thể cho app
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255), // Nền trắng cho toàn bộ app

        primaryColor: const Color(0xFFFFFFFF), // Màu chính là trắng (dù không được dùng nhiều trong Flutter Material)

        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFE50914), // Màu đỏ đậm (có thể dùng cho nút chính)
          secondary: Colors.white,          // Màu phụ là trắng
        ),

        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 86, 179, 233), // Màu AppBar
          foregroundColor: Colors.white, // Màu chữ/icon trong AppBar
          elevation: 0,
        ),

        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF1E1E1E), // Nền ô input (đen nhạt)
          labelStyle: TextStyle(color: Colors.grey), // Màu chữ label
          border: OutlineInputBorder(), // Viền cho input
        ),
      ),

      // Màn hình đầu tiên khi chạy app
      home: const LoginScreen(),
    );
  }
}
