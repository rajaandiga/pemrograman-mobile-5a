import 'package:flutter/material.dart';
import '../models/feedback_model.dart';
import 'feedback_list_page.dart';

class FeedbackFormPage extends StatefulWidget {
  final Function(FeedbackModel) onSubmit;
  final Function() onClear;
  final List<FeedbackModel> feedbackList;

  const FeedbackFormPage({
    super.key,
    required this.onSubmit,
    required this.feedbackList,
    required this.onClear,
  });

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  double _rating = 3;
  String _selectedCategory = 'Umum';
  bool _allowPublish = false;

  final Map<String, IconData> _categoryIcons = {
    'Umum': Icons.info_outline,
    'UI/UX': Icons.design_services,
    'Kinerja': Icons.speed,
    'Bug': Icons.bug_report,
    'Lainnya': Icons.more_horiz,
  };

  final List<String> _categories = ['Umum', 'UI/UX', 'Kinerja', 'Bug', 'Lainnya'];

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newFeedback = FeedbackModel(
        name: _nameController.text.trim(),
        comment: _commentController.text.trim(),
        rating: _rating,
        category: _selectedCategory,
        allowPublish: _allowPublish,
        date: DateTime.now(),
      );

      widget.onSubmit(newFeedback);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback berhasil dikirim!')),
      );

      _nameController.clear();
      _commentController.clear();
      setState(() {
        _rating = 3;
        _selectedCategory = 'Umum';
        _allowPublish = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FeedbackListPage(
            feedbackList: widget.feedbackList,
            onClear: widget.onClear,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berikan Masukan Anda'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nama
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Komentar
              TextFormField(
                controller: _commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Komentar',
                  prefixIcon: const Icon(Icons.comment_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Komentar wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Kategori
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((cat) => DropdownMenuItem(
                  value: cat,
                  child: Row(
                    children: [
                      Icon(_categoryIcons[cat], color: Colors.indigo),
                      const SizedBox(width: 8),
                      Text(cat),
                    ],
                  ),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value!),
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),

              // Rating
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rating', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (int i = 1; i <= 5; i++)
                        IconButton(
                          onPressed: () => setState(() => _rating = i.toDouble()),
                          icon: Icon(
                            i <= _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                        ),
                      Text(_rating.toStringAsFixed(0)),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Publish Switch
              SwitchListTile(
                title: const Text('Izinkan tampil secara publik'),
                value: _allowPublish,
                onChanged: (val) => setState(() => _allowPublish = val),
              ),
              const SizedBox(height: 20),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.send),
                      label: const Text('Kirim Feedback'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FeedbackListPage(
                            feedbackList: widget.feedbackList,
                            onClear: widget.onClear,
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.list),
                      label: const Text('Lihat Semua'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF2F5FA),
    );
  }
}
