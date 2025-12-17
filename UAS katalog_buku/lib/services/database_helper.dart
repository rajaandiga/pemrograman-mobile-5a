import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/favorite_book.dart';

class DatabaseHelper {
  // Singleton pattern - hanya ada 1 instance DatabaseHelper di seluruh aplikasi
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Private constructor
  DatabaseHelper._init();

  // Getter untuk database
  Future<Database> get database async {
    // Kalau database sudah ada, return yang sudah ada
    if (_database != null) return _database!;

    // Kalau belum ada, initialize database
    _database = await _initDB('favorites.db');
    return _database!;
  }

  // Method untuk initialize database
  Future<Database> _initDB(String filePath) async {
    // Dapatkan path untuk menyimpan database
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Buka database, kalau belum ada akan dibuat
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Method untuk membuat tabel saat database pertama kali dibuat
  Future _createDB(Database db, int version) async {
    // SQL query untuk membuat tabel favorite_books
    await db.execute('''
      CREATE TABLE favorite_books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bookId TEXT NOT NULL,
        title TEXT NOT NULL,
        authors TEXT NOT NULL,
        thumbnail TEXT,
        note TEXT,
        addedDate TEXT NOT NULL
      )
    ''');

    print('Tabel favorite_books berhasil dibuat!');
  }

  // CREATE - Insert buku favorit baru
  Future<int> insertFavorite(FavoriteBook book) async {
    final db = await database;

    // insert() return ID dari row yang baru diinsert
    return await db.insert(
      'favorite_books',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Kalau ID sama, replace
    );
  }

  // READ - Get semua buku favorit
  Future<List<FavoriteBook>> getAllFavorites() async {
    final db = await database;

    // Query semua data, diurutkan berdasarkan tanggal ditambahkan (terbaru dulu)
    final List<Map<String, dynamic>> maps = await db.query(
      'favorite_books',
      orderBy: 'addedDate DESC',
    );

    // Convert List<Map> menjadi List<FavoriteBook>
    return List.generate(maps.length, (i) {
      return FavoriteBook.fromMap(maps[i]);
    });
  }

  // READ - Get buku favorit berdasarkan bookId (untuk cek apakah buku sudah difavoritkan)
  Future<FavoriteBook?> getFavoriteByBookId(String bookId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'favorite_books',
      where: 'bookId = ?',
      whereArgs: [bookId],
    );

    if (maps.isNotEmpty) {
      return FavoriteBook.fromMap(maps.first);
    } else {
      return null; // Buku belum difavoritkan
    }
  }

  // UPDATE - Update catatan buku favorit
  Future<int> updateFavorite(FavoriteBook book) async {
    final db = await database;

    return await db.update(
      'favorite_books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  // DELETE - Hapus buku favorit berdasarkan bookId
  Future<int> deleteFavoriteByBookId(String bookId) async {
    final db = await database;

    return await db.delete(
      'favorite_books',
      where: 'bookId = ?',
      whereArgs: [bookId],
    );
  }

  // Method untuk close database (biasanya dipanggil saat app ditutup)
  Future close() async {
    final db = await database;
    db.close();
  }
}