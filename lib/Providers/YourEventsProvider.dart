import 'dart:convert';

import 'package:be_free_v1/Models/Event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class YourEventsProvider extends ChangeNotifier {
  List<Event>? events = [];
  List<Event>? get eventData => events;
  bool loadingData = false;
  bool get isLoading => loadingData;
  String errorData = "";
  String get error => errorData;
  bool err = false;
  bool get hasError => err;

  Future<void> getYourEvents(String token, String yourId) async {
    events?.clear();
    setLoading(true);
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      };
      String url =
          "http://${dotenv.env["url"]}:${dotenv.env["port"]}/api/events/yourEvents?yourId=$yourId";
      http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        var body = json.decode(
            Utf8Decoder(allowMalformed: true).convert(response.bodyBytes));
        for (var item in body) {
          if (events!.contains(Event.fromJson(item))) {
          } else {
            events!.add(Event.fromJson(item));
          }
        }
        setLoading(false);
      } else {
        setLoading(false);
        setError(
            true,
            jsonDecode(Utf8Decoder(allowMalformed: true)
                .convert(response.bodyBytes))["error"]);
        notifyListeners();
        return Future.error(errorData);
      }
    } on Exception catch (e) {
      setLoading(false);
      setError(true, e.toString());
      return Future.error(errorData);
    }
  }

  void setLoading(newValue) {
    loadingData = newValue;
    notifyListeners();
  }

  void setError(bool errValue, String errorText) {
    err = errValue;
    errorData = errorText;
    notifyListeners();
  }
}
