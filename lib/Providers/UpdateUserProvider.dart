import 'dart:convert';

import 'package:be_free_v1/Models/Gender.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UpdateUserProvider extends ChangeNotifier {
  String? username;
  String? get newUsername => username;
  String? firstName;
  String? get newFirstName => firstName;
  String? lastName;
  String? get newLastName => lastName;
  String? livesIn;
  String? get newLivesIn => livesIn;
  String? school;
  String? get newSchool => school;
  String? birthday;
  String? get newBirthday => birthday;
  String? email;
  String? get newEmail => email;
  String? job;
  String? get newJob => job;
  String? company;
  String? get newCompany => company;
  String? about;
  String? get newAbout => about;
  Gender? gender;
  Gender? get newGender => gender;
  String? err;
  String? get errorData => err;
  bool error = false;
  bool get hasError => error;
  bool loading = false;
  bool get isLoading => loading;
  bool updated = false;
  bool get isUpdated => updated;

  Future<User?> updateUser(String? id, String? token) async {
    setLoading(true);
    String url =
        "http://${dotenv.env["url"]}:${dotenv.env["port"]}/api/users/you/edit/$id";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };

    // Map<String, dynamic> userToUpdate = {
    //   "id_user": id,
    //   "about": newAbout == null ? null : newAbout,
    //   "company": newCompany == null ? null : newCompany,
    //   "job": newJob == null ? null : newJob,
    //   "gender":
    //       newGender == null ? null : EnumToString.convertToString(newGender),
    //   "email": newEmail == null ? null : newEmail,
    //   "firstname": newFirstName == null ? null : newFirstName,
    //   "lastname": newLastName == null ? null : newLastName,
    //   "username": newUsername == null ? null : newUsername,
    //   "school": newSchool == null ? null : newSchool,
    //   "livesIn": newLivesIn == null ? null : newLivesIn,
    //   "birthday": newBirthday == null ? null : newBirthday
    // };
    User? userToUpdate = User(
        about: newAbout,
        company: newCompany,
        job: newJob,
        gender: newGender,
        email: newEmail,
        username: newUsername,
        firstname: newFirstName,
        lastname: newLastName,
        school: newSchool,
        livesIn: newLivesIn,
        birthday: newBirthday);
    var body = jsonEncode(userToUpdate.toJsonUpdate());

    try {
      http.Response response =
          await http.put(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        setUpdated(true);
        setLoading(false);
        setHasError(false);
        setErrorText("");

        User user = User.fromJson(
          json.decode(
            Utf8Decoder(allowMalformed: true).convert(response.bodyBytes),
          ),
        );
        user.token = token;
        return user;
      } else {
        setLoading(false);
        setHasError(true);
        setErrorText(jsonDecode(response.body)["error"]);
        setUpdated(false);
        return Future.error(errorData!);
      }
    } catch (e) {
      setLoading(false);
      setHasError(true);
      setErrorText(e.toString());
      setUpdated(false);
      return Future.error(errorData!);
    }
  }

  void setNewUsername(String? value) {
    username = value;
    notifyListeners();
  }

  setNewEmail(String? value) {
    email = value;
    notifyListeners();
  }

  void setNewAbout(String? value) {
    about = value;
    notifyListeners();
  }

  void setNewJob(String? value) {
    job = value;
    notifyListeners();
  }

  void setNewCompany(String? value) {
    company = value;
    notifyListeners();
  }

  setNewGender(value) {
    gender = value;
    notifyListeners();
  }

  void setNewFirstName(value) {
    firstName = value;
    notifyListeners();
  }

  void setNewLastName(value) {
    lastName = value;
    notifyListeners();
  }

  void setNewLivesIn(value) {
    livesIn = value;
    notifyListeners();
  }

  void setNewSchool(value) {
    school = value;
    notifyListeners();
  }

  void setBirthday(value) {
    birthday = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void setUpdated(bool value) {
    updated = value;
    notifyListeners();
  }

  void setHasError(bool value) {
    error = value;
    notifyListeners();
  }

  void setErrorText(String value) {
    err = value;
    notifyListeners();
  }

  void clear() {
    setBirthday(null);
    setNewAbout(null);
    setNewCompany(null);
    setNewEmail(null);
    setNewFirstName(null);
    setNewGender(null);
    setNewLastName(null);
    setNewUsername(null);
    setNewJob(null);
    setNewSchool(null);
    setNewLivesIn(null);
  }
}
