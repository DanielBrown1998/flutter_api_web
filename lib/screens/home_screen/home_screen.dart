import 'package:flutter/material.dart';
//import 'package:alura_web_api_app_v2/database/database.dart';
import 'package:alura_web_api_app_v2/screens/home_screen/widgets/home_screen_list.dart';
import 'package:alura_web_api_app_v2/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/journal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // O último dia apresentado na lista
  DateTime currentDay = DateTime.now();

  // Tamanho da lista
  int windowPage = 10;

  // A base de dados mostrada na lista
  Map<String, Journal> database = {};

  final ScrollController _listScrollController = ScrollController();

  JournalService service = JournalService();

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título basado no dia atual
        title: Text(
          "${currentDay.day}  |  ${currentDay.month}  |  ${currentDay.year}",
        ),
        actions: [
          IconButton(
              onPressed: () {
                refresh();
              },
              icon: const Icon(Icons.refresh_outlined))
        ],
      ),
      body: ListView(
        controller: _listScrollController,
        children: generateListJournalCards(
            windowPage: windowPage,
            currentDay: currentDay,
            database: database,
            refresh: refresh),
      ),
    );
  }

  void refresh() {
    SharedPreferences.getInstance().then((prefs) {
      String? id = prefs.getString("id");
      String? email = prefs.getString('email');
      String? token = prefs.getString("accessToken");
      if (token != null && id != null && email != null) {
        service
            .getAll(id: id, token: token)
            .then((listJournal) {
          setState(() {
            database = {};
            for (Journal journal in listJournal) {
              database[journal.id] = journal;
            }
          });
        });
      }else{
        Navigator.pushReplacementNamed(context, "login");
      }
    });
  }
}
