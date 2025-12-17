class Note {
  String title;           // Judul catatan
  String content;         // Isi catatan
  DateTime date;          // Tanggal dibuat
  String category;        // Kategori: Kuliah, Organisasi, Pribadi, Lain-lain

  Note({
    required this.title,
    required this.content,
    required this.date,
    required this.category,
  });

  // Mengubah Note menjadi Map (untuk disimpan ke SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'category': category,
    };
  }

  // Membuat Note dari Map (untuk diambil dari SharedPreferences)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      category: map['category'] ?? 'Lain-lain',
    );
  }

  // Mendapatkan ikon berdasarkan kategori
  String getIcon() {
    switch (category) {
      case 'Kuliah':
        return '📚';
      case 'Organisasi':
        return '🤝';
      case 'Pribadi':
        return '🏠';
      default:
        return '✨';
    }
  }
}