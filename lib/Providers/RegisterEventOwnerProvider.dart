import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterEventOwnerProvider extends ChangeNotifier {
  String? userName;

  String? get userNameValue => userName;
  String? password1;

  String? get password1Value => password1;
  String? password2;

  String? get password2Value => password2;
  String? email;

  String? get emailValue => email;
  int? documentNumber = 0;

  int? get documentNumberValue => documentNumber;

  bool get isPasswordValid =>
      password1Value == password2Value &&
      (password1Value!.length > 6 || password1Value == null);

  // String get newPasswordError {
  //   if (password1.isNotEmpty && password1.length < 6) {
  //     return "Password too short";
  //   } else if (password1 != password2) {
  //     return "Passwords must be the same";
  //   } else {
  //     return "";
  //   }
  // }
  bool loading = false;

  bool get isLoading => loading;
  bool eventOwnerRegistered = false;

  bool get isEventOwnerRegistered => eventOwnerRegistered;
  bool error = false;

  bool get hasError => error;
  String? errorText;

  String? get errorValue => errorText;

  String? message;
  String? get messageRegistered => message;

  Future<void> register() async {
    setLoading(true);
    Map dadosLogin = {
      "event_owner_name": userNameValue,
      "document_number": documentNumberValue,
      "password": password1Value,
      "event_owner_email": emailValue,
    };
    var body = json.encode(dadosLogin);
    String url = "http://192.168.0.136:8080/register/eventowner";
    try {
      http.Response response = await http.post(Uri.parse(url), body: body, headers: {"Content-type": "application/json; charset=utf-8"});
      if (response.statusCode == 200) {
        setLoading(false);
        setIsEventOwnerRegistered(true);
        setHasError(false);
        setMessage(
            Utf8Decoder(allowMalformed: true).convert(response.bodyBytes));
        setErrorValue("");
      } else {
        setLoading(false);
        setIsEventOwnerRegistered(false);
        setMessage("");
        setHasError(true);
        setErrorValue(jsonDecode(Utf8Decoder(allowMalformed: true)
            .convert(response.bodyBytes))["message"]);
        return Future.error(errorValue!);
      }
    } catch (e) {
      setLoading(false);
      setIsEventOwnerRegistered(false);
      setHasError(true);
      setErrorValue(e.toString());
      throw Future.error(errorValue!);
    }
  }

  void setMessage(newValue) {
    message = newValue;
    notifyListeners();
  }

  void setDocumentNumber(newValue) {
    documentNumber = newValue;
    notifyListeners();
  }

  void setPassword1(newValue) {
    password1 = newValue;
    notifyListeners();
  }

  void setPassword2(newValue) {
    password2 = newValue;
    notifyListeners();
  }

  void setUserName(newValue) {
    userName = newValue;
    notifyListeners();
  }

  void setEmail(newValue) {
    email = newValue;
    notifyListeners();
  }

  void setLoading(newValue) {
    loading = newValue;
    notifyListeners();
  }

  void setErrorValue(newValue) {
    errorText = newValue;
    notifyListeners();
  }

  void setHasError(newValue) {
    error = newValue;
    notifyListeners();
  }

  void setIsEventOwnerRegistered(newValue) {
    eventOwnerRegistered = newValue;
    notifyListeners();
  }
}
