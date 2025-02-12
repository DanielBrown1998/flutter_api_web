import 'package:alura_web_api_app_v2/helpers/weekday.dart';
import 'package:alura_web_api_app_v2/models/journal.dart';
import 'package:alura_web_api_app_v2/services/journal_service.dart';
import 'package:flutter/material.dart';

class AddJournalScreen extends StatelessWidget {
  final Journal journal;
  AddJournalScreen({super.key, required this.journal});

  final TextEditingController _contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("${WeekDay(journal.createdAt.weekday).long.toLowerCase()}    "
                "${journal.createdAt.day} | "
                "${journal.createdAt.month} | "
                "${journal.createdAt.year}"),
        actions: [
          IconButton(
              onPressed: () {
                registerJournal(context);
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 8.0, right: 8.0, top: 12.0, bottom: 12.0),
        child: TextField(
          keyboardType: TextInputType.multiline,
          controller: _contentController,
          style: const TextStyle(
            fontSize: 24,
          ),
          expands: true,
          minLines: null,
          maxLines: null,
        ),
      ),
    );
  }

  registerJournal(BuildContext context) async {
    String content = _contentController.text;
    JournalService service = JournalService();
    journal.content = content;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("inserindo...")));
    bool result = await service.register(journal);
    Navigator.pop(context, result);
  }
}
