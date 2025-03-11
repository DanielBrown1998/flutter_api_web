import 'package:flutter/material.dart';

Future<dynamic> showExceptionDialog(BuildContext context,
    {required String message}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("ERROR"),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text("voltar")),
          ],
        );
      });
}
