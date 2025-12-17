import 'dart:convert'; // Untuk encode/decode JSON
import 'package:http/http.dart' as http; // Package untuk HTTP request
import '../models/book.dart';

class ApiService {
  // Base URL Google Books API
  static const String baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  // Method untuk search buku berdasarkan keyword
  // async = fungsi yang berjalan secara asynchronous (tidak blocking)
  // Future<List<Book>> = fungsi ini akan return List<Book> di masa depan
  Future<List<Book>> searchBooks(String query) async {
    try {
      // Buat URL lengkap dengan query parameter
      // q = query parameter untuk search
      // maxResults = batasi hasil maksimal 20 buku
      final url = Uri.parse('$baseUrl?q=$query&maxResults=20');

      // Kirim GET request ke API
      // await = tunggu sampai request selesai
      final response = await http.get(url).timeout(
        const Duration(seconds: 15), // Timeout 15 detik
        onTimeout: () {
          throw Exception('Koneksi timeout. Periksa koneksi internet Anda.');
        },
      );

      // Cek status code response
      if (response.statusCode == 200) {
        // 200 = OK, request berhasil

        // Decode JSON string menjadi Map
        final Map<String, dynamic> data = json.decode(response.body);

        // Ambil array 'items' dari response
        final List items = data['items'] ?? [];

        // Kalau tidak ada hasil
        if (items.isEmpty) {
          return [];
        }

        // Convert setiap item JSON menjadi object Book
        // map() = looping untuk transform setiap element
        // toList() = convert hasil map menjadi List
        return items.map((item) => Book.fromJson(item)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('Buku tidak ditemukan');
      } else if (response.statusCode >= 500) {
        throw Exception('Server sedang bermasalah. Coba lagi nanti.');
      } else {
        throw Exception('Terjadi kesalahan. Kode: ${response.statusCode}');
      }
    } on http.ClientException {
      // Error koneksi internet
      throw Exception('Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.');
    } on FormatException {
      // Error parsing JSON
      throw Exception('Data tidak valid dari server');
    } catch (e) {
      // Catch semua error lainnya
      String errorMessage = e.toString();

      // Bersihkan error message agar lebih user-friendly
      if (errorMessage.contains('SocketException') ||
          errorMessage.contains('Failed host lookup')) {
        throw Exception('Tidak dapat terhubung ke internet. Pastikan Anda online.');
      } else if (errorMessage.contains('TimeoutException') ||
          errorMessage.contains('timeout')) {
        throw Exception('Koneksi terlalu lama. Periksa kecepatan internet Anda.');
      } else if (errorMessage.contains('Exception:')) {
        // Kalau sudah ada format Exception: dari kita, langsung throw
        rethrow;
      } else {
        throw Exception('Terjadi kesalahan tidak terduga. Coba lagi.');
      }
    }
  }

  // Method untuk get detail buku berdasarkan ID
  Future<Book> getBookById(String bookId) async {
    try {
      final url = Uri.parse('$baseUrl/$bookId');
      final response = await http.get(url).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Koneksi timeout. Coba lagi.');
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Book.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Buku tidak ditemukan');
      } else {
        throw Exception('Gagal memuat detail buku');
      }
    } on http.ClientException {
      throw Exception('Tidak ada koneksi internet');
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains('SocketException')) {
        throw Exception('Tidak dapat terhubung ke internet');
      } else if (errorMessage.contains('Exception:')) {
        rethrow;
      } else {
        throw Exception('Terjadi kesalahan tidak terduga');
      }
    }
  }

  // Method untuk get buku populer (default search)
  Future<List<Book>> getPopularBooks() async {
    // Gunakan query 'flutter' sebagai contoh untuk get buku populer
    // Anda bisa ganti dengan keyword lain seperti 'bestseller', 'fiction', dll
    return await searchBooks('fiction');
  }
}