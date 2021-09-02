import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class VerifyUserProvider extends ChangeNotifier {
  bool? userExists = false;
  bool? get hasUser => userExists;
  bool? loading = false;
  bool? get isLoading => loading;
  String? data;
  String? get dataValue => data;
  String? err;
  String? get error => err;
  bool? erro = false;
  bool? get hasError => erro;

  Future<void> verifyIfUserExists() async {
    String? url =
        "http://${dotenv.env["url"]}:${dotenv.env["port"]}/forgot-password/verify";
    setLoading(true);
    var data = {"data": dataValue};
    var body = json.encode(data);

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {"Content-type": "application/json"},
        body: body,
      );
      if (response.statusCode == 200) {
        setLoading(false);
        setHasUser(true);
        setHasError(false);
      } else {
        setLoading(false);
        setHasError(true);
        setHasUser(null);
        setError(jsonDecode(response.body)["error"]);
        return Future.error(error!);
      }
    } catch (e) {
      setLoading(false);
      setHasError(true);
      setError(e.toString());
      setHasUser(null);
      return Future.error(error!);
    }
  }

  setLoading(bool? newValue) {
    loading = newValue;
    notifyListeners();
  }

  setHasUser(bool? newValue) {
    userExists = newValue;
    notifyListeners();
  }

  setHasError(bool? newValue) {
    erro = newValue;
    notifyListeners();
  }

  setError(String? newValue) {
    err = newValue;
    notifyListeners();
  }

  setData(String? newValue) {
    data = newValue;
    notifyListeners();
  }

  clear() {
    setHasError(null);
    setHasUser(null);
    setLoading(false);
    setError(null);
    setData(null);
  }
}
