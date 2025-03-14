import 'dart:convert';
import 'dart:io';

import 'package:alura_web_api_app_v2/models/journal.dart';
import 'package:http/http.dart' as http;
import 'package:alura_web_api_app_v2/services/web_client.dart';

class JournalService {
  static String url = WebClient.URL;
  static const String resource = "journals/";
  static String getUrl() => "$url$resource";

  http.Client client = WebClient().client;

  Future<bool> register(Journal journal, {required String token}) async {
    
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.post(
      Uri.parse(getUrl()),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonJournal,
    );
    if (response.statusCode != 201) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }
    return true;
  }

  Future<List<Journal>> getAll(
      {required String id, required String token}) async {
    http.Response response =
        await client.get(Uri.parse('${url}user/$id/$resource'), headers: {
      "Authorization": "Bearer $token",
    });
    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }
    List<Journal> lista = [];
    List<dynamic> listaDynamic = json.decode(response.body);
    for (var value in listaDynamic) {
      Map<String, dynamic> newMap = {};
      value.forEach(
        (key, value) {
          if (key == "userId") {
            value = value.toString();
          }
          newMap[key] = value;
        },
      );
      lista.add(Journal.fromMap(newMap));
    }
    return lista;
  }

  Future<bool> edit(Journal journal, {required String token}) async {
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.put(
      Uri.parse('${getUrl()}${journal.id}'),
      headers: {"Authorization": "Bearer $token"},
      body: jsonJournal,
    );
    if (response.statusCode != 201) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }
    return true;
  }

  Future<bool> removeJournal(String id, String token) async {
    http.Response response = await client.delete(
      Uri.parse("${getUrl()}$id"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }
    return true;
  }
}

class JournalEditException implements Exception {
  final String message;
  JournalEditException(this.message);
}

class TokenNotValidException implements Exception {}
