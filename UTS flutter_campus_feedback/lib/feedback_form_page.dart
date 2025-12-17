import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'model/feedback_item.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _pesanController = TextEditingController();

  String? _selectedFakultas;
  final List<String> _fakultasList = [
    'Fakultas Syariah',
    'Fakultas Tarbiyah dan Keguruan',
    'Fakultas Ushuluddin',
    'Fakultas Ekonomi dan Bisnis Islam',
    'Fakultas Adab dan Humaniora',
    'Fakultas Dakwah',
    'Fakultas Sains dan Teknologi',
  ];

  final Map<String, bool> _fasilitasMap = {
    'Perpustakaan': false,
    'Laboratorium Komputer': false,
    'Ruang Kelas': false,
    'Masjid': false,
    'Kantin': false,
    'Lapangan Olahraga': false,
    'Wifi Kampus': false,
  };

  double _nilaiKepuasan = 3.0;
  String _jenisFeedback = 'Saran';
  bool _setujuSyarat = false;

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _pesanController.dispose();
    super.dispose();
  }

  void _simpanFeedback() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_setujuSyarat) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Perhatian'),
          content: const Text(
            'Anda harus menyetujui syarat dan ketentuan terlebih dahulu.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final fasilitasDipilih = _fasilitasMap.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (fasilitasDipilih.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal satu fasilitas yang dinilai'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final feedbackItem = FeedbackItem(
      nama: _namaController.text,
      nim: _nimController.text,
      fakultas: _selectedFakultas!,
      fasilitas: fasilitasDipilih,
      nilaiKepuasan: _nilaiKepuasan,
      jenisFeedback: _jenisFeedback,
      pesanTambahan: _pesanController.text,
      setujuSyarat: _setujuSyarat,
    );

    Navigator.pop(context, feedbackItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Feedback'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Nama Mahasiswa
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Mahasiswa',
                hintText: 'Masukkan nama lengkap',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // NIM
            TextFormField(
              controller: _nimController,
              decoration: const InputDecoration(
                labelText: 'NIM',
                hintText: 'Masukkan NIM',
                prefixIcon: Icon(Icons.badge),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIM wajib diisi';
                }
                if (value.length < 8) {
                  return 'NIM minimal 8 digit';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Fakultas
            DropdownButtonFormField<String>(
              value: _selectedFakultas,
              decoration: const InputDecoration(
                labelText: 'Fakultas',
                prefixIcon: Icon(Icons.school),
                border: OutlineInputBorder(),
              ),
              items: _fakultasList.map((fakultas) {
                return DropdownMenuItem(
                  value: fakultas,
                  child: Text(fakultas),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFakultas = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Pilih fakultas';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Fasilitas yang Dinilai
            Text(
              'Fasilitas yang Dinilai',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: _fasilitasMap.keys.map((fasilitas) {
                  return CheckboxListTile(
                    title: Text(fasilitas),
                    value: _fasilitasMap[fasilitas],
                    onChanged: (bool? value) {
                      setState(() {
                        _fasilitasMap[fasilitas] = value ?? false;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Nilai Kepuasan
            Text(
              'Nilai Kepuasan: ${_nilaiKepuasan.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Slider(
                      value: _nilaiKepuasan,
                      min: 1.0,
                      max: 5.0,
                      divisions: 4,
                      label: _nilaiKepuasan.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() {
                          _nilaiKepuasan = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Sangat Tidak Puas',
                            style: Theme.of(context).textTheme.bodySmall),
                        Text('Sangat Puas',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Jenis Feedback
            Text(
              'Jenis Feedback',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Saran'),
                    value: 'Saran',
                    groupValue: _jenisFeedback,
                    onChanged: (value) {
                      setState(() {
                        _jenisFeedback = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Keluhan'),
                    value: 'Keluhan',
                    groupValue: _jenisFeedback,
                    onChanged: (value) {
                      setState(() {
                        _jenisFeedback = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Apresiasi'),
                    value: 'Apresiasi',
                    groupValue: _jenisFeedback,
                    onChanged: (value) {
                      setState(() {
                        _jenisFeedback = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Pesan Tambahan
            TextFormField(
              controller: _pesanController,
              decoration: const InputDecoration(
                labelText: 'Pesan Tambahan (Opsional)',
                hintText: 'Tulis feedback Anda di sini',
                prefixIcon: Icon(Icons.message),
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),

            // Syarat dan Ketentuan
            Card(
              color: Colors.blue.shade50,
              child: SwitchListTile(
                title: const Text('Setuju Syarat & Ketentuan'),
                subtitle: const Text(
                  'Data yang diisi akan digunakan untuk evaluasi kampus',
                  style: TextStyle(fontSize: 12),
                ),
                value: _setujuSyarat,
                onChanged: (bool value) {
                  setState(() {
                    _setujuSyarat = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Simpan
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _simpanFeedback,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Simpan Feedback',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
