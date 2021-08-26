import 'dart:convert';

import 'package:be_free_v1/Models/Message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MessagesProvider extends ChangeNotifier {
  bool loading = false;
  bool get isLoading => loading;
  bool error = false;
  bool get hasError => error;
  String? textError;
  String? get errorText => textError;
  List<Message>? messages = [];

  // Future<void> getMessages(
  //     String token, String senderId, String receiverId) async {
  //   messages?.clear();
  //   setLoading(true);
  //   String url =
  //       "http://192.168.0.22:8080/api/chat/messages/all/by/$senderId/$receiverId";
  //   Map<String, String> headers = {
  //     "Content-type": "application/json",
  //     "Authorization": "Bearer $token",
  //   };
  //   try {
  //     http.Response response = await http.get(Uri.parse(url), headers: headers);
  //     if (response.statusCode == 200) {
  //       var body = jsonDecode(
  //           Utf8Decoder(allowMalformed: true).convert(response.bodyBytes));
  //       setLoading(false);
  //       setErrorText("");
  //       setHasError(false);
  //       for (var item in body) {
  //         messages?.add(Message.fromJson(item));
  //       }
  //       messages?.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
  //     } else {
  //       setLoading(false);
  //       setErrorText(jsonDecode(Utf8Decoder(allowMalformed: true)
  //           .convert(response.bodyBytes))["message"]);
  //       return Future.error(errorText!);
  //     }
  //   } catch (e) {
  //     setLoading(false);
  //     setHasError(true);
  //     setErrorText(e.toString());
  //     throw Future.error(errorText!);
  //   }
  // }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void setHasError(bool value) {
    error = value;
    notifyListeners();
  }

  void setErrorText(String value) {
    textError = value;
    notifyListeners();
  }

  void setMessages(Message? message) {
    messages?.add(message!);
    notifyListeners();
  }
}
// import 'package:flutter/material.dart';
// import 'package:be_free_v1/Models/Message.dart';

// class MessagesProvider extends ChangeNotifier {
//   List<Message>? messages = [];

//   void addMessage(Message? message) {
//     messages?.add(message!);
//     notifyListeners();
//   }
// }
