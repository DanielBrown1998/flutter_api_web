import 'dart:convert';

import 'package:alura_web_api_app_v2/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

http.Client client =
    InterceptedClient.build(interceptors: [LoggingInterceptor()]);

class JournalService {
  static const String url = "http://192.168.1.3:3000/";
  static const String resource = "learnhttp/";
  static JsonEncoder encoder = JsonEncoder();
  static String getUrl() => url + resource;

  register(String content) async {
    var response = await http.post(
      Uri.parse(getUrl()),
      body: encoder.convert({'content': content}),
    );
    print(response.body);
    return response.body;
  }

  Future<String> get() async {
    http.Response response = await http.get(Uri.parse(getUrl()));
    print(response.body);
    return response.body;
  }
}
