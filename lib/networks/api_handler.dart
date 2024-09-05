import 'dart:convert';
import 'package:http/http.dart' as http;

import '../repo/shared_preference_repository.dart';
import 'api_urls.dart';

String? authToken;

class ApiHandler {
  Future<dynamic> get({
    required final String url,
    final Map<String, dynamic>? body,
    final bool isAuthApi = true,
  }) async {
    Map<String, String> headers = {};
    if (isAuthApi) headers = await getHeaders();
    final uri = Uri.parse('${ApiUrls.baseUrl}$url');
    final response = await http.get(uri, headers: headers);
    final responseJson = _response(response);
    return responseJson;
  }

  Future<dynamic> post({
    required final String url,
    final Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('${ApiUrls.baseUrl}$url');
    final response = await http.post(uri, body: body);
    final responseJson = _response(response);
    return responseJson;
  }

  dynamic _response(final http.Response? response) {
    if ((response?.statusCode == 200 || response?.statusCode == 201) &&
        response?.body != null) {
      return json.decode(response!.body);
    } else {
      throw Exception('API call failed.');
    }
  }

  Future<Map<String, String>> getHeaders() async {
    if (authToken == null) {
      authToken = await SharedPreferenceRepository.getToken();
    }
    Map<String, String> headers = {};
    if (authToken != null) {
      headers = {
        'x-auth-key': authToken!,
      };
    }
    return headers;
  }
}
