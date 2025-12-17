import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/dosen.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Dosen> daftarDosen = [];
  List<Dosen> hasilPencarian = [];

  @override
  void initState() {
    super.initState();
    daftarDosen = [
      Dosen(
        nama: 'HERY AFRIYADI, SE., S.Kom., M.Si.',
        nidn: '197104152000121001',
        email: 'hery.afriyadi@uinjambi.ac.id',
        jenisKelamin: 'Pria',
        keahlian: 'Sistem Informasi & Manajemen Teknologi',
        deskripsi:
        'Dosen Fakultas Sains dan Teknologi UIN STS Jambi dengan fokus pada integrasi teknologi informasi dalam dunia bisnis dan manajemen data digital.',
      ),
      Dosen(
        nama: 'Dr. TRY SUSANTI, S.Si., M.Si.',
        nidn: '197603032005012005',
        email: 'try.susanti@uinjambi.ac.id',
        jenisKelamin: 'Perempuan',
        keahlian: 'Matematika & Data Analitik',
        deskripsi:
        'Aktif meneliti dalam bidang analisis numerik dan data analitik. Memiliki pengalaman panjang dalam pengajaran dan penelitian di bidang sains.',
      ),
      Dosen(
        nama: 'EFITRA, M.Kom.',
        nidn: '199112262019031013',
        email: 'efitra@uinjambi.ac.id',
        jenisKelamin: 'Pria',
        keahlian: 'Jaringan Komputer & Pemrograman',
        deskripsi:
        'Berfokus pada pengembangan sistem jaringan, keamanan informasi, dan implementasi aplikasi berbasis web.',
      ),
      Dosen(
        nama: 'MUTAMASSIKIN, M.Kom.',
        nidn: '199004092019031014',
        email: 'mutamassikin@uinjambi.ac.id',
        jenisKelamin: 'Pria',
        keahlian: 'Pemrograman & Data Science',
        deskripsi:
        'Mendalami bidang machine learning, pengolahan data, serta teknologi backend untuk aplikasi modern.',
      ),
      Dosen(
        nama: 'ANDREO YUDERTHA, M.Eng.',
        nidn: '198907262020121006',
        email: 'andreo.yudertha@uinjambi.ac.id',
        jenisKelamin: 'Pria',
        keahlian: 'Teknik Elektro & Otomasi Sistem',
        deskripsi:
        'Meneliti dan mengajar dalam bidang sistem kontrol dan elektronika industri modern.',
      ),
    ];

    hasilPencarian = List.from(daftarDosen);
  }

  void _cariDosen(String query) {
    final hasil = daftarDosen.where((dosen) {
      final namaLower = dosen.nama.toLowerCase();
      final keahlianLower = dosen.keahlian.toLowerCase();
      final input = query.toLowerCase();
      return namaLower.contains(input) || keahlianLower.contains(input);
    }).toList();

    setState(() {
      hasilPencarian = hasil;
    });
  }

  void _hapusDosen(Dosen dosen) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Hapus',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text(
          'Apakah Anda yakin ingin menghapus dosen "${dosen.nama}"?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              setState(() {
                daftarDosen.remove(dosen);
                hasilPencarian.remove(dosen);
              });
              Navigator.pop(context);
            },
            child: Text('Hapus', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _tambahDosenBaru(BuildContext context) {
    final namaCtrl = TextEditingController();
    final nidnCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final keahlianCtrl = TextEditingController();
    final deskripsiCtrl = TextEditingController();
    String jenisKelamin = 'Pria';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Dosen Baru',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: namaCtrl,
                  decoration: const InputDecoration(labelText: 'Nama'),
                ),
                TextField(
                  controller: nidnCtrl,
                  decoration: const InputDecoration(labelText: 'NIDN'),
                ),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                DropdownButtonFormField<String>(
                  value: jenisKelamin,
                  items: const [
                    DropdownMenuItem(value: 'Pria', child: Text('Pria')),
                    DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
                  ],
                  onChanged: (val) {
                    jenisKelamin = val!;
                  },
                  decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                ),
                TextField(
                  controller: keahlianCtrl,
                  decoration: const InputDecoration(labelText: 'Keahlian'),
                ),
                TextField(
                  controller: deskripsiCtrl,
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal', style: GoogleFonts.poppins()),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              onPressed: () {
                if (namaCtrl.text.isEmpty ||
                    nidnCtrl.text.isEmpty ||
                    emailCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Isi semua data terlebih dahulu!')),
                  );
                  return;
                }

                final dosenBaru = Dosen(
                  nama: namaCtrl.text,
                  nidn: nidnCtrl.text,
                  email: emailCtrl.text,
                  jenisKelamin: jenisKelamin,
                  keahlian: keahlianCtrl.text,
                  deskripsi: deskripsiCtrl.text,
                );

                setState(() {
                  daftarDosen.add(dosenBaru);
                  hasilPencarian = List.from(daftarDosen);
                });

                Navigator.pop(context);
              },
              child: Text('Simpan', style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text(
          'Profil Dosen UIN STS Jambi',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // 🔍 Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari dosen berdasarkan nama atau keahlian...',
                hintStyle: GoogleFonts.poppins(fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _cariDosen,
            ),
            const SizedBox(height: 8),

            // 💡 Info Hapus
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '💡 Geser ke kiri pada kartu dosen untuk menghapus',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 📋 Daftar Dosen
            Expanded(
              child: hasilPencarian.isEmpty
                  ? Center(
                child: Text(
                  'Dosen tidak ditemukan',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: hasilPencarian.length,
                itemBuilder: (context, index) {
                  final dosen = hasilPencarian[index];
                  return Dismissible(
                    key: ValueKey(dosen.nidn),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) => _hapusDosen(dosen),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.redAccent,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                DetailPage(dosen: dosen),
                            transitionsBuilder:
                                (_, animation, __, child) => FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 6,
                        shadowColor: Colors.blue.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundImage: AssetImage(
                                  dosen.jenisKelamin.toLowerCase() ==
                                      'perempuan'
                                      ? 'assets/avatars/avatar_female.jpg'
                                      : 'assets/avatars/avatar_male.jpg',
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dosen.nama,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      dosen.keahlian,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  size: 18, color: Colors.blueAccent),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ➕ Tombol Tambah Dosen
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tambahDosenBaru(context),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
