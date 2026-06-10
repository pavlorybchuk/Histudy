import 'package:flutter/material.dart';
import 'package:histudy/pages/home_page.dart';

void main() {
  runApp(const Histudy());
}

class Histudy extends StatelessWidget {
  const Histudy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Histudy',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "NotoSans",
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor:
              Colors.deepPurple,
          foregroundColor:
              Colors.white,
          elevation: 0,
        ),
      ),
      home: HomePage(),
    );
  }
}
