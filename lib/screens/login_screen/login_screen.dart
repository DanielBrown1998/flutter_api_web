import 'dart:async';
import 'dart:io';

import 'package:alura_web_api_app_v2/screens/common/confirmation_dialog.dart';
import 'package:alura_web_api_app_v2/screens/common/exception_dialog.dart';
import 'package:flutter/material.dart';
import 'package:alura_web_api_app_v2/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(32),
        decoration:
            BoxDecoration(border: Border.all(width: 8), color: Colors.white),
        child: Form(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(
                    Icons.bookmark,
                    size: 64,
                    color: Colors.brown,
                  ),
                  const Text(
                    "Simple Journal",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text("por Alura",
                      style: TextStyle(fontStyle: FontStyle.italic)),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(thickness: 2),
                  ),
                  const Text("Entre ou Registre-se"),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("E-mail"),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(label: Text("Senha")),
                    keyboardType: TextInputType.visiblePassword,
                    maxLength: 16,
                    obscureText: true,
                    controller: _passwordController,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        login(context,
                            email: _emailController.text,
                            password: _passwordController.text);
                      },
                      child: const Text("Continuar")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  login(BuildContext context,
      {required String email, required String password}) async {
    authService.login(email: email, password: password).then(
      (bool result) {
        if (result) {
          Navigator.pushReplacementNamed(context, "home");
        }
      },
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
    ).catchError(
      (error) {
        showConfirmationDialog(context,
                title: "Usuário não encontrado",
                content: "Deseja se registrar com os dados passados?",
                confirmation: "Registrar",
                cancel: "Cancelar")
            .then((value) {
          if (value != null && value) {
            authService
                .register(email: email, password: password)
                .then((bool value) {
              if (value) {
                Navigator.pushNamed(context, "home");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Usuário registrado com sucesso!"),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            }).catchError(
              (error) {
                var innerError = error as UserNotRegisterException;
                showExceptionDialog(context, message: innerError.message);
              },
              test: (error) => error is UserNotRegisterException,
            );
          }
        });
      },
      test: (error) => error is UserNotFindException,
    );
  }
}
