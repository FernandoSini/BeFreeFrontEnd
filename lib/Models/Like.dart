import 'package:be_free_v1/Models/User.dart';

class Like {
  String? idLike;
  User? userSendLike;
  User? userLiked;

  Like({this.idLike, this.userSendLike, this.userLiked});

  Like.fromJson(Map<String, dynamic> json) {
    idLike = json['id_like'];
    userSendLike = json['userSendLike'] != null
        ? new User.fromJson(json['userSendLike'])
        : null;
    userLiked =
        json['userLiked'] != null ? new User.fromJson(json['userLiked']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_like'] = this.idLike;
    if (this.userSendLike != null) {
      data['userSendLike'] = this.userSendLike?.toJson();
    }
    if (this.userLiked != null) {
      data['userLiked'] = this.userLiked?.toJson();
    }
    return data;
  }

  // @override
  // String toString() {
  //   return "idLike:$idLike, UserSendLike:${userSendLike.toString()}, UserReceivedLike:${userLiked.toString()}";
  // }
}
