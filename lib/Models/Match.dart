import 'package:be_free_v1/Models/Message.dart';

import 'User.dart';

class Match {
  String? matchId;
  User? user1;
  User? user2;
  List<Message>? messages;

  Match({this.matchId, this.user1, this.user2, this.messages});

  Match.fromJson(Map<String, dynamic> json) {
    matchId = json['_id'];
    user1 = json['user1'] != null ? new User.fromJson(json['user1']) : null;
    user2 =
        json['user2'] != null ? new User.fromJson(json['user2']) : null;
    if (json['messages'] != null) {
      messages = [];
      (json['messages'] as List<dynamic>).forEach((v) {
        messages?.add(new Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['match_id'] = this.matchId;
    if (this.user1 != null) {
      data['user1'] = this.user1?.toJson();
    }
    if (this.user2 != null) {
      data['user2'] = this.user2?.toJson();
    }
    if (this.messages != null) {
      data['messages'] = this.messages?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
