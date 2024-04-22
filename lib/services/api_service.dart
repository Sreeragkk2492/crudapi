import 'dart:convert';

import 'package:http/http.dart' as http;

class Apiservice {
  final deleteendpoint = '/employees/';
  static Future<dynamic> getdata() async {
    final response = await http.get(Uri.parse('http://3.84.189.66/employees/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw (Exception);
    }
  }

  static Future<dynamic> deletedata({required String endpoint}) async {
    final response =
        await http.delete(Uri.parse("http://3.84.189.66/$endpoint"));
    if (response.statusCode == 204) {
      return jsonDecode(response.body);
    } else {
      throw (Exception);
    }
  }

  static Future<dynamic> postdata({required String endpoint, Map? data}) async {
    final response = await http.post(Uri.parse('http://3.84.189.66/$endpoint'),
        body: jsonEncode(data), headers: {'content-type': 'application/json'});
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw (Exception);
    }
  }

  static Future<dynamic> updatedata({required String endpoint, Map? data}) async {
    final response = await http.patch(
      Uri.parse('http://3.84.189.66/$endpoint'),
      body: jsonEncode(data), 
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw (Exception);
    }
  }
}
