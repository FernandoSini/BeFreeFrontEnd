import 'package:be_free_v1/Models/Message.dart';

import 'User.dart';

class Match {
  String? matchId;
  User? hisHer;
  User? youUser;
  List<Message>? messages;

  Match({this.matchId, this.hisHer, this.youUser, this.messages});

  Match.fromJson(Map<String, dynamic> json) {
    matchId = json['match_id'];
    hisHer = json['hisHer'] != null ? new User.fromJson(json['hisHer']) : null;
    youUser =
        json['you_user'] != null ? new User.fromJson(json['you_user']) : null;
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
    if (this.hisHer != null) {
      data['hisHer'] = this.hisHer?.toJson();
    }
    if (this.youUser != null) {
      data['you_user'] = this.youUser?.toJson();
    }
    if (this.messages != null) {
      data['messages'] = this.messages?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
