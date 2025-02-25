import 'dart:convert';

import 'package:alura_web_api_app_v2/models/journal.dart';
import 'package:alura_web_api_app_v2/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

class JournalService {
  static const String url = "http://192.168.1.3:3000/";
  static const String resource = "journals/";
  static String getUrl() => "$url$resource";
  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  Future<bool> register(Journal journal) async {
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.post(
      Uri.parse(getUrl()),
      headers: {"Content-type": "application/json"},
      body: jsonJournal,
    );
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<List<Journal>> getAll() async {
    http.Response response = await client.get(Uri.parse(getUrl()));
    if (response.statusCode != 200) {
      throw Exception();
    }
    List<Journal> lista = [];
    List<dynamic> listaDynamic = json.decode(response.body);
    for (var value in listaDynamic) {
      lista.add(Journal.fromMap(value));
    }
    return lista;
  }

  Future<bool> edit(String id, Journal journal) async {
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.put(
      Uri.parse('${getUrl()}$id'),
      headers: {"Content-type": "application/json"},
      body: jsonJournal,
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> removeJournal(String id) async {
    http.Response response = await client.delete(Uri.parse("${getUrl()}$id"));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
