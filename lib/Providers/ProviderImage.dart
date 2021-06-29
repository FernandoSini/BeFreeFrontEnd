import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class ProviderImage extends ChangeNotifier {
  bool loadingData = false;
  bool get isLoading => loadingData;
  String errorData = "";
  String get error => errorData;
  bool err = false;
  bool get hasError => err;
  bool uploaded = false;
  bool get isUploaded => uploaded;

  Future<void> uploadImage(String yourId, File? image, String? token) async {
    String url = "http://192.168.0.136:8080/api/images/uploadimage/$yourId";
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
        ..files.add(await http.MultipartFile.fromPath("file", image!.path,
            contentType: image.path.endsWith(".jpg")
                ? MediaType("image", "jpeg")
                : MediaType("image", "png")));

      var response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        setLoading(false);
        setUploaded(true);
      } else {
        err = true;
        errorData = "";
        setLoading(false);
        notifyListeners();
        return Future.error(errorData);
      }
    } on Exception catch (e) {
      setLoading(false);
      print("aaaaaa");
      err = true;
      errorData = e.toString();
      notifyListeners();
      return Future.error(errorData);
    }
  }

  void setUploaded(bool newValue) {
    uploaded = newValue;
    notifyListeners();
  }

  void setLoading(newValue) {
    loadingData = newValue;
    notifyListeners();
  }
}
