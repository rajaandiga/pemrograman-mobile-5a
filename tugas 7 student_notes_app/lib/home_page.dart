import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'note.dart';
import 'note_form_page.dart';
import 'storage_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> _notes = [];
  String _selectedCategory = 'Semua';
  bool _isLoading = true; // Untuk loading indicator

  final List<String> _categories = [
    'Semua',
    'Kuliah',
    'Organisasi',
    'Pribadi',
    'Lain-lain'
  ];

  @override
  void initState() {
    super.initState();
    _loadNotesFromStorage(); // Muat data saat aplikasi dibuka
  }

  // Fungsi untuk memuat catatan dari SharedPreferences
  Future<void> _loadNotesFromStorage() async {
    setState(() {
      _isLoading = true;
    });

    final loadedNotes = await StorageService.loadNotes();

    setState(() {
      _notes = loadedNotes;
      _isLoading = false;
    });
  }

  // Fungsi untuk menyimpan catatan ke SharedPreferences
  Future<void> _saveNotesToStorage() async {
    await StorageService.saveNotes(_notes);
  }

  // Fungsi untuk menambah catatan baru
  Future<void> _addNote() async {
    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(
        builder: (context) => const NoteFormPage(),
      ),
    );

    if (result != null) {
      setState(() {
        _notes.add(result);
      });
      await _saveNotesToStorage(); // Simpan setelah tambah

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Catatan berhasil ditambahkan')),
        );
      }
    }
  }

  // Fungsi untuk mengedit catatan
  Future<void> _editNote(int index) async {
    final current = _notes[index];
    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(
        builder: (context) => NoteFormPage(existingNote: current),
      ),
    );

    if (result != null) {
      setState(() {
        _notes[index] = result;
      });
      await _saveNotesToStorage(); // Simpan setelah edit

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Catatan berhasil diperbarui')),
        );
      }
    }
  }

  // Fungsi untuk menghapus catatan
  void _deleteNote(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('🗑️ Konfirmasi Hapus'),
        content: const Text('Yakin ingin menghapus catatan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                _notes.removeAt(index);
              });
              await _saveNotesToStorage(); // Simpan setelah hapus

              Navigator.pop(context);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('🗑️ Catatan dihapus')),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menghapus semua catatan
  void _deleteAllNotes() {
    if (_notes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Tidak ada catatan untuk dihapus')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('🗑️ Hapus Semua'),
        content: Text('Yakin ingin menghapus semua ${_notes.length} catatan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                _notes.clear();
              });
              await StorageService.clearAllNotes();

              Navigator.pop(context);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('🗑️ Semua catatan dihapus')),
                );
              }
            },
            child: const Text('Hapus Semua', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk memfilter catatan berdasarkan kategori
  List<Note> _getFilteredNotes() {
    if (_selectedCategory == 'Semua') {
      return _notes;
    }
    return _notes.where((note) => note.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotes = _getFilteredNotes();

    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Catatan Tugas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Dropdown untuk filter kategori
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: DropdownButton<String>(
              value: _selectedCategory,
              icon: const Icon(Icons.filter_list),
              underline: const SizedBox(),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
            ),
          ),
          // Menu untuk hapus semua
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'delete_all') {
                _deleteAllNotes();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'delete_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Hapus Semua'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : filteredNotes.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.note_add, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _selectedCategory == 'Semua'
                  ? 'Belum ada catatan.\nTekan tombol + untuk menambah.'
                  : 'Tidak ada catatan untuk kategori $_selectedCategory',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: filteredNotes.length,
        itemBuilder: (context, index) {
          final originalIndex = _notes.indexOf(filteredNotes[index]);
          final note = filteredNotes[index];

          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                child: Text(
                  note.getIcon(),
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              title: Text(
                note.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    note.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd MMM yyyy, HH:mm').format(note.date),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          note.category,
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () => _editNote(originalIndex),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteNote(originalIndex),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNote,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Catatan'),
      ),
    );
  }
}