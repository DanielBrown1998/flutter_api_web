import 'package:alura_web_api_app_v2/services/journal_service.dart';
import 'package:alura_web_api_app_v2/screens/add_journal_screen/add_journal_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen/home_screen.dart';
import 'package:alura_web_api_app_v2/models/journal.dart';
//import 'helpers/async_study.dart';

void main() {
  runApp(const MyApp());
  JournalService service = JournalService();
  service.register(Journal.empty());
  //service.get();
  //asyncStudy();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.black87,
            titleTextStyle: TextStyle(
              color: Colors.white70,
            ),
            iconTheme: IconThemeData(color: Colors.white),
            actionsIconTheme: IconThemeData(color: Colors.white)),
        textTheme: GoogleFonts.bitterTextTheme(),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      initialRoute: "home",
      routes: {
        "home": (context) => const HomeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "add-journal") {
          final Journal journal = settings.arguments as Journal;
          return MaterialPageRoute(
              builder: (context) => AddJournalScreen(journal: journal));
        }
        return null;
      },
    );
  }
}
