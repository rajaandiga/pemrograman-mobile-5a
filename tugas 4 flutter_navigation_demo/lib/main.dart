import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/form_page.dart';
import 'pages/result_page.dart';
import 'pages/detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Navigation Demo",
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.light,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      routes: {
        '/': (context) => HomePage(),
        '/form': (context) => FormPage(),
        '/result': (context) => ResultPage(),
        '/detail': (context) => DetailPage(),
      },
    );
  }
}
