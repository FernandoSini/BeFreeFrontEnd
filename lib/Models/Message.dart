// import 'package:enum_to_string/enum_to_string.dart';
// import 'package:intl/intl.dart';

// import 'MessageStatus.dart';
// import 'User.dart';
// import 'Match.dart';

// class Message {
//   String? idMessage;
//   User? sender;
//   User? receiver;
//   Match? match;
//   String? content;
//   DateTime? timestamp;
//   MessageStatus? messageStatus;

//   Message(
//       {this.idMessage,
//       this.sender,
//       this.receiver,
//       this.match,
//       this.content,
//       this.timestamp,
//       this.messageStatus});

//   Message.fromJson(Map<String, dynamic> json) {
//     idMessage = json["message_id"];
//     sender = json['sender'] != null ? new User.fromJson(json['sender']) : null;
//     receiver =
//         json['receiver'] != null ? new User.fromJson(json['receiver']) : null;
//     match = json["match"] != null ? new Match.fromJson(json["match"]) : null;
//     messageStatus =
//         EnumToString.fromString(MessageStatus.values, json['messageStatus']);
//     content = json["content"];
//     timestamp = json["timestamp"] != null
//         ? new DateFormat("dd-MM-yyyy HH:mm:ss").parse(json['timestamp'])
//         : null;
//   }
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['message_id'] = this.idMessage;
//     data["content"] = this.content!;
//     if (this.timestamp != null) {
//       data['timestamp'] =
//           DateFormat("dd-MM-yyyy HH:mm:ss").format(this.timestamp!).toString();
//     }
//     if (this.sender != null) {
//       data['sender'] = this.sender!.toJson();
//     }
//     if (this.receiver != null) {
//       data['receiver'] = this.receiver!.toJson();
//     }
//     if (this.match != null) {
//       data['match'] = this.match!.toJson();
//     }

//     if (this.messageStatus != null) {
//       data['messageStatus'] = EnumToString.convertToString(this.messageStatus);
//     }

//     return data;
//   }
// }
import 'package:be_free_v1/Models/MessageStatus.dart';
import 'package:enum_to_string/enum_to_string.dart';

class Message {
  String? yourId;
  String? content;
  String? targetId;
  String? matchId;
  MessageStatus? messageStatus;
  DateTime? timestamp;

  Message(
      {this.yourId,
      this.content,
      this.targetId,
      this.matchId,
      this.timestamp,
      this.messageStatus});

  Message.fromJson(Map<String, dynamic> json) {
    yourId = json['yourId'] == null ? null : json['yourId'];
    content = json['content'] == null ? null : json["content"];
    targetId = json['targetId'] == null ? null : json["targetId"];
    matchId = json['matchId'] == null ? null : json["matchId"];
    timestamp =
        json["timestamp"] == null ? null : DateTime.tryParse(json['timestamp']);
    messageStatus = json["message_status"] == null
        ? null
        : EnumToString.fromString(MessageStatus.values, json["message_status"]);
  }

  Message.fromJsonSocket(Map<String, dynamic> json) {
    yourId = json['from'] == null ? null : json['from'];
    content = json['content'] == null ? null : json["content"];
    targetId = json['target'] == null ? null : json["target"];
    matchId = json['match'] == null ? null : json["match"];
    timestamp =
        json["timestamp"] == null ? null : DateTime.tryParse(json['timestamp']);
    messageStatus = json["message_status"] == null
        ? null
        : EnumToString.fromString(MessageStatus.values, json["message_status"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['yourId'] = this.yourId;
    data['content'] = this.content;
    data['targetId'] = this.targetId;
    data['matchId'] = this.matchId;
    data['timestamp'] = this.timestamp.toString();
    data["message_status"] = EnumToString.convertToString(this.messageStatus);
    return data;
  }
}
