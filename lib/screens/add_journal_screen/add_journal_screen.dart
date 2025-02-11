import 'package:alura_web_api_app_v2/helpers/weekday.dart';
import 'package:alura_web_api_app_v2/models/journal.dart';
import 'package:flutter/material.dart';

class AddJournalScreen extends StatelessWidget {
  final Journal journal;
  const AddJournalScreen({super.key, required this.journal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("${WeekDay(journal.createdAt.weekday).long.toLowerCase()}    "
                "${journal.createdAt.day} | "
                "${journal.createdAt.month} | "
                "${journal.createdAt.year}"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.check))],
      ),
      body: const Padding(
        padding: EdgeInsets.only(
            left: 8.0, right: 8.0, top: 12.0, bottom: 12.0),
        child: TextField(
          keyboardType: TextInputType.multiline,
          style: TextStyle(
            fontSize: 24,
          ),
          expands: true,
          minLines: null,
          maxLines: null,
        ),
      ),
    );
  }
}
