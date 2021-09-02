import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class LikeProvider extends ChangeNotifier {
  String? error = "";
  String? get errorText => error;
  bool loading = false;
  bool get isLoading => false;
  bool err = false;
  bool get hasError => err;
  bool like = false;
  bool isLiked = true;

  Future<void> setLike(
      String? yourId, String? idPeopleLiked, String? token) async {
    setLoading(true);
    String url =
        "http://${dotenv.env["url"]}:${dotenv.env["port"]}/api/users/$yourId/like/$idPeopleLiked";
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      };
      http.Response response = await http.put(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        setLoading(false);
        setError(false);
        setErrorText(null ?? "");
        setLiked(true);
      } else {
        setLoading(false);
        setError(true);
        setErrorText(json.decode(response.body)["error"]);
        return Future.error(errorText!);
      }
    } catch (e) {
      setLoading(false);
      setError(true);
      setErrorText(e.toString());
      return Future.error(errorText!);
    }
  }

  void setErrorText(String value) {
    error = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void setError(bool value) {
    err = value;
    notifyListeners();
  }

  void setLiked(bool value) {
    like = value;
    notifyListeners();
  }
}
