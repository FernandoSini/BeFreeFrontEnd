import 'dart:convert';

import 'package:be_free_front/Models/EventOwner.dart';
import 'package:flutter/material.dart';

import 'package:be_free_front/Models/User.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class LoginEventOwnerProvider extends ChangeNotifier {
  String username = "";
  String password = "";
  String get userNameData => username;
  String get passwordData => password;
  EventOwner? eventOwner = EventOwner();
  String errorText = "";
  String get errorData => errorText;
  bool isLoggedIn = false;
  bool get isLogged => isLoggedIn;
  bool error = false;
  bool get hasError => true;
  bool loading = false;
  bool get isLoading => loading;

  Future<EventOwner?> login(String username, String password) async {
    String url = "http://192.168.0.136:8080/auth/eventowner/login";
    setLoading(true);
    var body = {"user_name": username, "password": password};
    final loginData = jsonEncode(body);
    print(loginData);
    try {
      http.Response response =
          await http.post(Uri.parse(url), body: loginData, headers: {
        "Content-type": "application/json",
        'Access-Control-Allow-Methods': '*',
        // 'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': '*'
      });
      if (response.statusCode == 200) {
        setLoggedIn(true);
        var body = jsonDecode(response.body);

        print(body);
        setEventOwner(EventOwner.fromJson(body));

        setLoading(false);
        errorText = "";
        return eventOwner;
      } else {
        error = true;
        errorText = "${jsonDecode(response.body)["message"]}";
        setLoading(false);
        notifyListeners();
        return Future.error(errorText);
      }
    } catch (e) {
      setLoading(false);
      error = true;
      errorText = e.toString();
      throw Future.error(errorText);
    }
    // setLoading(false);
  }

  void setEventOwner(eventOwnerValue) {
    eventOwner = eventOwnerValue;
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
}
