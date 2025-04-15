// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;

Future<http.Response> DSIPostRequest(String API, Object BODY) async {
  http.Response resp = await http.post(Uri.parse(API), body: BODY);
  return resp;
}
