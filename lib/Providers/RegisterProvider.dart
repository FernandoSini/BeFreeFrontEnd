import 'dart:convert';

import 'package:be_free_front/Models/Gender.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class RegisterProvider extends ChangeNotifier {
  String userName = "";
  String password1 = "";
  String password2 = "";
  String email = "";
  bool get isPasswordValid =>
      password1 == password2 && (password1.length > 6 || password1.isEmpty);
  String get newPasswordError {
    if (password1.isNotEmpty && password1.length < 6) {
      return "Password too short";
    } else if (password1 != password2) {
      return "Passwords must be the same";
    } else {
      return "";
    }
  }

  DateTime? birthday;
  DateTime? get birthdayValue => birthday;

  bool get isAdult => DateTime.now().year - birthday!.year >= 18;

  Gender? gender;
  Gender? get genderValue => gender;
  String error = "";
  bool hasError = false;
  bool get containError => hasError;
  String get errorData => error;
  String school = "";
  String get schoolValue => school;
  String company = "";
  String get companyValue => company;
  String livesIn = "";
  String get livesInValue => livesIn;
  String job = "";
  String get jobValue => job;

  Future<void> register(String userName, String password, String email) async {
    Map dadosLogin = {
      "user_name": userName,
      "password": password,
      "email": email,
      "gender": genderValue,
      "birthday": birthdayValue,
      "school": schoolValue,
      "company": companyValue,
      "livesIn": livesInValue,
      "job": jobValue,
    };
    notifyListeners();
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
    hasError = newValue;
    notifyListeners();
  }

  void setError(newValue) {
    error = newValue;
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

  void setUsername(newValue) {
    userName = newValue;
    notifyListeners();
  }
}
