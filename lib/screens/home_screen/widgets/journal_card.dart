import 'dart:async';
import 'dart:io';

import 'package:alura_web_api_app_v2/screens/common/exception_dialog.dart';
import 'package:flutter/material.dart';
import 'package:alura_web_api_app_v2/helpers/weekday.dart';
import 'package:alura_web_api_app_v2/models/journal.dart';
import 'package:uuid/uuid.dart';
import 'package:alura_web_api_app_v2/services/journal_service.dart';
import 'package:alura_web_api_app_v2/screens/common/confirmation_dialog.dart';
import 'package:alura_web_api_app_v2/screens/home_screen/home_screen.dart';

class JournalCard extends StatelessWidget {
  final Journal? journal;
  final DateTime showedDate;
  final Function refresh;
  final String userId;
  final String token;
  const JournalCard(
      {super.key,
      this.journal,
      required this.showedDate,
      required this.refresh,
      required this.userId,
      required this.token});

  @override
  Widget build(BuildContext context) {
    JournalService service = JournalService();
    if (journal != null) {
      return InkWell(
        onTap: () {
          callAddJournalScreen(context, journal: journal);
        },
        child: Container(
          height: 115,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black87,
            ),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    height: 75,
                    width: 75,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      border: Border(
                          right: BorderSide(color: Colors.black87),
                          bottom: BorderSide(color: Colors.black87)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      journal!.createdAt.day.toString(),
                      style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 38,
                    width: 75,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Colors.black87),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(WeekDay(journal!.createdAt.weekday).short),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    journal!.content,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  var confirmationDialog = showConfirmationDialog(
                    context,
                    content: 'Deseja excluir este registro?',
                    confirmation: 'sim',
                    cancel: 'não',
                  );
                  confirmationDialog.then((value) {
                    if (value == false) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("registro não removido")));
                      return;
                    }
                    service.removeJournal(journal!.id, token).then((value) {
                      if (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("registro removido")));
                        refresh();
                      }
                    }).catchError(
                      (error) {
                        logout(context);
                      },
                      test: (error) => error is TokenNotValidException,
                    ).catchError(
                      (error) {
                        showExceptionDialog(context,
                            message: "Servidor inoperante");
                      },
                      test: (error) => error is TimeoutException,
                    ).catchError(
                      (error) {
                        var innerError = error as HttpException;
                        showExceptionDialog(context,
                            message: innerError.message);
                      },
                      test: (error) => error is HttpException,
                    );
                  });
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          callAddJournalScreen(context);
        },
        child: Container(
          height: 115,
          alignment: Alignment.center,
          child: Text(
            "${WeekDay(showedDate.weekday).short} - ${showedDate.day}",
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  void callAddJournalScreen(BuildContext context, {Journal? journal}) {
    Journal innerJournal = Journal(
        id: const Uuid().v1(),
        content: "",
        createdAt: showedDate,
        updatedAt: showedDate,
        userId: userId);

    if (journal != null) {
      innerJournal = journal;
    }

    Navigator.pushNamed(context, "add-journal", arguments: innerJournal)
        .then((value) {
      if (value != null && value == true) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("registro feito com sucesso")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("registro não realizado")));
      }
      refresh();
    }).catchError(
      (error) {
        logout(context);
      },
      test: (error) => error is TokenNotValidException,
    ).catchError(
      (error) {
        showExceptionDialog(context, message: "Servidor inoperante");
      },
      test: (error) => error is TimeoutException,
    ).catchError(
      (error) {
        var innerError = error as HttpException;
        showExceptionDialog(context, message: innerError.message);
      },
      test: (error) => error is HttpException,
    );
  }
}
