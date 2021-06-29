import 'dart:convert';

import 'package:be_free_front/Models/Event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchEventProvider extends ChangeNotifier {
  String? eventName;
  String? get eventNameText => eventName;
  String? error;
  String? get errorText => error;
  bool loading = false;
  bool get isLoading => loading;
  bool err = false;
  bool get hasError => err;
  List<Event>? events = [];
  List<Event>? get eventData => events;

  Future<void> searchEventByName(String? eventName, String? token) async {
    clearList();
    setLoading(true);
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token",
    };
    String url = "http://192.168.0.136:8080/api/events/find/$eventName";

    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        setLoading(false);
        setErrorText("");
        setHasError(false);
        var responseBody = jsonDecode(
            Utf8Decoder(allowMalformed: true).convert(response.bodyBytes));

        for (var item in responseBody) {
          events?.add(Event.fromJson(item));
          notifyListeners();
        }
      } else {
        setLoading(false);
        setHasError(true);
        setErrorText(jsonDecode(Utf8Decoder(allowMalformed: true)
            .convert(response.bodyBytes))["message"]);
        return Future.error(errorText!);
      }
    } catch (e) {
      setLoading(false);
      setHasError(true);
      setErrorText(e.toString());
      throw Future.error(errorText!);
    }
  }

  void setEventName(value) {
    eventName = value;
    notifyListeners();
  }

  void setErrorText(value) {
    error = value;
    notifyListeners();
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  void setHasError(value) {
    err = value;
    notifyListeners();
  }

  void setListEvents(Event value) {
    events?.add(value);
    notifyListeners();
  }

  void clearList() {
    events?.clear();
    notifyListeners();
  }
}
