import 'package:be_free_front/Models/Graduation.dart';

import 'Like.dart';
import 'Match.dart';
import 'Graduation.dart';
import 'Image.dart';

class User {
  String? idUser;
  String? avatar;
  String? userName;
  String? firstName;
  String? lastName;
  String? gender;
  String? birthday;
  String? email;
  String? usertype;
  List<Graduation>? userGraduations;
  List<Match>? matches;
  List<Like>? likesSended;
  List<Like>? likeReceived;
  List<Image>? images;
  String? token;

  User(
      {this.idUser,
      this.avatar,
      this.userName,
      this.firstName,
      this.lastName,
      this.gender,
      this.birthday,
      this.email,
      this.usertype,
      this.userGraduations,
      this.matches,
      this.likesSended,
      this.likeReceived,
      this.images,
      this.token});

  User.fromJson(Map<String, dynamic> json) {
    idUser = json['id_user'];
    avatar = json['avatar'];
    userName = json['user_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    birthday = json['birthday'];
    email = json['email'];
    usertype = json['usertype'];
    if (json['userGraduations'] != null) {
      userGraduations = <Graduation>[];
      json['userGraduations']?.forEach((v) {
        userGraduations!.add(new Graduation.fromJson(v));
      });
    }
    if (json['matches'] != null) {
      matches = <Match>[];
      json['matches']!.forEach((v) {
        matches?.add(new Match.fromJson(v));
      });
    }
    if (json['likesSended'] != null) {
      likesSended = <Like>[];
      json['likesSended']!.forEach((v) {
        likesSended?.add(new Like.fromJson(v));
      });
    }
    if (json['likeReceived'] != null) {
      likeReceived = <Like>[];
      json['likeReceived']!.forEach((v) {
        likeReceived?.add(new Like.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = <Image>[];
      json['images']!.forEach((v) {
        images?.add(new Image.fromJson(v));
      });
    }
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_user'] = this.idUser;
    data['avatar'] = this.avatar;
    data['user_name'] = this.userName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    data['birthday'] = this.birthday;
    data['email'] = this.email;
    data['usertype'] = this.usertype;
    data['token'] = this.token;
    if (this.userGraduations != null) {
      data['userGraduations'] =
          this.userGraduations?.map((v) => v.toJson()).toList();
    }
    if (this.matches != null) {
      data['matches'] = this.matches?.map((v) => v.toJson()).toList();
    }
    if (this.likesSended != null) {
      data['likesSended'] = this.likesSended?.map((v) => v.toJson()).toList();
    }
    if (this.likeReceived != null) {
      data['likeReceived'] = this.likeReceived?.map((v) => v.toJson()).toList();
    }
    if (this.images != null) {
      data['images'] = this.images?.map((v) => v.toJson()).toList();
    }

    return data;
  }

  // @override
  //   String toString() {
  //     return "Username: $userName, lastName: $lastName, firstName:$firstName,id:$idUser, Usertype:$usertype, Gender:$gender, Email: $email, Birthday:$birthday, Graduations:${userGraduations}";
  //   }

}
