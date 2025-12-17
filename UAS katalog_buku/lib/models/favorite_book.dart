// Model untuk buku favorit yang disimpan di database SQLite

class FavoriteBook {
  final int? id;          // ID dari database (auto increment), nullable karena baru dapat setelah insert
  final String bookId;    // ID buku dari API
  final String title;     // Judul buku
  final String authors;   // Penulis (disimpan sebagai string, dipisah koma)
  final String? thumbnail; // URL gambar cover
  final String? note;     // Catatan pribadi user tentang buku ini
  final String addedDate; // Tanggal ditambahkan ke favorit

  // Constructor
  FavoriteBook({
    this.id,
    required this.bookId,
    required this.title,
    required this.authors,
    this.thumbnail,
    this.note,
    required this.addedDate,
  });

  // Convert dari Map (hasil query SQLite) ke object FavoriteBook
  factory FavoriteBook.fromMap(Map<String, dynamic> map) {
    return FavoriteBook(
      id: map['id'],
      bookId: map['bookId'],
      title: map['title'],
      authors: map['authors'],
      thumbnail: map['thumbnail'],
      note: map['note'],
      addedDate: map['addedDate'],
    );
  }

  // Convert object FavoriteBook ke Map (untuk insert/update ke SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'title': title,
      'authors': authors,
      'thumbnail': thumbnail,
      'note': note,
      'addedDate': addedDate,
    };
  }

  // Method untuk print info buku (untuk debugging)
  @override
  String toString() {
    return 'FavoriteBook{id: $id, title: $title, authors: $authors}';
  }
}