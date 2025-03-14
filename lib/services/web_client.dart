import 'package:alura_web_api_app_v2/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

class WebClient {
  static String IP_SERVER = '192.168.1.3';
  static String PORT = "3000";
  static String URL = 'http://$IP_SERVER:$PORT/';

  http.Client client = InterceptedClient.build(interceptors: [LoggingInterceptor()], requestTimeout: const Duration(seconds: 10));

}
