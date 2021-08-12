import 'package:be_free_v1/Models/Gender.dart';
import 'package:flutter/material.dart';

class SearchUserProvider extends ChangeNotifier {
  Gender? gender;

  Gender? get genderValue => gender;

  void setGender(newValue) {
    gender = newValue;
    notifyListeners();
  }
}
