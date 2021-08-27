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
