import 'dart:convert';

import 'package:be_free_v1/Models/LikesReceived.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class LikesReceivedProvider extends ChangeNotifier {
  List<User>? likesReceived = [];
  List<User>? get likesData => likesReceived;
  bool loading = false;
  bool get isLoading => loading;
  bool error = false;
  bool get hasError => error;
  String errorText = "";
  String get errorData => errorText;

  Future<void> getLikesReceived(String token, String yourId) async {
    likesReceived?.clear();
    likesData?.clear();
    String url =
        "http://${dotenv.env["url"]}:${dotenv.env["port"]}/api/users/likes/received/$yourId";
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
          if (likesReceived!.contains(User.fromJson(data))) {
          } else {
            likesReceived?.add(User.fromJson(data));
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
