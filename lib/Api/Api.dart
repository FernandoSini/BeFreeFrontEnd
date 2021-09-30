import 'dart:io';

class Api {
  // final url = "https://befree-backend.herokuapp.com/";
  final url = const String.fromEnvironment("APP_SERVER_URL",
      defaultValue: "https://befree-backend.herokuapp.com/");
  // final url = Platform.environment["APP_SERVER_URL"];
  // final String url = "http://192.168.0.22:3000/";
  final String key = "url";
}
