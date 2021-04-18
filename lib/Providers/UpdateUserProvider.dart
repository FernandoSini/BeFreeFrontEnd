import 'package:be_free_front/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateUserProvider extends ChangeNotifier {
  User? updatedUser = User();

  Future<void>? updateUser(String id, String token) async {
    String url = "http://192.168.0.136:8080/api/users/update/$id";
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      };

      http.Response response = await http.put(Uri.parse(url),
          headers: headers, body: "");
    } catch (e) {}
  }




}
