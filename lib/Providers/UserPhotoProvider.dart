import 'dart:convert';
import 'dart:io';

import 'package:be_free_v1/Api/Api.dart';
import 'package:be_free_v1/Models/Photos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class UserPhotoProvider extends ChangeNotifier {
  bool loadingData = false;
  bool get isLoading => loadingData;
  String errorData = "";
  String get error => errorData;
  bool err = false;
  bool get hasError => err;
  bool uploaded = false;
  bool get isUploaded => uploaded;
  final storage = new FlutterSecureStorage();
  final Api api = new Api();

  Future<Photos> uploadImage(String yourId, File? image, String? token) async {
    setLoading(true);
    String url = "${api.url}api/users/$yourId/photo/upload";
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
        ..files.add(await http.MultipartFile.fromPath("img", image!.path,
            contentType: image.path.endsWith(".jpg")
                ? MediaType("image", "jpeg")
                : MediaType("image", "png")));

      var response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        setLoading(false);
        setUploaded(true);

        return Photos.fromJson(jsonDecode(response.body));
      } else {
        setError(true);
        setErrorData(jsonDecode(response.body)["error"]);
        setLoading(false);
        notifyListeners();
        return Future.error(errorData);
      }
    } on Exception catch (e) {
      setLoading(false);
      setError(true);
      setErrorData(e.toString());
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

  void setErrorData(newValue) {
    errorData = newValue;
    notifyListeners();
  }

  void setError(newValue) {
    err = newValue;
    notifyListeners();
  }
}
