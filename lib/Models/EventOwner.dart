import 'Event.dart';

class EventOwner {
  String? eventOwnerId;
  String? eventOwnerName;
  int? documentNumber;
  String? email;
  String? avatar;
  List<Event>? events;
  String? token;

  EventOwner(
      {this.eventOwnerId,
      this.eventOwnerName,
      this.documentNumber,
      this.email,
      this.avatar,
      this.events,
      this.token});

  EventOwner.fromJson(Map<String, dynamic> json) {
    eventOwnerId = json['event_owner_id'];
    eventOwnerName = json['event_owner_name'];
    documentNumber = int?.parse(json['document_number'].toString());
    email = json['event_owner_email'];
    avatar = json['event_owner_avatar'];
    if (json['events'] != null) {
      events = <Event>[];
      json['events'].forEach((v) {
        events?.add(new Event.fromJson(v));
      });
    }
    token = json['event_owner_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_owner_id'] = this.eventOwnerId;
    data['event_owner_name'] = this.eventOwnerName;
    data['document_number'] = this.documentNumber;
    data['event_owner_email'] = this.email;
    data['event_owner_avatar'] = this.avatar;
    if (this.events != null) {
      data['events'] = this.events!.map((v) => v.toJson()).toList();
    }
    data['event_owner_token'] = this.token;
    return data;
  }
}
