import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final nameController = TextEditingController();
  final msgController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Form Input")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "Masukkan Data:",
            style: theme.textTheme.titleLarge, // Menggunakan textTheme dari M3
          ),
          const SizedBox(height: 16),

          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Nama Lengkap",
              // `border: OutlineInputBorder` Dihapus, mengikuti tema global dari main.dart
            ),
          ),
          const SizedBox(height: 14),

          TextField(
            controller: msgController,
            decoration: const InputDecoration(
              labelText: "Pesan",
              // `border: OutlineInputBorder` Dihapus, mengikuti tema global dari main.dart
            ),
          ),
          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/result',
                arguments: {
                  "name": nameController.text,
                  "message": msgController.text
                },
              );
            },
            icon: const Icon(Icons.send),
            label: const Text("Kirim Data"),
          ),
        ],
      ),
    );
  }
}