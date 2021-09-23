import 'dart:convert';

import 'package:be_free_v1/Api/api.dart';
import 'package:flutter/material.dart';

import 'package:be_free_v1/Models/User.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginProvider extends ChangeNotifier {
  String? username;
  String? password;
  String? get userNameData => username;
  String? get passwordData => password;
  User? userData = User();
  String errorText = "";
  String get errorData => errorText;
  bool isLoggedIn = false;
  bool get isLogged => isLoggedIn;
  bool error = false;
  bool get hasError => true;
  bool loading = false;
  bool get isLoading => loading;
  final storage = new FlutterSecureStorage();
  final Api api = new Api();

  Future<User?> login(String? username, String? password) async {
    final String url = "${api.url}user/login";
    setLoading(true);
    var data = {"username": username, "password": password};
    final loginData = jsonEncode(data);
    try {
      http.Response response =
          await http.post(Uri.parse(url), body: loginData, headers: {
        "Content-type": "application/json",
        // 'Access-Control-Allow-Methods': '*',
        // 'Access-Control-Allow-Origin': '*',
        // 'Access-Control-Allow-Headers': '*'
      });
      if (response.statusCode == 200) {
        setLoggedIn(true);
        var body = jsonDecode(
            Utf8Decoder(allowMalformed: true).convert(response.bodyBytes));
        setUser(User.fromJson(body));
        setLoading(false);
        setErrorText("");
        setError(false);
        return userData;
      } else {
        setError(true);
        setErrorText(jsonDecode(response.body)["error"]);
        setLoading(false);
        notifyListeners();
        return Future.error(errorText);
      }
    } catch (e) {
      setLoading(false);
      setError(true);
      errorText = e.toString();
      throw Future.error(errorText);
    }
    // setLoading(false);
  }

  void setUser(userValue) {
    userData = userValue;
    notifyListeners();
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  void setLoggedIn(bool value) {
    isLoggedIn = value;
    notifyListeners();
  }

  void setUserName(value) {
    username = value;
    notifyListeners();
  }

  void setPassword(value) {
    password = value;
    notifyListeners();
  }

  void setErrorText(newValue) {
    errorText = newValue;
    notifyListeners();
  }

  void setError(newValue) {
    error = newValue;
    notifyListeners();
  }

  clear() {
    setError(false);
    setErrorText("");
    setLoading(false);
    setLoggedIn(false);
    setUser(null);
    setUserName(null);
    setPassword(null);
  }
}
