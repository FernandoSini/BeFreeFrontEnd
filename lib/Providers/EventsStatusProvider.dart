import 'dart:convert';

import 'package:be_free_v1/Models/Event.dart';
import 'package:be_free_v1/Models/EventStatus.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventsStatusProvider extends ChangeNotifier {
  List<Event>? events = [];
  List<Event>? get eventData => events;
  bool loadingData = false;
  bool get isLoading => loadingData;
  String errorData = "";
  String get error => errorData;
  bool err = false;
  bool get hasError => err;

  Future<void> getEventsByStatus(String token, EventStatus eventStatus) async {
    events?.clear();
    setLoading(true);

    try {
      Map<String, String> headers = {
        "Content-type": "application/json; charset=utf-8",
        "Authorization": "Bearer $token"
      };
      String url =
          "http://192.168.0.22:3000/api/events?eventstatus=${EnumToString.convertToString(eventStatus)}";
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
        setErr(false);
        setError("");
        setLoading(false);
        // return events;
      } else {
        setErr(true);
        setError(jsonDecode(response.body)["error"]);
        setLoading(false);

        return Future.error(errorData);
      }
    } on Exception catch (e) {
      setLoading(false);
      setErr(true);
      setError(e.toString());
      return Future.error(errorData);
    }
  }

  void setLoading(newValue) {
    loadingData = newValue;
    notifyListeners();
  }

  void setError(newValue) {
    errorData = newValue;
    notifyListeners();
  }

  void setErr(newValue) {
    err = newValue;
    notifyListeners();
  }
}
