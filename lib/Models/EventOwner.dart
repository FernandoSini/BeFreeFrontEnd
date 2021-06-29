import 'Event.dart';
import 'EventOwnerAvatar.dart';

class EventOwner {
  String? eventOwnerId;
  String? eventOwnerName;
  int? documentNumber;
  String? email;
  List<Event>? events;
  EventOwnerAvatar? avatarProfile;
  String? token;
  String? createdAt;

  EventOwner(
      {this.eventOwnerId,
      this.eventOwnerName,
      this.documentNumber,
      this.email,
      this.events,
      this.createdAt,
      this.avatarProfile,
      this.token});

  EventOwner.fromJson(Map<String, dynamic> json) {
    eventOwnerId = json['event_owner_id'];
    eventOwnerName = json['event_owner_name'];
    avatarProfile = json['avatar_profile_owner'] != null
        ? new EventOwnerAvatar.fromJson(json['avatar_profile_owner'])
        : null;
    if (documentNumber != null) {
      documentNumber = int?.parse(json['document_number'].toString());
    }
    email = json['event_owner_email'];
    createdAt = json["createdAt"];

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
     data['avatar_profile'] = this.avatarProfile;
    data["createdAt"] = this.createdAt;
    if (this.avatarProfile != null) {
      data["avatar_profile_owner"] = this.avatarProfile!.toJson();
    }
    if (this.events != null) {
      data['events'] = this.events!.map((v) => v.toJson()).toList();
    }
    data['event_owner_token'] = this.token;
    return data;
  }
}
