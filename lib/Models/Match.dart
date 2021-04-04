import 'User.dart';

class Match {
  String? matchId;
  String? hisHerId;
  User? youUser;

  Match({this.matchId, this.hisHerId, this.youUser});

  Match.fromJson(Map<String, dynamic> json) {
    matchId = json['match_id'];
    hisHerId = json['hisHer_id'];
    youUser =
        json['you_user'] != null ? new User.fromJson(json['you_user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['match_id'] = this.matchId;
    data['hisHer_id'] = this.hisHerId;
    if (this.youUser != null) {
      data['you_user'] = this.youUser?.toJson();
    }
    return data;
  }

  // @override
  // String toString() {
  //   return "Match:{ id:$matchId, hisHerId:$hisHerId, youUser:$youUser }";
  // }
}
