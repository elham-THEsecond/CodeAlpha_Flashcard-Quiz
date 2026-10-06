import 'package:flashcard_quiz/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('flashcards');
  runApp(const FlashCard());
}

class FlashCard extends StatelessWidget {
  const FlashCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Establish a base typography profile to prevent context loops
    final baseTextTheme = Typography.material2021().black;

    return MaterialApp(
      title: 'Flashcard App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),

        // 2. Generate the baseline Google Font text theme safely
        textTheme: GoogleFonts.robotoSlabTextTheme(baseTextTheme).copyWith(
          bodyLarge: GoogleFonts.robotoSlab(
            textStyle: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          bodyMedium: GoogleFonts.robotoSlab(
            textStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
