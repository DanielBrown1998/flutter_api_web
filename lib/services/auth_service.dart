import 'dart:convert';
import 'dart:io';

import 'package:http_interceptor/http/http.dart';
import 'package:http/http.dart' as http;
import 'package:alura_web_api_app_v2/services/http_interceptors.dart';

class AuthService {
  //TODO: modularizar a url;
  static const String url = "http://10.0.0.104:3000/";

  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  login({required String email, required String password}) async {
    http.Response response = await client.post(Uri.parse("${url}login"),
        body: {"email": email, "password": password});
    if (response.statusCode != 200) {
      String content = json.decode(response.body);
      switch (content) {
        case "Cannot find user":
          throw UserNotFindException();
        default:
          throw HttpException(response.statusCode as String);
      }
    }
    return true;
  }

  register({required String email, required String password}) async {
    http.Response response = await client.post(Uri.parse("${url}register"),
        body: {"email": email, "password": password});

    if (response.statusCode != 201) {
      throw UserNotRegisterException(response.statusCode as String);
    }
  }
}

class UserNotFindException implements Exception {
  final String message = "Usuário não encontrado";
}

class UserNotRegisterException implements Exception {
  final String message;
  UserNotRegisterException(this.message);
}
