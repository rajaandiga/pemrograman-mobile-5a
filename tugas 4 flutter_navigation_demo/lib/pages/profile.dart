import 'package:flutter/material.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 30),
      children: [
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  "MR",
                  style: TextStyle(
                    fontSize: 38,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Mhd. Raja Habib Andiga",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Flutter Developer",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

          FilledButton.tonal(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: {
                  "name": "Mhd. Raja Habib Andiga",
                  "nim": "701230031",
                  "jurusan": "Sistem Informasi",
                  "tugas": "Pemrograman Mobile",
                },
              );
            },
            child: const Text("Lihat Detail Profile"),
          ),
            ],
          ),
        ),
      ],
    );
  }
}
