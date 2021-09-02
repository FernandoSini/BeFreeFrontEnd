import 'dart:convert';

import 'package:be_free_v1/Models/User.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
            "http://${dotenv.env["url"]}:${dotenv.env["port"]}/api/users/gender/find/different?gender=${EnumToString.convertToString(user?.gender)}"),
        headers: {
          "Authorization": "Bearer ${user?.token}",
          "Content-type": "application/json"
        },
      );
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        for (var data in body) {
          if (userListFromAPi!.contains(User.fromJson(data))) {
          } else {
            userListFromAPi?.add(User.fromJson(data));
            userListFromAPi?.shuffle();
          }
        }
        setLoading(false);
        setError("");
        setErr(false);
        return userListFromAPi;
      } else {
        setErr(true);

        setError(jsonDecode(response.body)["error"]);
        setLoading(false);
        return Future.error(errorData);
      }
    } on Exception catch (e) {
      setLoading(false);
      setErr(true);
      setError(e.toString());
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

  void setError(newValue) {
    errorData = newValue;
    notifyListeners();
  }

  void setErr(newValue) {
    err = newValue;
    notifyListeners();
  }
}
