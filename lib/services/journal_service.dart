import 'dart:convert';

import 'package:alura_web_api_app_v2/models/journal.dart';
import 'package:alura_web_api_app_v2/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

http.Client client =
    InterceptedClient.build(interceptors: [LoggingInterceptor()]);

class JournalService {
  static const String url = "http://192.168.1.3:3000/";
  static const String resource = "journals/";
  static String getUrl() => "$url$resource";

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

  Future<String> get() async {
    http.Response response = await http.get(Uri.parse(getUrl()));
    print(response.body);
    return response.body;
  }
}
