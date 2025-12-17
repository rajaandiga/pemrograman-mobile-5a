import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/favorite_book.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';

// ChangeNotifier = class yang bisa memberitahu listener kalau ada perubahan data
class BookProvider extends ChangeNotifier {
  // Instance dari service
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // === STATE VARIABLES ===

  // List buku dari API
  List<Book> _books = [];
  List<Book> get books => _books;

  // List buku favorit dari database
  List<FavoriteBook> _favorites = [];
  List<FavoriteBook> get favorites => _favorites;

  // Loading state untuk tampilkan loading indicator
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Search query
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // === CONSTRUCTOR ===
  BookProvider() {
    // Saat provider pertama kali dibuat, load data
    loadPopularBooks();
    loadFavorites();
  }

  // === METHOD UNTUK API ===

  // Load buku populer dari API
  Future<void> loadPopularBooks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Beritahu UI bahwa state berubah

    try {
      _books = await _apiService.getPopularBooks();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal memuat buku: $e';
      notifyListeners();
    }
  }

  // Search buku berdasarkan keyword
  Future<void> searchBooks(String query) async {
    if (query.isEmpty) {
      // Kalau query kosong, load buku populer
      loadPopularBooks();
      return;
    }

    _searchQuery = query;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _books = await _apiService.searchBooks(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal mencari buku: $e';
      notifyListeners();
    }
  }

  // === METHOD UNTUK DATABASE (CRUD) ===

  // READ - Load semua buku favorit dari database
  Future<void> loadFavorites() async {
    try {
      _favorites = await _dbHelper.getAllFavorites();
      notifyListeners();
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  // CREATE - Tambah buku ke favorit
  Future<void> addToFavorites(Book book, {String? note}) async {
    try {
      final favoriteBook = FavoriteBook(
        bookId: book.id,
        title: book.title,
        authors: book.authors.join(', '), // Gabungkan list authors jadi string
        thumbnail: book.thumbnail,
        note: note,
        addedDate: DateTime.now().toIso8601String(),
      );

      await _dbHelper.insertFavorite(favoriteBook);
      await loadFavorites(); // Reload favorites
      notifyListeners();
    } catch (e) {
      print('Error adding to favorites: $e');
      _errorMessage = 'Gagal menambahkan ke favorit';
      notifyListeners();
    }
  }

  // UPDATE - Update catatan buku favorit
  Future<void> updateFavoriteNote(int id, String note) async {
    try {
      // Cari buku favorit berdasarkan id
      final favorite = _favorites.firstWhere((fav) => fav.id == id);

      // Buat object baru dengan note yang diupdate
      final updatedFavorite = FavoriteBook(
        id: favorite.id,
        bookId: favorite.bookId,
        title: favorite.title,
        authors: favorite.authors,
        thumbnail: favorite.thumbnail,
        note: note,
        addedDate: favorite.addedDate,
      );

      await _dbHelper.updateFavorite(updatedFavorite);
      await loadFavorites(); // Reload favorites
      notifyListeners();
    } catch (e) {
      print('Error updating note: $e');
      _errorMessage = 'Gagal mengupdate catatan';
      notifyListeners();
    }
  }

  // DELETE - Hapus buku dari favorit
  Future<void> removeFromFavorites(String bookId) async {
    try {
      await _dbHelper.deleteFavoriteByBookId(bookId);
      await loadFavorites(); // Reload favorites
      notifyListeners();
    } catch (e) {
      print('Error removing from favorites: $e');
      _errorMessage = 'Gagal menghapus dari favorit';
      notifyListeners();
    }
  }

  // === HELPER METHOD ===

  // Cek apakah buku sudah ada di favorit
  bool isFavorite(String bookId) {
    return _favorites.any((fav) => fav.bookId == bookId);
  }

  // Get favorite book object berdasarkan bookId
  FavoriteBook? getFavoriteByBookId(String bookId) {
    try {
      return _favorites.firstWhere((fav) => fav.bookId == bookId);
    } catch (e) {
      return null;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}