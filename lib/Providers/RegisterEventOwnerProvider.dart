import 'package:flutter/material.dart';

class RegisterEventOwnerProvider extends ChangeNotifier {
  String userName = "";
  String password1 = "";
  String password2 = "";
  String email = "";
  String avatar = "";
  int documentNumber = 0;
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

  Future<void> register(String userName, String password, String email) async {
    Map dadosLogin = {
      "event_owner_name": userName,
      "document_number": documentNumber,
      "password": password,
      "email": email,
      "avatar": avatar,
    };
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

  void setAvatar(newValue) {
    avatar = newValue;
    notifyListeners();
  }

  void setEmail(newValue) {
    email = newValue;
    notifyListeners();
  }
  
}
