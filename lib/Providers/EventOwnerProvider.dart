import 'dart:convert';

import 'package:be_free_v1/Models/EventOwner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as universal;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EventOwnerProvider extends ChangeNotifier {
  EventOwner? eventOwner = EventOwner();
  final storage = new FlutterSecureStorage();

  void setEventOwner(EventOwner? value) {
    eventOwner = value;
    notifyListeners();
    saveDataOnSecurePlace(eventOwner);
  }
  // Future<User?> loadData() async {
  //   if (defaultTargetPlatform == TargetPlatform.android ||
  //       defaultTargetPlatform == TargetPlatform.iOS) {

  //     await storage.read(key: "token");
  //    return await storage.read(key: "user");
  //   } else {

  //       html.window.localStorage.containsKey("user");
  //       html.window.localStorage.containsKey("token");
  //     }
  //   }

  void saveDataOnSecurePlace(EventOwner? eventOwner) async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      // Map<String, String> eventOwnerData = {
      //   "event_owner_id": eventOwner!.eventOwnerId!,
      //   "event_owner_name": eventOwner.eventOwnerName!,
      //   "document_number": eventOwner.documentNumber!.toString(),
      //   "event_owner_email":
      //       eventOwner.email == null ? null.toString() : eventOwner.email!,
      //   "event_owner_avatar":
      //       eventOwner.avatar == null ? null.toString() : eventOwner.avatar!,
      //   // "events": eventOwner.events!,
      //   "event_owner_token": eventOwner.token!,
      // };
      // eventOwnerData.forEach((key, value) async {
      //   await storage.write(key: key, value: value);
      // });

      await storage.write(
          key: "event_owner", value: jsonEncode(eventOwner!.toJson()));
      notifyListeners();
    }
  }
}
