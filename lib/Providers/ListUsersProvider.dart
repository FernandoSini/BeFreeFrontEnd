import 'dart:convert';

import 'package:be_free_front/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListUsersProvider extends ChangeNotifier {
  List<User>? userListFromAPi = [];
  List<User>? get userList => userListFromAPi;
  String errorData = "";
  String get error => errorData;
  bool err = false;
  bool get hasError => err;
  bool loading = false;
  bool get isLoading => loading;
  bool apiLoaded = false;
  bool get isApiLoaded => apiLoaded;

  Future<List<User>?> getListOfUsersByYourGender(User? user) async {
    userListFromAPi?.clear();
    setLoading(true);
    try {
      http.Response response = await http.get(
        Uri.parse(
            "http://192.168.0.136:8080/api/users/gender/find/${user?.gender}"),
        headers: {
          "Authorization": "Bearer ${user?.token}",
          "Content-type": "application/json"
        },
      );
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        // print("teste body: " + body.toString());
        for (var data in body) {
          // userListFromAPi?.forEach((element) {
          //   if (element != User.fromJson(data)) {
          //     userListFromAPi?.add(User.fromJson(data));
          //   } else {}
          // });
          if (userListFromAPi!.contains(User.fromJson(data))) {
          } else {
            userListFromAPi?.add(User.fromJson(data));
            userListFromAPi?.shuffle();
          }
        }
        setLoading(false);
        return userListFromAPi;
      } else {
        err = true;
        errorData = "${jsonDecode(response.body)["message"]}";
        setLoading(false);
        notifyListeners();
        return Future.error(errorData);
      }
    } on Exception catch (e) {
      setLoading(false);
      err = true;
      errorData = e.toString();
      return Future.error(errorData);
    }
  }

  void setLoading(newValue) {
    loading = newValue;
    notifyListeners();
  }

  // void getUsersfromApi(User? user) async {
  //   setLoading(true);
  //   userListFromAPi = await getListOfUsersByYourGender(user);
  //   setLoading(false);
  //   notifyListeners();
  // }

  void setApiLoaded(value) {
    apiLoaded = value;
    notifyListeners();
  }
}
