class FeedbackModel {
  final String name;
  final String comment;
  final double rating;
  final String category;
  final bool allowPublish;
  final DateTime date;

  FeedbackModel({
    required this.name,
    required this.comment,
    required this.rating,
    required this.category,
    required this.allowPublish,
    required this.date,
  });
}
