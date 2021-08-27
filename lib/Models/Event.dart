// import 'package:be_free_v1/Models/EventOwner.dart';

// import 'EventStatus.dart';
// import 'User.dart';
// import 'package:intl/intl.dart';
// import 'package:enum_to_string/enum_to_string.dart';

// class Event {
//   String? eventId;
//   String? eventName;
//   String? eventCover;
//   String? eventDescription;
//   String? eventLocation;
//   List<User>? users;
//   EventStatus? eventStatus;
//   DateTime? startDate;
//   DateTime? endDate;
//   EventOwner? eventOwner;

//   Event(
//       {this.eventId,
//       this.eventName,
//       this.eventCover,
//       this.eventDescription,
//       this.eventLocation,
//       this.users,
//       this.startDate,
//       this.endDate,
//       this.eventStatus,
//       this.eventOwner});

//   Event.fromJson(Map<String, dynamic> json) {
//     eventId = json['event_id'];
//     eventName = json['event_name'];
//     eventCover = json['event_cover'];
//     eventDescription = json['event_description'];
//     eventLocation = json["event_location"];
//     eventOwner = json['event_owner'] != null
//         ? new EventOwner.fromJson(json['event_owner'])
//         : null;
//     if (json['users'] != null) {
//       users = <User>[];
//       json['users'].forEach((v) {
//         users!.add(new User.fromJson(v));
//       });
//     }
//     startDate = new DateFormat("dd-MM-yyyy HH:mm:ss").parse(json['start_date']);
//     endDate = new DateFormat("dd-MM-yyyy HH:mm:ss").parse(json['end_date']);
//     eventStatus =
//         EnumToString.fromString(EventStatus.values, json['event_status']);
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['event_id'] = this.eventId;
//     data['event_name'] = this.eventName;
//     data['event_cover'] = this.eventCover;
//        if (this.eventOwner != null) {
//       data['event_owner'] = this.eventOwner!.toJson();
//     }
//     if (this.users != null) {
//       data['users'] = this.users!.map((v) => v.toJson()).toList();
//     }
//     data['start_date'] =
//         DateFormat("dd-MM-yyyy HH:mm:ss").format(this.startDate!).toString();
//     data['end_date'] =
//         DateFormat("dd-MM-yyyy HH:mm:ss").format(this.endDate!).toString();
//     if (this.eventStatus != null) {
//       data['event_status'] = EnumToString.convertToString(this.eventStatus);
//     }
//     data['event_description'] = this.eventDescription;
//     data["event_location"] = this.eventLocation;
//     return data;
//   }
// }
import 'package:be_free_v1/Models/EventPhoto.dart';
import 'package:be_free_v1/Models/EventStatus.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:intl/intl.dart';

import 'User.dart';

class Event {
  List<User>? users;
  EventStatus? eventStatus;
  String? id;
  User? eventOwner;
  String? eventName;
  String? eventDescription;
  EventPhoto? eventPhoto;
  DateTime? startDate;
  DateTime? endDate;
  String? eventLocation;

  Event(
      {this.users,
      this.eventStatus,
      this.id,
      this.eventOwner,
      this.eventName,
      this.eventDescription,
      this.startDate,
      this.eventPhoto,
      this.endDate,
      this.eventLocation});

  Event.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = <User>[];
      json['users'].forEach((v) {
        users?.add(new User.fromJson(v));
      });
    }
    eventStatus = json["event_status"] == null
        ? null
        : EnumToString.fromString(EventStatus.values, json['event_status']);
    id = json['_id'] == null ? null : json["_id"];
    eventOwner = json['event_owner'] != null
        ? new User.fromJson(json['event_owner'])
        : null;
    eventName = json['event_name'] == null ? null : json["event_name"];
    eventDescription =
        json['event_description'] == null ? null : json["event_description"];
    startDate = json["start_date"] == null
        ? null
        : DateTime.tryParse(json["start_date"])!.toLocal();
    endDate = json["end_date"] == null
        ? null
        : DateTime.tryParse(json["end_date"])!.toLocal();
    eventLocation =
        json['event_location'] == null ? null : json["event_location"];
    eventPhoto = json['event_cover'] != null
        ? new EventPhoto.fromJson(json['event_cover'])
        : null;
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList().toString();
    }
    if (this.eventStatus != null)
      data['event_status'] = EnumToString.convertToString(this.eventStatus);
    if (this.id != null) data['_id'] = this.id!;
    if (this.eventOwner != null) {
      data['event_owner'] = this.eventOwner!.id!;
    }
    if (this.eventName != null) data['event_name'] = this.eventName!;
    if (this.eventDescription != null)
      data['event_description'] = this.eventDescription!;
    // data['start_date'] =
    //     DateFormat("dd-MM-yyyy HH:mm:ss").format(this.startDate!).toString();
    // data['end_date'] =
    //     DateFormat("dd-MM-yyyy HH:mm:ss").format(this.endDate!).toString();
    if (this.startDate != null) data['start_date'] = this.startDate!.toString();
    if (this.endDate != null) data['end_date'] = this.endDate!.toString();
    // if (this.eventPhoto != null) {
    //   data['event_cover'] = this.eventPhoto!.toJson().toString();
    // }
    if (this.eventLocation != null)
      data['event_location'] = this.eventLocation!;
    return data;
  }
}
