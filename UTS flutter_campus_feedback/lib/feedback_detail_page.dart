import 'package:flutter/material.dart';
import 'model/feedback_item.dart';

class FeedbackDetailPage extends StatelessWidget {
  final FeedbackItem feedback;
  final int index;
  final VoidCallback onDelete;

  const FeedbackDetailPage({
    super.key,
    required this.feedback,
    required this.index,
    required this.onDelete,
  });

  IconData _getIconByType(String type) {
    switch (type) {
      case 'Apresiasi':
        return Icons.thumb_up;
      case 'Saran':
        return Icons.lightbulb_outline;
      case 'Keluhan':
        return Icons.report_problem;
      default:
        return Icons.feedback;
    }
  }

  Color _getColorByType(String type) {
    switch (type) {
      case 'Apresiasi':
        return Colors.green;
      case 'Saran':
        return Colors.blue;
      case 'Keluhan':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus feedback ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              onDelete();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColorByType(feedback.jenisFeedback);
    final icon = _getIconByType(feedback.jenisFeedback);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Feedback'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context),
            tooltip: 'Hapus Feedback',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dengan jenis feedback
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(color: color, width: 3),
                ),
              ),
              child: Column(
                children: [
                  Icon(icon, size: 60, color: color),
                  const SizedBox(height: 12),
                  Text(
                    feedback.jenisFeedback,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Data Mahasiswa
                  _buildSectionTitle(context, 'Data Mahasiswa'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            context,
                            Icons.person,
                            'Nama',
                            feedback.nama,
                          ),
                          const Divider(height: 24),
                          _buildDetailRow(
                            context,
                            Icons.badge,
                            'NIM',
                            feedback.nim,
                          ),
                          const Divider(height: 24),
                          _buildDetailRow(
                            context,
                            Icons.school,
                            'Fakultas',
                            feedback.fakultas,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Fasilitas yang Dinilai
                  _buildSectionTitle(context, 'Fasilitas yang Dinilai'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: feedback.fasilitas.map((fasilitas) {
                          return Chip(
                            avatar: Icon(
                              Icons.check_circle,
                              size: 18,
                              color: Colors.green.shade700,
                            ),
                            label: Text(fasilitas),
                            backgroundColor: Colors.green.shade50,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nilai Kepuasan
                  _buildSectionTitle(context, 'Nilai Kepuasan'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 48,
                            color: Colors.amber.shade700,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  feedback.nilaiKepuasan.toStringAsFixed(1),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber.shade700,
                                      ),
                                ),
                                Text(
                                  'dari 5.0',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pesan Tambahan
                  if (feedback.pesanTambahan.isNotEmpty) ...[
                    _buildSectionTitle(context, 'Pesan Tambahan'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.message,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                feedback.pesanTambahan,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Status Persetujuan
                  _buildSectionTitle(context, 'Status'),
                  Card(
                    color: feedback.setujuSyarat
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            feedback.setujuSyarat
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: feedback.setujuSyarat
                                ? Colors.green
                                : Colors.red,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feedback.setujuSyarat
                                  ? 'Menyetujui syarat dan ketentuan'
                                  : 'Tidak menyetujui syarat dan ketentuan',
                              style: TextStyle(
                                color: feedback.setujuSyarat
                                    ? Colors.green.shade900
                                    : Colors.red.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tombol Aksi
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Kembali'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showDeleteDialog(context),
                          icon: const Icon(Icons.delete),
                          label: const Text('Hapus'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
