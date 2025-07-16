import 'package:flutter/material.dart';
import '../service/api_service.dart';

class AddMovieScreen extends StatefulWidget {
  final String token;
  const AddMovieScreen({super.key, required this.token});

  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final imageCtrl = TextEditingController();

  void handleAdd() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ApiService.addMovie(
      token: widget.token,
      name: nameCtrl.text,
      imageUrl: imageCtrl.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 Thêm phim thành công')),
      );

      // Chờ 1 giây rồi quay về màn Home
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Thêm phim thất bại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Thêm phim mới')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Tên phim'),
                validator: (val) => val!.isEmpty ? 'Không để trống' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: imageCtrl,
                decoration: const InputDecoration(labelText: 'URL hình ảnh (tuỳ chọn)'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: handleAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Thêm phim', style: TextStyle(fontSize: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
