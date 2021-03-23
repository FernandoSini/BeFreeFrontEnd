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
  DateTime birthday;
  DateTime get birthdayValue => birthday;
  bool get isAdult => DateTime.now().year - birthday.year >= 18;
  List<Graduation> graduations;
  Gender gender;
  Gender get genderValue => gender;

  Future<void> register(String userName, String password, String email) async {
    Map dadosLogin = {
      "user_name": userName,
      "password": password,
      "email": email,
      "gender": gender,
      "userGraduations": graduations
    };
  }
}
