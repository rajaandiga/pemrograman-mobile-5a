import 'package:flutter/material.dart';
import 'note.dart';

class NoteFormPage extends StatefulWidget {
  final Note? existingNote; // Null jika tambah baru, ada isi jika edit

  const NoteFormPage({super.key, this.existingNote});

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  String _selectedCategory = 'Kuliah'; // Default kategori

  // Daftar pilihan kategori
  final List<String> _categories = [
    'Kuliah',
    'Organisasi',
    'Pribadi',
    'Lain-lain'
  ];

  // Cek apakah mode edit atau tambah baru
  bool get isEditMode => widget.existingNote != null;

  @override
  void initState() {
    super.initState();

    // Jika mode edit, isi form dengan data lama
    _titleController = TextEditingController(
      text: widget.existingNote?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.existingNote?.content ?? '',
    );

    // Set kategori yang sudah ada jika mode edit
    if (widget.existingNote != null) {
      _selectedCategory = widget.existingNote!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // Fungsi untuk menyimpan catatan
  void _saveNote() {
    // Validasi form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Buat object Note baru
    final newNote = Note(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      date: widget.existingNote?.date ?? DateTime.now(), // Pakai tanggal lama jika edit
      category: _selectedCategory,
    );

    // Kembalikan ke halaman sebelumnya dengan membawa data note
    Navigator.pop(context, newNote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? '✏️ Edit Catatan' : '➕ Catatan Baru'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input Judul
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Judul Catatan',
                    hintText: 'Masukkan judul catatan',
                    prefixIcon: const Icon(Icons.title),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '⚠️ Judul wajib diisi';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Dropdown Kategori
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                  ),
                  items: _categories.map((String category) {
                    // Dapatkan icon untuk setiap kategori
                    String icon = '';
                    switch (category) {
                      case 'Kuliah':
                        icon = '📚';
                        break;
                      case 'Organisasi':
                        icon = '🤝';
                        break;
                      case 'Pribadi':
                        icon = '🏠';
                        break;
                      default:
                        icon = '✨';
                    }

                    return DropdownMenuItem<String>(
                      value: category,
                      child: Row(
                        children: [
                          Text(icon, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(category),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // Input Isi Catatan
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: 'Isi Catatan',
                    hintText: 'Tulis catatan Anda di sini...',
                    prefixIcon: const Icon(Icons.notes, size: 24),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    alignLabelWithHint: true,
                  ),
                  maxLines: 10,
                  minLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '⚠️ Isi catatan tidak boleh kosong';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Tombol Simpan
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: _saveNote,
                    icon: const Icon(Icons.save),
                    label: Text(
                      isEditMode ? 'Simpan Perubahan' : 'Simpan Catatan',
                      style: const TextStyle(fontSize: 16),
                    ),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Tombol Batal
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.cancel),
                    label: const Text(
                      'Batal',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}