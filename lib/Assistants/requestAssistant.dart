import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> getRequest(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    try {
      if (response.statusCode == 200) {
        String JsonData = response.body;
        var decodeData = jsonDecode(JsonData);
        return decodeData;
      } else {
        return "Failed, no response";
      }
    } catch (exp) {
      return "Failed.";
    }
  }
}
