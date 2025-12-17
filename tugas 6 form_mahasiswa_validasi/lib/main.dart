import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const FormMahasiswaApp());
}

class FormMahasiswaApp extends StatelessWidget {
  const FormMahasiswaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const FormMahasiswaScreen(),
    );
  }
}

class FormMahasiswaScreen extends StatefulWidget {
  const FormMahasiswaScreen({super.key});

  @override
  State<FormMahasiswaScreen> createState() => _FormMahasiswaScreenState();
}

class _FormMahasiswaScreenState extends State<FormMahasiswaScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _nomorHPController = TextEditingController();

  // Form Data
  String? _selectedJurusan;
  double _semester = 1;
  final Map<String, bool> _hobi = {
    'Membaca': false,
    'Olahraga': false,
    'Musik': false,
    'Gaming': false,
    'Traveling': false,
    'Memasak': false,
  };
  bool _persetujuan = false;

  // Dropdown Options
  final List<String> _jurusanList = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Teknik Elektro',
    'Teknik Mesin',
    'Manajemen',
    'Akuntansi',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _nomorHPController.dispose();
    super.dispose();
  }

  String? _validateNama(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.length < 3) {
      return 'Nama minimal 3 karakter';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Nama hanya boleh berisi huruf';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? _validateNomorHP(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor HP tidak boleh kosong';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Nomor HP hanya boleh berisi angka';
    }
    if (value.length < 10 || value.length > 13) {
      return 'Nomor HP harus 10-13 digit';
    }
    return null;
  }

  String? _validateJurusan() {
    if (_selectedJurusan == null) {
      return 'Pilih jurusan terlebih dahulu';
    }
    return null;
  }

  String? _validateHobi() {
    if (!_hobi.containsValue(true)) {
      return 'Pilih minimal satu hobi';
    }
    return null;
  }

  String? _validatePersetujuan() {
    if (!_persetujuan) {
      return 'Anda harus menyetujui syarat dan ketentuan';
    }
    return null;
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      // Validasi Step 1: Data Pribadi
      bool isValid = true;
      if (_validateNama(_namaController.text) != null) isValid = false;
      if (_validateEmail(_emailController.text) != null) isValid = false;
      if (_validateNomorHP(_nomorHPController.text) != null) isValid = false;
      return isValid;
    } else if (_currentStep == 1) {
      // Validasi Step 2: Data Akademik
      if (_validateJurusan() != null) {
        _showSnackBar('Pilih jurusan terlebih dahulu', Colors.red);
        return false;
      }
      return true;
    } else if (_currentStep == 2) {
      // Validasi Step 3: Data Tambahan
      if (_validateHobi() != null) {
        _showSnackBar('Pilih minimal satu hobi', Colors.red);
        return false;
      }
      if (_validatePersetujuan() != null) {
        _showSnackBar('Anda harus menyetujui syarat dan ketentuan', Colors.red);
        return false;
      }
      return true;
    }
    return false;
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _submitForm() {
    if (_validateCurrentStep()) {
      final selectedHobi = _hobi.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Flexible(
                child: Text(
                  'Data Berhasil Disimpan',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInfoRow('Nama', _namaController.text),
                _buildInfoRow('Email', _emailController.text),
                _buildInfoRow('Nomor HP', _nomorHPController.text),
                _buildInfoRow('Jurusan', _selectedJurusan ?? '-'),
                _buildInfoRow('Semester', _semester.toInt().toString()),
                _buildInfoRow('Hobi', selectedHobi.join(', ')),
                _buildInfoRow('Persetujuan', _persetujuan ? 'Setuju' : 'Tidak Setuju'),
              ],
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetForm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          const Divider(height: 16),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _currentStep = 0;
      _namaController.clear();
      _emailController.clear();
      _nomorHPController.clear();
      _selectedJurusan = null;
      _semester = 1;
      _hobi.updateAll((key, value) => false);
      _persetujuan = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Form Pendaftaran Mahasiswa'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 2) {
              if (_validateCurrentStep()) {
                setState(() {
                  _currentStep += 1;
                });
              } else {
                _formKey.currentState?.validate();
              }
            } else {
              _submitForm();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep -= 1;
              });
            }
          },
          onStepTapped: (step) {
            setState(() {
              _currentStep = step;
            });
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(_currentStep == 2 ? 'Submit' : 'Lanjut'),
                  ),
                  const SizedBox(width: 12),
                  if (_currentStep > 0)
                    OutlinedButton(
                      onPressed: details.onStepCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Kembali'),
                    ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('Data Pribadi'),
              subtitle: const Text('Informasi dasar'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(
                    controller: _namaController,
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      hintText: 'Masukkan nama lengkap',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: _validateNama,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'contoh@email.com',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nomorHPController,
                    decoration: InputDecoration(
                      labelText: 'Nomor HP',
                      hintText: '08xxxxxxxxxx',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: _validateNomorHP,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('Data Akademik'),
              subtitle: const Text('Informasi perkuliahan'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _selectedJurusan,
                    decoration: InputDecoration(
                      labelText: 'Jurusan',
                      prefixIcon: const Icon(Icons.school),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    hint: const Text('Pilih Jurusan'),
                    items: _jurusanList.map((String jurusan) {
                      return DropdownMenuItem<String>(
                        value: jurusan,
                        child: Text(jurusan),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedJurusan = newValue;
                      });
                    },
                    validator: (value) => _validateJurusan(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Semester: ${_semester.toInt()}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(8, (index) {
                            return Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                color: _semester.toInt() == index + 1
                                    ? Colors.indigo
                                    : Colors.grey,
                                fontWeight: _semester.toInt() == index + 1
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            );
                          }),
                        ),
                        Slider(
                          value: _semester,
                          min: 1,
                          max: 8,
                          divisions: 7,
                          label: _semester.toInt().toString(),
                          activeColor: Colors.indigo,
                          onChanged: (double value) {
                            setState(() {
                              _semester = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('Data Tambahan'),
              subtitle: const Text('Hobi dan persetujuan'),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hobi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: _hobi.keys.map((String key) {
                        return CheckboxListTile(
                          title: Text(key),
                          value: _hobi[key],
                          activeColor: Colors.indigo,
                          onChanged: (bool? value) {
                            setState(() {
                              _hobi[key] = value ?? false;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _persetujuan ? Colors.indigo : Colors.grey.shade300,
                        width: _persetujuan ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Persetujuan Syarat & Ketentuan',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Saya setuju dengan syarat dan ketentuan yang berlaku',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _persetujuan,
                          activeThumbColor: Colors.indigo,
                          onChanged: (bool value) {
                            setState(() {
                              _persetujuan = value;
                            });
                          },
                        ),
                      ],
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