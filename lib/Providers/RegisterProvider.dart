import 'dart:convert';

import 'package:be_free_front/Models/Gender.dart';
import 'package:be_free_front/Models/Graduation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class RegisterProvider extends ChangeNotifier {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool get isPasswordValid =>
      passwordController.text == password2Controller.text &&
      (passwordController.text.length > 6 || passwordController.text.isEmpty);
  String get newPasswordError {
    if (passwordController.text.isNotEmpty &&
        passwordController.text.length < 6) {
      return "Password too short";
    } else if (passwordController.text != password2Controller.text) {
      return "Passwords must be the same";
    } else {
      return "";
    }
  }

  DateTime? birthday;
  DateTime? get birthdayValue => birthday;

  bool get isAdult => DateTime.now().year - birthday!.year >= 18;
  List<Graduation>? graduations = [];
  List<Graduation>? get graduationsDisponible => graduations;

  Graduation? yourGraduationSelected;
  Graduation? get graduationData => yourGraduationSelected;

  Gender? gender;
  Gender? get genderValue => gender;
  String error = "";
  bool hasError = false;
  bool get containError => hasError;
  String get errorData => error;

  Future<void> register(String userName, String password, String email) async {
    Map dadosLogin = {
      "user_name": userName,
      "password": password,
      "email": email,
      "gender": genderValue,
      "userGraduations": graduations,
      "birthday": birthdayValue,
    };
    notifyListeners();
  }

  Future<List<Graduation?>> fetchGraduations() async {
    try {
      http.Response response = await http.get(
        Uri.parse(("http://192.168.0.136:8080/graduations/all")),
        headers: {"Content-Type": "application/json"},
      );

      List<Graduation>? graduationList = [];
      if (response.statusCode == 200) {
        setHasError(false);
        List jsonData = jsonDecode(response.body);

        graduationList = jsonData.map((e) => Graduation.fromJson(e)).toList();

        return graduationList;
      } else {
        throw Future.error(
            "Error trying to connect to db:" + response.statusCode.toString());
      }
    } catch (e) {
      setHasError(true);
      setError(e.toString());
      return Future.error(errorData);
    }
  }

  void setGraduationListToSelect(value) {
    graduations = value;
    notifyListeners();
  }

  void setYourGraduation(value) {
    yourGraduationSelected = value;
    print("$graduationData" + userNameController.text);
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
}
