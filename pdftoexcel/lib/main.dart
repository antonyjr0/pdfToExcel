import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PdfToExcelApp());
}

class PdfToExcelApp extends StatelessWidget {
  const PdfToExcelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF to Excel Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}