import 'dart:convert';
import 'dart:io';

import 'package:http_interceptor/http/http.dart';
import 'package:http/http.dart' as http;
import 'package:alura_web_api_app_v2/services/http_interceptors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alura_web_api_app_v2/services/ip_server.dart' as ip;

class AuthService {
  static String url = ip.URL;

  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  Future<bool> login({required String email, required String password}) async {
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

  Future<bool> register(
      {required String email, required String password}) async {
    Map<String, dynamic> data = {"email": email, "password": password};

    http.Response response =
        await client.post(Uri.parse("${url}register"), body: data);

    if (response.statusCode != 201) {
      throw UserNotRegisterException(response.statusCode as String);
    }
    saveUserInfos(response.body);
    return true;
  }

  Future<bool> saveUserInfos(String body) async {
    var map = json.decode(body);

    String token = map['accessToken'];
    String email = map['user']['email'];
    String id = map['user']['id'].toString();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', token);
    prefs.setString('email', email);
    prefs.setString('id', id);

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
