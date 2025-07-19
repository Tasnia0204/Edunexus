import 'package:flutter/material.dart';

import 'views/welcome_view.dart';

void main() {
  runApp(const EduNexusApp());
}

class EduNexusApp extends StatelessWidget {
  const EduNexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduNexus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF9FCFF),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF081F5C),
          secondary: const Color(0xFF334EAC),
        ),
      ),
      home: const WelcomeView(),
    );
  }
}
