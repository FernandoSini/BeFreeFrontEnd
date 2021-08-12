import 'dart:convert';

import 'package:be_free_v1/Models/EventOwner.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateEventOwnerProvider extends ChangeNotifier {
  String? eventOwnerName;
  String? get eventOwnerNameData => eventOwnerName;

  int? documentNumber;
  int? get documentNumberData => documentNumber;

  String? email;
  String? get emailData => email;

  bool loading = false;
  bool get isLoading => loading;

  bool err = false;
  bool get hasError => err;

  bool update = false;
  bool get isUpdated => update;

  String? error;
  String? get errorData => error;

  Future<void> updateEventOwner(String token, String ownerId) async {
    setLoading(true);
    String url = "http://192.168.0.22:8080/api/eventowner/updateOwner/$ownerId";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    EventOwner? eventOwner = EventOwner(
        eventOwnerId: ownerId,
        eventOwnerName: eventOwnerNameData,
        documentNumber: documentNumberData,
        email: emailData);
    print(eventOwner.toJson());
    try {
      http.Response response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: json.encode(
          eventOwner.toJson(),
        ),
      );
      if (response.statusCode == 200) {
        setUpdated(true);
        setLoading(false);
        setError(false);
        setErrorText("");
      } else {
        setLoading(false);
        setError(true);
        setErrorText(jsonDecode(Utf8Decoder(allowMalformed: true)
            .convert(response.bodyBytes))["message"]);
        setUpdated(false);
        return Future.error(errorData!);
      }
    } catch (e) {
      setLoading(false);
      setError(true);
      setErrorText(e.toString());
      setUpdated(false);
      return Future.error(errorData!);
    }
  }

  void setLoading(bool newValue) {
    loading = newValue;
    notifyListeners();
  }

  void setError(bool value) {
    err = value;
    notifyListeners();
  }

  void setErrorText(String? value) {
    error = value;
    notifyListeners();
  }

  void setUpdated(bool value) {
    update = value;
    notifyListeners();
  }

  void setEventOwnerName(String? value) {
    eventOwnerName = value;
    notifyListeners();
  }

  void setDocumentNumber(int? value) {
    documentNumber = value;
    notifyListeners();
  }

  void setEmail(String? value) {
    email = value;
    notifyListeners();
  }
}
