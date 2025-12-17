import 'package:flutter/material.dart';
import '../models/feedback_model.dart';

class FeedbackListPage extends StatefulWidget {
  final List<FeedbackModel> feedbackList;
  final Function() onClear;

  const FeedbackListPage({
    super.key,
    required this.feedbackList,
    required this.onClear,
  });

  @override
  State<FeedbackListPage> createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  final Map<String, IconData> _categoryIcons = {
    'Umum': Icons.info_outline,
    'UI/UX': Icons.design_services,
    'Kinerja': Icons.speed,
    'Bug': Icons.bug_report,
    'Lainnya': Icons.more_horiz,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Feedback'),
        actions: [
          if (widget.feedbackList.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Konfirmasi'),
                    content: const Text('Yakin ingin menghapus semua feedback?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.onClear();
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: const Text('Hapus'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: widget.feedbackList.isEmpty
          ? const Center(child: Text('Belum ada feedback.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.feedbackList.length,
        itemBuilder: (context, index) {
          final f = widget.feedbackList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: CircleAvatar(
                backgroundColor: Colors.indigo.shade100,
                child: Text(
                  f.name[0].toUpperCase(),
                  style: const TextStyle(
                      color: Colors.indigo, fontWeight: FontWeight.bold),
                ),
              ),
              title: Row(
                children: [
                  Text(f.name,
                      style:
                      const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 6),
                  Icon(_categoryIcons[f.category], size: 18, color: Colors.indigo),
                  const SizedBox(width: 4),
                  Text(f.category,
                      style:
                      const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(f.comment),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      for (int i = 1; i <= 5; i++)
                        Icon(
                          i <= f.rating ? Icons.star : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Tanggal: ${f.date.toLocal()}'.split('.')[0],
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey)),
                  if (f.allowPublish)
                    const Text('✓ Tampil publik',
                        style: TextStyle(color: Colors.green)),
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: const Color(0xFFF2F5FA),
    );
  }
}
