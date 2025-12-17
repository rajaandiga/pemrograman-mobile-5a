import 'package:flutter/material.dart';
import 'models/feedback_model.dart';
import 'pages/feedback_form_page.dart';

void main() {
  runApp(const FormFeedbackApp());
}

class FormFeedbackApp extends StatefulWidget {
  const FormFeedbackApp({super.key});

  @override
  State<FormFeedbackApp> createState() => _FormFeedbackAppState();
}

class _FormFeedbackAppState extends State<FormFeedbackApp> {
  final List<FeedbackModel> _feedbackList = [];

  void _addFeedback(FeedbackModel feedback) {
    setState(() {
      _feedbackList.add(feedback);
    });
  }

  void _clearFeedback() {
    setState(() {
      _feedbackList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Feedback App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF8F9FB),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
          foregroundColor: Colors.indigo,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: FeedbackFormPage(
        onSubmit: _addFeedback,
        feedbackList: _feedbackList,
        onClear: _clearFeedback,
      ),
    );
  }
}
