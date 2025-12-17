import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map?;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Data Diterima")),
      body: Padding(
        padding: const EdgeInsets.all(24), // Padding lebih besar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                "Data Berhasil Diterima 🎉",
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),

            // Menggunakan Card untuk membungkus informasi data
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.person_outline, color: theme.colorScheme.primary),
                      title: const Text("Nama"),
                      subtitle: Text(
                        data?["name"] ?? "-",
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    const Divider(indent: 16, endIndent: 16), // Pemisah M3
                    ListTile(
                      leading: Icon(Icons.message_outlined, color: theme.colorScheme.primary),
                      title: const Text("Pesan"),
                      subtitle: Text(
                        data?["message"] ?? "-",
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Menggunakan FilledButton
            FilledButton.icon(
              onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')),
              icon: const Icon(Icons.home),
              label: const Text("Kembali ke Home"),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}