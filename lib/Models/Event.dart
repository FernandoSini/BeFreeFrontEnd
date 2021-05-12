import 'EventStatus.dart';
import 'User.dart';
import 'package:intl/intl.dart';
import 'package:enum_to_string/enum_to_string.dart';

class Event {
  String? eventId;
  String? eventName;
  String? eventCover;
  String? eventDescription;
  String? eventLocation;
  List<User>? users;
  EventStatus? eventStatus;
  DateTime? startDate;
  DateTime? endDate;

  Event(
      {this.eventId,
      this.eventName,
      this.eventCover,
      this.eventDescription,
      this.eventLocation,
      this.users,
      this.startDate,
      this.endDate,
      this.eventStatus});

  Event.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    eventName = json['event_name'];
    eventCover = json['event_cover'];
    eventDescription = json['event_description'];
    eventLocation = json["event_location"];
    if (json['users'] != null) {
      users = <User>[];
      json['users'].forEach((v) {
        users!.add(new User.fromJson(v));
      });
    }
    startDate = new DateFormat("dd-MM-yyyy hh:mm:ss").parse(json['start_date']);
    endDate = new DateFormat("dd-MM-yyyy hh:mm:ss").parse(json['end_date']);
    eventStatus =
        EnumToString.fromString(EventStatus.values, json['event_status']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['event_name'] = this.eventName;
    data['event_cover'] = this.eventCover;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    data['start_date'] = this.startDate!.toString();
    data['end_date'] = this.endDate!.toString();
    data['event_status'] = EnumToString.convertToString(this.eventStatus);
    data['event_description'] = this.eventDescription;
    data["event_location"] = this.eventLocation;
    return data;
  }
}
