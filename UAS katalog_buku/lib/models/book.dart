// Model untuk data buku yang diambil dari Google Books API

class Book {
  final String id;           // ID unik buku dari API
  final String title;        // Judul buku
  final List<String> authors; // Penulis buku (bisa lebih dari 1)
  final String? description; // Deskripsi buku (bisa null)
  final String? thumbnail;   // URL gambar cover buku (bisa null)
  final String? publishedDate; // Tanggal terbit
  final int? pageCount;      // Jumlah halaman
  final double? averageRating; // Rating rata-rata

  // Constructor - cara membuat object Book
  Book({
    required this.id,
    required this.title,
    required this.authors,
    this.description,
    this.thumbnail,
    this.publishedDate,
    this.pageCount,
    this.averageRating,
  });

  // Factory method untuk convert dari JSON API ke object Book
  // JSON dari API bentuknya Map<String, dynamic>
  factory Book.fromJson(Map<String, dynamic> json) {
    // Ambil data volumeInfo dari JSON
    final volumeInfo = json['volumeInfo'] ?? {};

    return Book(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'Judul Tidak Tersedia',
      // Authors bisa berupa List, kalau null jadikan list kosong
      authors: volumeInfo['authors'] != null
          ? List<String>.from(volumeInfo['authors'])
          : ['Penulis Tidak Diketahui'],
      description: volumeInfo['description'],
      // Ambil thumbnail dari imageLinks
      thumbnail: volumeInfo['imageLinks']?['thumbnail'],
      publishedDate: volumeInfo['publishedDate'],
      pageCount: volumeInfo['pageCount'],
      averageRating: volumeInfo['averageRating']?.toDouble(),
    );
  }

  // Method untuk convert object Book ke Map (untuk keperluan lain)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'description': description,
      'thumbnail': thumbnail,
      'publishedDate': publishedDate,
      'pageCount': pageCount,
      'averageRating': averageRating,
    };
  }
}