import 'package:enum_to_string/enum_to_string.dart';
import 'package:intl/intl.dart';

import 'MessageStatus.dart';
import 'User.dart';
import 'Match.dart';

class Message {
  String? idMessage;
  User? sender;
  User? receiver;
  Match? match;
  String? content;
  DateTime? timestamp;
  MessageStatus? messageStatus;

  Message(
      {this.idMessage,
      this.sender,
      this.receiver,
      this.match,
      this.content,
      this.timestamp,
      this.messageStatus});

  Message.fromJson(Map<String, dynamic> json) {
    idMessage = json["message_id"];
    sender = json['sender'] != null ? new User.fromJson(json['sender']) : null;
    receiver =
        json['receiver'] != null ? new User.fromJson(json['receiver']) : null;
    match = json["match"] != null ? new Match.fromJson(json["match"]) : null;
    messageStatus =
        EnumToString.fromString(MessageStatus.values, json['messageStatus']);
    content = json["content"];
    timestamp = json["timestamp"] != null
        ? new DateFormat("dd-MM-yyyy HH:mm:ss").parse(json['timestamp'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message_id'] = this.idMessage;
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    if (this.receiver != null) {
      data['receiver'] = this.receiver!.toJson();
    }
    if (this.match != null) {
      data['match'] = this.match!.toJson();
    }
    if (this.timestamp != null) {
      data['timestamp'] =
          DateFormat("dd-MM-yyyy HH:mm:ss").format(this.timestamp!).toString();
    }
    if (this.messageStatus != null) {
      data['messageStatus'] = EnumToString.convertToString(this.messageStatus);
    }
    data["content"] = this.content!;

    return data;
  }
}
