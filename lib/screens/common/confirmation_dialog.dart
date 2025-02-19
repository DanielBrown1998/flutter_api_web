import 'package:flutter/material.dart';

Future<dynamic> showConfirmationDialog(
  BuildContext context, 
  {String title = 'Atençao', 
  String content="Você deseja executar esta ação?", 
  String confirmation = 'Confirmar',
  String cancel = 'Cancelar',
  }){
  return showDialog(
    context: context, 
    builder: (context) {  
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            }, 
            child: Text(cancel)
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            }, 
            child: Text(confirmation)
          ),
        ],
      );
    });
}
