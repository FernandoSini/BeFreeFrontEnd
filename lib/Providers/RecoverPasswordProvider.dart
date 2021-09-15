import 'dart:convert';
import 'package:be_free_v1/Api/Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RecoverPasswordProvider extends ChangeNotifier {
  bool? updated = false;
  bool? get isUpdated => updated;
  String? updateError;
  String? get updateErrorData => updateError;
  String? newPasswordValue;
  String? get newPassword => newPasswordValue;
  bool? updating = false;
  bool? get isUpdating => updating;
  bool? errorUpdate = false;
  bool? get hasErrorUpdate => errorUpdate;
  String? data = "";
  String? get dataValue => data;
  final storage = new FlutterSecureStorage();
  final Api api = new Api();

  Future<void> changePassword() async {
    String? urlReset = "${api.url}forgot-password/reset";
    setUpdating(true);
    var data = {"data": dataValue, "newPassword": newPassword};
    var body = jsonEncode(data);
    Map<String, String> headers = {"Content-type": "application/json"};

    try {
      http.Response response = await http.put(
        Uri.parse(urlReset),
        body: body,
        headers: headers,
      );
      if (response.statusCode == 200) {
        setUpdating(false);
        setUpdated(true);
        setHasErrorUpdate(false);
        setUpdateError(null);
      } else {
        setUpdateError(jsonDecode(response.body)["error"]);
        setUpdated(false);
        setUpdating(false);
        setHasErrorUpdate(true);
        Future.error(updateErrorData!);
      }
    } catch (e) {
      setUpdating(false);
      setUpdateError(e.toString());
      setUpdated(false);
      setHasErrorUpdate(true);
      Future.error(updateErrorData!);
    }
  }

  void setUpdateError(String? newValue) {
    updateError = newValue;
    notifyListeners();
  }

  void setHasErrorUpdate(bool? newValue) {
    errorUpdate = newValue;
    notifyListeners();
  }

  void setUpdating(bool? newValue) {
    updating = newValue;
    notifyListeners();
  }

  void setUpdated(bool? newValue) {
    updated = newValue;
    notifyListeners();
  }

  void setNewPassword(String? value) {
    newPasswordValue = value;
    notifyListeners();
  }

  setData(String? value) {
    data = value;
    notifyListeners();
  }

  clear() {
    setNewPassword(null);
    setUpdated(null);
    setHasErrorUpdate(null);
    setUpdating(null);
    setData(null);
  }
}
