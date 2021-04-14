import 'User.dart';

class Event {
  String? eventId;
  String? eventName;
  String? eventCover;
  List<User>? users;

  Event({this.eventId, this.eventName, this.eventCover, this.users});

  Event.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    eventName = json['event_name'];
    eventCover = json['event_cover'];
    if (json['users'] != null) {
      users = <User>[];
      json['users'].forEach((v) {
        users!.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['event_name'] = this.eventName;
    data['event_cover'] = this.eventCover;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}