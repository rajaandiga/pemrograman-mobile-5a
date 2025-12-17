import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../providers/book_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';

// Kita pastikan SettingsScreen adalah StatelessWidget
class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final ImagePicker _picker = ImagePicker();

  // Fungsi untuk memilih gambar dari Galeri dan menyimpannya ke Provider
  Future<void> _pickImage(BuildContext context, UserProvider userProvider) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // Kompresi gambar
    );

    if (pickedFile != null) {
      // Simpan path file ke Provider
      await userProvider.updateProfileImage(pickedFile.path);

      // Pastikan context masih mounted sebelum menggunakan ScaffoldMessenger
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto profil berhasil diperbarui')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        children: [
          // Header Profile
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              // Cek apakah ada gambar yang tersimpan (path tidak null/kosong)
              final hasProfileImage = userProvider.profileImagePath != null && userProvider.profileImagePath!.isNotEmpty;

              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor,
                      // Perbaikan: Gunakan nilai alpha 178 untuk 70% opacity
                      primaryColor.withValues(alpha: 178),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Avatar Area - Dibungkus dengan GestureDetector untuk upload
                    GestureDetector(
                      onTap: () => _pickImage(context, userProvider), // Panggil fungsi upload
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            // *** MODIFIKASI: Menampilkan File atau Ikon Default ***
                            child: hasProfileImage
                                ? ClipOval( // Pastikan gambar terpotong bulat
                              child: Image.file(
                                File(userProvider.profileImagePath!), // Tampilkan file dari path lokal
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                                : Icon( // Ikon Default
                              Icons.person,
                              size: 50,
                              color: primaryColor,
                            ),
                          ),

                          // Ikon Kamera (Indikasi bahwa area ini bisa di-tap)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: primaryColor,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      userProvider.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      userProvider.nim,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Edit Profile Button (Hanya untuk Nama dan NIM)
                    ElevatedButton.icon(
                      onPressed: () => _showEditProfileDialog(context, userProvider),
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Nama & NIM'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Appearance Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Tampilan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),

          const SizedBox(height: 8),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return SwitchListTile(
                  secondary: Icon(
                    themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Mode Gelap'),
                  subtitle: Text(
                    themeProvider.isDarkMode ? 'Aktif' : 'Nonaktif',
                  ),
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // BAGIAN TARGET MEMBACA TELAH DIHAPUS SEPENUHNYA DI SINI

          // Statistik
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Statistik',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),

          const SizedBox(height: 8),

          Consumer<BookProvider>(
            builder: (context, provider, child) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red.shade50,
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      ),
                      title: const Text('Buku Favorit'),
                      trailing: Text(
                        '${provider.favorites.length}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.shade50,
                        child: const Icon(
                          Icons.note,
                          color: Colors.green,
                        ),
                      ),
                      title: const Text('Catatan Tersimpan'),
                      trailing: Text(
                        '${provider.favorites.where((fav) => fav.note != null && fav.note!.isNotEmpty).length}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Data Management
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Kelola Data',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),

          const SizedBox(height: 8),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Consumer<BookProvider>(
                  builder: (context, provider, child) {
                    return ListTile(
                      leading: const Icon(Icons.refresh, color: Colors.blue),
                      title: const Text('Muat Ulang Data'),
                      subtitle: const Text('Refresh daftar buku dari API'),
                      onTap: () {
                        provider.loadPopularBooks();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data berhasil dimuat ulang'),
                          ),
                        );
                      },
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text('Hapus Semua Favorit'),
                  subtitle: const Text('Hapus semua buku dan catatan'),
                  onTap: () => _showDeleteAllDialog(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // About & Help
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Lainnya',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),

          const SizedBox(height: 8),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Tentang Aplikasi'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showAboutDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Bantuan'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showHelpDialog(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Footer
          Center(
            child: Column(
              children: [
                Text(
                  'Dibuat dengan ❤️ menggunakan Flutter',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '© 2025 Katalog Buku',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Dialog Edit Profile
  void _showEditProfileDialog(BuildContext context, UserProvider userProvider) {
    final nameController = TextEditingController(text: userProvider.name);
    final nimController = TextEditingController(text: userProvider.nim);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nimController,
              decoration: const InputDecoration(
                labelText: 'NIM',
                prefixIcon: Icon(Icons.badge),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && nimController.text.isNotEmpty) {
                userProvider.updateProfile(
                  nameController.text,
                  nimController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile berhasil diperbarui')),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // DIALOG _showReadingGoalDialog TELAH DIHAPUS SEPENUHNYA

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.book, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Tentang Aplikasi'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Katalog Buku',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Versi 1.0.0'),
            SizedBox(height: 16),
            Text(
              'Aplikasi untuk mencari, menyimpan, dan mengelola koleksi buku favorit Anda dengan Google Books API.',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bantuan'),
        content: const SingleChildScrollView(
          child: Text(
            '1. Cari buku menggunakan kolom pencarian\n\n'
                '2. Tap kartu buku untuk melihat detail\n\n'
                '3. Tambahkan ke favorit dengan tombol hati\n\n'
                '4. Tulis catatan untuk setiap buku favorit\n\n'
                '5. Kelola favorit di tab Favorit',
            style: TextStyle(height: 1.6),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Semua Favorit?'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus semua buku favorit dan catatan? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = Provider.of<BookProvider>(context, listen: false);
              final favorites = List.from(provider.favorites);
              for (var favorite in favorites) {
                await provider.removeFromFavorites(favorite.bookId);
              }
              // Pastikan context masih mounted sebelum menggunakan ScaffoldMessenger
              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Semua favorit berhasil dihapus'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Hapus Semua', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}