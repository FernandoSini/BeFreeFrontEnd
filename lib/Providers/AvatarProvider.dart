import 'package:be_free_v1/Api/Api.dart';
import 'package:be_free_v1/Models/AvatarProfile.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  File? image;
  File? get imageData => image;
  final storage = new FlutterSecureStorage();
  final Api api = new Api();

  Future<AvatarProfile?> uploadAvatar(
      String yourId, File? avatar, String? token) async {
    setLoading(true);
    String url = "${api.url}api/users/$yourId/upload/avatar/";
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
        ..files.add(await http.MultipartFile.fromPath("img", avatar!.path,
            contentType: avatar.path.endsWith(".jpg")
                ? MediaType("image", "jpeg")
                : MediaType("image", "png")));

      var response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        setLoading(false);
        setUploaded(true);
        setError(false);
        AvatarProfile avatarProfile =
            AvatarProfile.fromJson(jsonDecode(response.body));
        notifyListeners();
        return avatarProfile;
      } else {
        setLoading(false);
        setUploaded(false);
        setError(true);
        setErrorText(jsonDecode(response.body)["err"]);
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

  Future<AvatarProfile> changeAvatar(String yourId, String? token) async {
    String url = "${api.url}api/users/avatar/update/$yourId";
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
        ..files.add(await http.MultipartFile.fromPath("img", imageData!.path,
            contentType: imageData!.path.endsWith(".jpg")
                ? MediaType("image", "jpeg")
                : MediaType("image", "png")));

      var response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        setLoading(false);
        setError(false);
        setErrorText("");
        setUpdated(true);
        AvatarProfile avatarProfile =
            AvatarProfile.fromJson(jsonDecode(response.body));
        notifyListeners();
        return avatarProfile;
      } else {
        setLoading(false);
        setError(true);
        setUpdated(false);
        setErrorText(jsonDecode(response.body)["err"]);
        return Future.error(errorData);
      }
    } catch (e) {
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

  void setImage(File? newValue) {
    image = newValue;
    notifyListeners();
  }

  void clear() {
    setImage(null);
    setError(false);
    setErrorText("");
    setLoading(false);
    setUpdated(false);
    setUploaded(false);
  }
}
