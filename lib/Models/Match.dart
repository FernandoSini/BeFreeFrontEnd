import 'User.dart';

class Match {
  String? matchId;
  User? hisHer;
  User? youUser;

  Match({this.matchId, this.hisHer, this.youUser});

  Match.fromJson(Map<String, dynamic> json) {
    matchId = json['match_id'];
    hisHer =
        json['hisHer'] != null ? new User.fromJson(json['hisHer']) : null;
    youUser = json['you_user'] != null
        ? new User.fromJson(json['you_user'])
        : null;
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
    return data;
  }
}