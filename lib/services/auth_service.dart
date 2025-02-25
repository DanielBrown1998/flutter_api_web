import 'dart:convert';
import 'dart:io';

import 'package:http_interceptor/http/http.dart';
import 'package:http/http.dart' as http;
import 'package:alura_web_api_app_v2/services/http_interceptors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //TODO: modularizar a url;
  static const String url = "http://192.168.1.3:3000/";

  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  login({required String email, required String password}) async {
    Map<String, dynamic> data = {"email": email, "password": password};

    http.Response response =
        await client.post(Uri.parse("${url}login"), body: data);
    if (response.statusCode != 200) {
      String content = json.decode(response.body);
      switch (content) {
        case "Cannot find user":
          throw UserNotFindException();
        default:
          throw HttpException(response.statusCode as String);
      }
    }
    saveUserInfos(response.body);
    return true;
  }

  register({required String email, required String password}) async {
    Map<String, dynamic> data = {"email": email, "password": password};

    http.Response response =
        await client.post(Uri.parse("${url}register"), body: data);

    if (response.statusCode != 201) {
      throw UserNotRegisterException(response.statusCode as String);
    }
    saveUserInfos(response.body);
  }

  Future<bool> saveUserInfos(String body) async {
    var map = json.decode(body);

    String token = map['token'];
    String email = map['user']['email'];
    int id = int.parse(map['user']['id']);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setString('email', email);
    prefs.setInt('id', id);

    String? tokenSave = prefs.getString('token');

    return true;
  }
}

class UserNotFindException implements Exception {
  final String message = "Usuário não encontrado";
}

class UserNotRegisterException implements Exception {
  final String message;
  UserNotRegisterException(this.message);
}
