import 'package:flutter/material.dart';
import '../service/api_service.dart';

class EditMovieScreen extends StatefulWidget {
  final Map<String, dynamic> movie;
  final String token;
  const EditMovieScreen({super.key, required this.movie, required this.token});

  @override
  State<EditMovieScreen> createState() => _EditMovieScreenState();
}

class _EditMovieScreenState extends State<EditMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl;
  late TextEditingController languageCtrl;
  late TextEditingController ratingCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController imageCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.movie['name'] ?? '');
    languageCtrl = TextEditingController(text: widget.movie['language'] ?? '');
    ratingCtrl = TextEditingController(text: widget.movie['rating']?.toString() ?? '0');
    priceCtrl = TextEditingController(text: widget.movie['ticketPrice']?.toString() ?? '0');
    imageCtrl = TextEditingController(text: widget.movie['imageUrl'] ?? '');
  }

  void handleEdit() async {
    if (!_formKey.currentState!.validate()) return;

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Cập nhật phim thành công')),
      );
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Sửa phim thất bại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('✏️ Sửa phim')),
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
                controller: languageCtrl,
                decoration: const InputDecoration(labelText: 'Ngôn ngữ'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: ratingCtrl,
                decoration: const InputDecoration(labelText: 'Đánh giá (1-5)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'Giá vé'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: imageCtrl,
                decoration: const InputDecoration(labelText: 'URL hình ảnh'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: handleEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Cập nhật phim', style: TextStyle(fontSize: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
