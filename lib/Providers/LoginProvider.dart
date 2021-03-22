import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:be_free_front/Models/User.dart';
import 'package:http/http.dart' as http;

class LoginProvider extends ChangeNotifier {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  User userData = User();
  String errorText = "";
  String get errorData => errorText;
  bool isLoggedIn = false;
  bool get isLogged => isLoggedIn;
  bool error = false;
  bool get hasError => true;

  Future<void> login(String username, String password) async {
    String url = "";
    try {
      http.Response response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        error = false;
        var body = jsonDecode(response.body);
        notifyListeners();
      } else {
        error = true;
        errorText = "Algo no json está errado! Tente denovo";
        notifyListeners();
        return Future.error(errorText);
      }
    } catch (e) {
      error = true;
      errorText = e.toString();
      return Future.error(errorText);
    }
  }
}
