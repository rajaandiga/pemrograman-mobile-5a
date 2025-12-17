import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/dosen.dart';

class DetailPage extends StatelessWidget {
  final Dosen dosen;
  const DetailPage({super.key, required this.dosen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text(
          dosen.nama,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Hero(
              tag: dosen.nama,
              child: CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage(
                  dosen.jenisKelamin.toLowerCase() == 'perempuan'
                      ? 'assets/avatars/avatar_female.jpg'
                      : 'assets/avatars/avatar_male.jpg',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              dosen.nama,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              dosen.keahlian,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.blueGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.badge, color: Colors.blueAccent),
                    title: Text('NIDN: ${dosen.nidn}',
                        style: GoogleFonts.poppins(fontSize: 14)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.blueAccent),
                    title: Text(dosen.email,
                        style: GoogleFonts.poppins(fontSize: 14)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info, color: Colors.blueAccent),
                    title: Text(
                      dosen.deskripsi,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
