import 'dart:convert';

import 'package:be_free_v1/Api/Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:be_free_v1/Models/Match.dart';

class MatchProvider extends ChangeNotifier {
  List<Match>? matches = [];
  List<Match>? get matchData => matches;
  bool loading = false;
  bool get isLoading => loading;
  bool error = false;
  bool get hasError => error;
  String errorText = "";
  String get errorData => errorText;
  final storage = new FlutterSecureStorage();
  final Api api = new Api();

  Future<void> getMatches(String token, String yourId) async {
    matches?.clear();
    String url = "${api.url}api/matches/$yourId";
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
        setErrorText(jsonDecode(response.body)["error"]);
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
