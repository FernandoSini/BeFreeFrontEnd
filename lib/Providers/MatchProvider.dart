import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:be_free_front/Models/Match.dart';

class MatchProvider extends ChangeNotifier {
  List<Match>? matches = [];
  List<Match>? get matchData => matches;
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
        for (var data in body) {
          if (matches!.contains(Match.fromJson(data))) {
          } else {
            matches?.add(Match.fromJson(data));
          }
          setLoading(false);
          setErrorText("");
          setError(false);
        }
      } else {
        setError(true);
        setErrorText(jsonDecode(response.body)["message"]);
        setLoading(false);
        return Future.error(errorText);
      }
    } on Exception catch (e) {
      setLoading(false);
      setError(true);
      setErrorText(e.toString());
      throw Future.error(errorText);
    }
  }

  void setErrorText(value) {
    errorText = value;
    notifyListeners();
  }

  void setError(value) {
    error = value;
    notifyListeners();
  }

  void setLoading(newValue) {
    loading = newValue;
    notifyListeners();
  }
}
