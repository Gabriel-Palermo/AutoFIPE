import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const AutoFipeApp());
}

class AutoFipeApp extends StatelessWidget {
  const AutoFipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFF080D18);
    const surface = Color(0xFF121C2D);
    const blue = Color(0xFF168BFF);
    const cyan = Color(0xFF00D4FF);

    return MaterialApp(
      title: 'AutoFIPE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.dark(
          primary: blue,
          secondary: cyan,
          surface: surface,
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: background,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIconColor: cyan,
          suffixIconColor: Colors.white70,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 17,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF26364D)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: cyan, width: 1.5),
          ),
        ),
        dividerColor: const Color(0xFF26364D),
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: cyan),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
