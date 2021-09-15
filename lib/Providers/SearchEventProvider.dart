import 'dart:convert';

import 'package:be_free_v1/Api/Api.dart';
import 'package:be_free_v1/Models/Event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SearchEventProvider extends ChangeNotifier {
  String? eventName;
  String? get eventNameText => eventName;
  String? error;
  String? get errorText => error;
  bool loading = false;
  bool get isLoading => loading;
  bool err = false;
  bool loaded = false;
  bool get isLoaded => loaded;
  bool get hasError => err;
  List<Event>? events = [];
  List<Event>? get eventData => events;
  final storage = new FlutterSecureStorage();
  final Api api = new Api();

  Future<void> searchEventByName(String? eventName, String? token) async {
    clearList();
    setLoading(true);
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token",
    };
    String url = "${api.url}api/events/find?eventname=$eventName";
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        setLoading(false);
        setErrorText("");
        setHasError(false);
        setLoaded(true);
        var responseBody = jsonDecode(
            Utf8Decoder(allowMalformed: true).convert(response.bodyBytes));

        for (var item in responseBody) {
          events?.add(Event.fromJson(item));
          notifyListeners();
        }
      } else {
        setLoading(false);
        setHasError(true);
        setLoaded(true);
        setErrorText(jsonDecode(Utf8Decoder(allowMalformed: true)
            .convert(response.bodyBytes))["error"]);
        return Future.error(errorText!);
      }
    } catch (e) {
      setLoading(false);
      setHasError(true);
      setLoaded(false);
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

  void setLoaded(bool newValue) {
    loaded = newValue;
    notifyListeners();
  }
}
