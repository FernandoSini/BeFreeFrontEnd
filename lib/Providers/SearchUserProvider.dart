import 'package:be_free_v1/Models/Gender.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:flutter/material.dart';

class SearchUserProvider extends ChangeNotifier {
  Gender? gender;
  Gender? get genderValue => gender;
  int? minAge = 18;
  int? get minAgeValue => minAge;
  int? maxAge = 100;
  int? get maxAgeValue => maxAge;
  String? username;
  String? get usernameData => username;
  bool error = false;
  bool get hasError => error;

  Future<List<User>?> searchUsers() async{


  }

  void setGender(newValue) {
    gender = newValue;
    notifyListeners();
  }

  void setMinAge(int? newValue) {
    minAge = newValue;
    notifyListeners();
  }

  void setMAxAge(int? newValue) {
    maxAge = newValue;
    notifyListeners();
  }

  void setUsername(String? value) {
    username = value;
    notifyListeners();
  }

  void setHasError(bool newValue) {
    error = newValue;
    notifyListeners();
  }
}
