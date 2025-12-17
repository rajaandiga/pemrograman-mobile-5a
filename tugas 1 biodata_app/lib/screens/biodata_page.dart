import 'package:flutter/material.dart';

class BiodataPage extends StatelessWidget {
  const BiodataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageHeight = size.height * 0.45; // tinggi gambar bagian atas

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // 🔹 FOTO UTAMA
            SizedBox(
              height: imageHeight,
              width: double.infinity,
              child: Image.asset(
                'assets/profile.jpg',
                fit: BoxFit.cover,
              ),
            ),

            // 🔹 ICON ATAS (Back & Bookmark)
            Positioned(
              top: 10,
              left: 12,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black87,
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 12,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.bookmark_border_rounded,
                  color: Colors.black87,
                ),
              ),
            ),

            // 🔹 KARTU UTAMA PUTIH
            Positioned(
              top: imageHeight - 80,
              left: 16,
              right: 16,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 60, 16, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔸 BARIS ATAS: Nama, Kalimat, Lokasi, Jurusan, dan Tombol Add
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nama & Detail
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Mhd. Raja Habib A",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Talk Less Do More",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: const [
                                    Icon(Icons.location_on_outlined,
                                        color: Colors.black54, size: 18),
                                    SizedBox(width: 6),
                                    Text(
                                      "Jambi",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(width: 14),
                                    Icon(Icons.school_outlined,
                                        color: Colors.black54, size: 18),
                                    SizedBox(width: 6),
                                    Text(
                                      "Sistem Informasi",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Tombol Add sejajar di kanan
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              debugPrint("Tombol Add diklik!");
                            },
                            child: const Text(
                              "+ Add",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // 🔸 GARIS PEMISAH
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                      ),

                      const SizedBox(height: 20),

                      // 🔸 BAGIAN NIM - HOBI - CONTACT
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // NIM
                          Column(
                            children: const [
                              Text(
                                "NIM",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "701230031",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),

                          // HOBI
                          Column(
                            children: const [
                              Text(
                                "Hobby",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Membaca",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),

                          // CONTACT
                          Column(
                            children: const [
                              Text(
                                "Contact",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "081368888580",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // 🔸 GARIS PEMISAH KEDUA
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                      ),

                      const SizedBox(height: 18),

                      // 🔸 KOLOM DESKRIPSI
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Description",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                            "I love anything about coding because it's where the ideas can be turned into something real.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 🔹 FOTO PROFIL BULAT
            Positioned(
              top: imageHeight - 120,
              left: 36,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: const CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
