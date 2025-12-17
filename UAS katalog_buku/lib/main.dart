import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/book_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';
import 'screens/splash_screen.dart';

// Fungsi main = titik awal aplikasi
void main() {
  // Pastikan Flutter binding initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Jalankan aplikasi
  runApp(const MyApp());
}

// Root widget aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider = menyediakan multiple Provider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            // Judul aplikasi
            title: 'Katalog Buku',

            // Hilangkan banner debug
            debugShowCheckedModeBanner: false,

            // Theme berdasarkan mode (light/dark)
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

            // Halaman pertama = Splash Screen
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}