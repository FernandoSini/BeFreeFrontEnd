import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class AvatarProvider extends ChangeNotifier {
  bool loadingData = false;
  bool get isLoading => loadingData;
  String errorText = "";
  String get errorData => errorText;
  bool err = false;
  bool get hasError => err;
  bool uploaded = false;
  bool get isUploaded => uploaded;
  bool updated = false;
  bool get isUpdated => updated;

  Future<void> uploadAvatar(String yourId, File? avatar, String? token) async {
    setLoading(true);
    String url = "http://192.168.0.136:8080/api/avatar/upload/$yourId";
    // Map<String, String> imageMap = {"file": basename(image!.path)};
    // var body = jsonEncode(imageMap);
    try {
      // http.Response response = await http.post(Uri.parse(url),
      //     headers: {
      //       "Content-type": "application/json",
      //       "Authorization": "Bearer $token"
      //     },
      //     body: body);

      Map<String, String> headers = {
        "Authorization": "Bearer $token",
      };

      var request = new http.MultipartRequest("POST", Uri.parse(url))
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath("file", avatar!.path,
            contentType: avatar.path.endsWith(".jpg")
                ? MediaType("image", "jpeg")
                : MediaType("image", "png")));

      var response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        setLoading(false);
        setUploaded(true);
      } else {
        setLoading(false);
        setUploaded(false);
        setError(true);
        setErrorText(jsonDecode(response.body)["message"]);
        return Future.error(errorData);
      }
    } on Exception catch (e) {
      setLoading(false);
      setError(true);
      setUploaded(false);
      setErrorText(e.toString());
      return Future.error(errorData);
    }
  }

  Future<void> changeAvatar(String yourId, File? avatar, String? token) async {
    String url = "http://192.168.0.136:8080/api/avatar/update/$yourId";
    // Map<String, String> imageMap = {"file": basename(image!.path)};
    // var body = jsonEncode(imageMap);
    try {
      // http.Response response = await http.post(Uri.parse(url),
      //     headers: {
      //       "Content-type": "application/json",
      //       "Authorization": "Bearer $token"
      //     },
      //     body: body);

      Map<String, String> headers = {
        "Authorization": "Bearer $token",
      };

      var request = new http.MultipartRequest("PUT", Uri.parse(url))
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath("file", avatar!.path,
            contentType: avatar.path.endsWith(".jpg")
                ? MediaType("image", "jpeg")
                : MediaType("image", "png")));

      var response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        setLoading(false);
        setError(false);
        setErrorText("");
        setUpdated(true);
      } else {
        setLoading(false);
        setError(true);
        setUpdated(false);
        setErrorText(jsonDecode(response.body)["message"]);
        return Future.error(errorData);
      }
    } on Exception catch (e) {
      setLoading(false);
      setError(true);
      setUpdated(false);
      setErrorText(e.toString());
      return Future.error(errorData);
    }
  }

  void setUpdated(bool value) {
    updated = value;
    notifyListeners();
  }

  void setUploaded(bool newValue) {
    uploaded = newValue;
    notifyListeners();
  }

  void setLoading(newValue) {
    loadingData = newValue;
    notifyListeners();
  }

  void setError(bool value) {
    err = value;
    notifyListeners();
  }

  void setErrorText(String value) {
    errorText = value;
    notifyListeners();
  }
}
