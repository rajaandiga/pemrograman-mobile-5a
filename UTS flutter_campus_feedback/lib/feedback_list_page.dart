import 'package:flutter/material.dart';
import 'model/feedback_item.dart';
import 'feedback_detail_page.dart';

class FeedbackListPage extends StatelessWidget {
  final List<FeedbackItem> feedbackList;
  final Function(int) onDelete;

  const FeedbackListPage({
    super.key,
    required this.feedbackList,
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

  String _getKepuasanText(double nilai) {
    if (nilai >= 4.5) return 'Sangat Puas';
    if (nilai >= 3.5) return 'Puas';
    if (nilai >= 2.5) return 'Cukup';
    if (nilai >= 1.5) return 'Kurang Puas';
    return 'Sangat Tidak Puas';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Feedback'),
        elevation: 0,
      ),
      body: feedbackList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada feedback',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                final feedback = feedbackList[index];
                final color = _getColorByType(feedback.jenisFeedback);
                final icon = _getIconByType(feedback.jenisFeedback);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.2),
                      child: Icon(icon, color: color),
                    ),
                    title: Text(
                      feedback.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(feedback.fakultas),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${feedback.nilaiKepuasan.toStringAsFixed(1)} - ${_getKepuasanText(feedback.nilaiKepuasan)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: color, width: 1),
                      ),
                      child: Text(
                        feedback.jenisFeedback,
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FeedbackDetailPage(
                            feedback: feedback,
                            index: index,
                            onDelete: () {
                              onDelete(index);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Feedback berhasil dihapus'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
