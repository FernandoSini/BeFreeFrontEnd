import 'dart:convert';

import 'package:be_free_v1/Api/Api.dart';
import 'package:be_free_v1/Models/Event.dart';
import 'package:be_free_v1/Models/EventStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class EventsProvider extends ChangeNotifier {
  List<Event>? events = [];
  List<Event>? get eventData => events;
  bool loadingData = false;
  bool get isLoading => loadingData;
  String errorData = "";
  String get error => errorData;
  bool err = false;
  bool get hasError => err;
  final storage = new FlutterSecureStorage();
  final Api api = new Api();
  
  Future<void> getEvents(String token, EventStatus eventStatus) async {
    events?.clear();
    setLoading(true);
    try {
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      };
      String url = "${api.url}api/events/all";
      http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        for (var item in body) {
          if (events!.contains(Event.fromJson(item))) {
          } else {
            events!.add(Event.fromJson(item));
          }
        }
        setLoading(false);
        // return events;
      } else {
        err = true;
        errorData = "${jsonDecode(response.body)["message"]}";
        setLoading(false);
        notifyListeners();
        return Future.error(errorData);
      }
    } on Exception catch (e) {
      setLoading(false);
      err = true;
      errorData = e.toString();
      return Future.error(errorData);
    }
  }

  void setLoading(newValue) {
    loadingData = newValue;
    notifyListeners();
  }
}
