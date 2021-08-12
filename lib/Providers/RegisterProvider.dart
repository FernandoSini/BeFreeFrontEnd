import 'dart:convert';

import 'package:be_free_v1/Models/Gender.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:date_format/date_format.dart';

class RegisterProvider extends ChangeNotifier {
  String? userName;

  String? get userNameValue => userName;
  String? firstName;

  String? get firstNameValue => firstName;
  String? lastName;

  String? get lastNameValue => lastName;
  String? password;

  String? get password1 => password;

  String? password2text;

  String? get password2 => password2text;

  String? email;

  String? get emailValue => email;

  bool get isPasswordValid =>
      password1 == password2 && (password1!.length > 6 || password1 == null);

  // String get newPasswordError {
  //   if (password1!.isNotEmpty && password1!.length < 6) {
  //     return "Password too short";
  //   } else if (password1 != password2) {
  //     return "Passwords must be the same";
  //   } else {
  //     return "";
  //   }
  // }

  DateTime? birthday;

  DateTime? get birthdayValue => birthday;

  bool get isAdult => DateTime.now().year - birthday!.year >= 18;

  Gender? gender;

  Gender? get genderValue => gender;

  String? error;

  String? get errorData => error;

  bool errorValue = false;

  bool get hasError => errorValue;

  String? school;

  String? get schoolValue => school;

  String? company;

  String? get companyValue => company;

  String? livesIn;

  String? get livesInValue => livesIn;

  String? job;

  String? get jobValue => job;

  bool loading = false;

  bool get isLoading => loading;

  bool registered = false;

  bool get isRegistered => registered;

  String? message;

  String? get messageValue => message;

  Future<void> register() async {
    setLoading(true);
    Map dadosLogin = {
      "user_name": userNameValue,
      "first_name": firstNameValue,
      "last_name": lastNameValue,
      "password": password1,
      "email": emailValue,
      "gender": EnumToString.convertToString(genderValue!),
      "birthday": formatDate(birthdayValue!, [
        dd,
        '/',
        mm,
        '/',
        yyyy,
      ]).toString(),
      "school": schoolValue,
      "company": companyValue,
      "livesIn": livesInValue,
      "job_title": jobValue,
    };
    String url = "http://192.168.0.22:8080/register";
    var body = json.encode(dadosLogin);
    try {
      http.Response response = await http.post(Uri.parse(url),
          body: body,
          headers: {"Content-type": "application/json; charset=utf-8"});
      if (response.statusCode == 200) {
        setLoading(false);
        setHasError(false);
        setIsRegistered(true);
        setMessageRegistered(
            Utf8Decoder(allowMalformed: true).convert(response.bodyBytes));
        setError("");
      } else {
        setLoading(false);
        setIsRegistered(false);
        setHasError(true);
        setError(jsonDecode(Utf8Decoder(allowMalformed: true)
            .convert(response.bodyBytes))["message"]);
        return Future.error(error!);
      }
    } catch (e) {
      setLoading(false);
      setIsRegistered(false);
      setError(e.toString());
      setHasError(true);
      setMessageRegistered("");
      throw Future.error(error!);
    }
  }

  void setSchool(newValue) {
    school = newValue;
    notifyListeners();
  }

  void setJob(newValue) {
    job = newValue;
    notifyListeners();
  }

  void setCompany(newValue) {
    company = newValue;
    notifyListeners();
  }

  void setLivesIn(newValue) {
    livesIn = newValue;
    notifyListeners();
  }

  void setBirthiday(newValue) {
    birthday = newValue;
    notifyListeners();
  }

  void setGender(newValue) {
    gender = newValue;
    notifyListeners();
  }

  void setHasError(newValue) {
    errorValue = newValue;
    notifyListeners();
  }

  void setError(newValue) {
    error = newValue;
    notifyListeners();
  }

  void setPassword1(newValue) {
    password = newValue;
    notifyListeners();
  }

  void setPassword2(newValue) {
    password2text = newValue;
    notifyListeners();
  }

  void setUsername(newValue) {
    userName = newValue;
    notifyListeners();
  }

  void setFirstName(newValue) {
    firstName = newValue;
    notifyListeners();
  }

  void setLastName(newValue) {
    lastName = newValue;
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

  void setIsRegistered(newValue) {
    registered = newValue;
    notifyListeners();
  }

  void setMessageRegistered(newValue) {
    message = newValue;
    notifyListeners();
  }
}
