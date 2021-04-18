
import 'package:be_free_front/Models/EventOwner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as universal;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EventOwnerProvider extends ChangeNotifier {
  EventOwner? eventOwner = EventOwner();
  final storage = new FlutterSecureStorage();

  void setEventOwner(EventOwner? value) {
    eventOwner = value;
    print("data" + eventOwner!.token.toString());
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
      Map<String, String> eventOwnerData = {
        "event_owner_id": eventOwner!.eventOwnerId!,
        "event_owner_name": eventOwner.eventOwnerName!,
        "document_number": eventOwner.documentNumber!.toString(),
        "event_owner_email":
            eventOwner.email == null ? null.toString() : eventOwner.email!,
        "event_owner_avatar":
            eventOwner.avatar == null ? null.toString() : eventOwner.avatar!,
        // "events": eventOwner.events!,
        "event_owner_token": eventOwner.token!,
      };
      eventOwnerData.forEach((key, value) async {
        await storage.write(key: key, value: value);
      });
    } else {
      if (eventOwner?.token != null) {
        // universal.window.localStorage["user"] = user.toString();
        // universal.window.localStorage["token"] = user!.token!;
        Map<String, String> eventOwnerData = {
          "event_owner_id": eventOwner!.eventOwnerId!,
          "event_owner_name": eventOwner.eventOwnerName!,
          "document_number": eventOwner.documentNumber!.toString(),
          "event_owner_email": eventOwner.email!,
          "event_owner_avatar": eventOwner.avatar!,
          // "events": eventOwner.events!.toList().toString(),
          "event_owner_token": eventOwner.token!,
        };
        universal.window.sessionStorage.addEntries(eventOwnerData.entries);
        // universal.window.localStorage["user"] = user.toString();
        // universal.window.localStorage["token"] = user?.token;
        // final LocalStorage localStorage = new LocalStorage("userData");
        eventOwnerData.forEach((key, value) {
          // localStorage.setItem(key, value);
          universal.window.localStorage[key] = value;

          // Cookie cookie = new Cookie("flemis:$key", value);
          // universal.window.cookieStore?.set(cookie.name, cookie.value);

          // universal.window.cookieStore!.set(key, value);
        });

        // user.toJson().forEach((key, value) {
        //   // localStorage.setItem(key, value);
        //   universal.window.localStorage[key] = value;
        // });
      }
    }
  }
}
