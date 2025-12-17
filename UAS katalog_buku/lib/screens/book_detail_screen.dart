import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';
import 'add_note_screen.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BookProvider>(
        builder: (context, provider, child) {
          // Cek apakah buku sudah difavoritkan
          final isFavorite = provider.isFavorite(book.id);
          final favoriteBook = provider.getFavoriteByBookId(book.id);

          return CustomScrollView(
            // CustomScrollView = scrollable area dengan berbagai sliver
            slivers: [
              // === APP BAR DENGAN GAMBAR ===
              SliverAppBar(
                expandedHeight: 300,
                pinned: true, // AppBar tetap terlihat saat scroll
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    book.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  background: book.thumbnail != null
                      ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        book.thumbnail!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder();
                        },
                      ),
                      // Gradient overlay agar text lebih terbaca
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                      : _buildPlaceholder(),
                ),
                actions: [
                  // Tombol favorit
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      if (isFavorite) {
                        // Hapus dari favorit
                        _showRemoveFavoriteDialog(context, provider);
                      } else {
                        // Tambah ke favorit
                        provider.addToFavorites(book);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ditambahkan ke favorit'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),

              // === DETAIL BUKU ===
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Penulis
                      Row(
                        children: [
                          const Icon(Icons.person, size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              book.authors.join(', '),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Info cards (tanggal, halaman, rating)
                      Row(
                        children: [
                          if (book.publishedDate != null)
                            Expanded(
                              child: _buildInfoCard(
                                Icons.calendar_today,
                                'Terbit',
                                book.publishedDate!,
                              ),
                            ),
                          if (book.pageCount != null) ...[
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildInfoCard(
                                Icons.menu_book,
                                'Halaman',
                                '${book.pageCount}',
                              ),
                            ),
                          ],
                          if (book.averageRating != null) ...[
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildInfoCard(
                                Icons.star,
                                'Rating',
                                book.averageRating!.toStringAsFixed(1),
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Deskripsi
                      const Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        book.description ?? 'Tidak ada deskripsi tersedia.',
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.justify,
                      ),

                      const SizedBox(height: 24),

                      // Catatan pribadi (kalau sudah difavoritkan)
                      if (isFavorite && favoriteBook != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Catatan Pribadi',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddNoteScreen(
                                      favoriteBook: favoriteBook,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Text(
                            favoriteBook.note ?? 'Belum ada catatan',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: favoriteBook.note != null
                                  ? Colors.black87
                                  : Colors.grey,
                              fontStyle: favoriteBook.note != null
                                  ? FontStyle.normal
                                  : FontStyle.italic,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      const SizedBox(height: 80), // Space untuk floating button
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),

      // Floating action button
      floatingActionButton: Consumer<BookProvider>(
        builder: (context, provider, child) {
          final isFavorite = provider.isFavorite(book.id);

          if (!isFavorite) {
            return FloatingActionButton.extended(
              onPressed: () {
                provider.addToFavorites(book);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ditambahkan ke favorit'),
                  ),
                );
              },
              icon: const Icon(Icons.favorite_border),
              label: const Text('Tambah ke Favorit'),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  // Widget untuk info card
  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.book,
          size: 80,
          color: Colors.grey,
        ),
      ),
    );
  }

  void _showRemoveFavoriteDialog(BuildContext context, BookProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus dari Favorit?'),
        content: const Text('Catatan pribadi Anda juga akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              provider.removeFromFavorites(book.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dihapus dari favorit'),
                ),
              );
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}