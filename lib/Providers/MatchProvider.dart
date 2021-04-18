import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:be_free_front/Models/Match.dart';

class MatchProvider extends ChangeNotifier {
  List<Match>? matches = [];
  bool loading = false;
  bool get isLoading => loading;
  bool error = false;
  bool get hasError => error;
  String errorText = "";
  String get errorData => errorText;

  Future<void> getMatches(String token, String yourId) async {
    matches?.clear();
    String url = "http://192.168.0.136:8080/api/matches/$yourId";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    try {
      setLoading(true);
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        print(body);
        for (var data in body) {
          if (matches!.contains(Match.fromJson(data))) {
          } else {
            matches?.add(Match.fromJson(data));
          }
          setLoading(false);
          errorText = "";
          error = false;
          notifyListeners();
        }
      } else {
        error = true;
        errorText = "${jsonDecode(response.body)["message"]}";
        setLoading(false);
        notifyListeners();
        return Future.error(errorText);
      }
    } on Exception catch (e) {
      setLoading(false);
      error = true;
      errorText = e.toString();
      throw Future.error(errorText);
    }
  }

  void setLoading(newValue) {
    loading = newValue;
    notifyListeners();
  }
}
