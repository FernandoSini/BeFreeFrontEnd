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
  String? about;
  List<Graduation>? userGraduations;
  List<Match>? matches;
  List<Like>? likesSended;
  List<Like>? likeReceived;
  List<Image>? images;
  String? token;
  String? job;
  String? company;

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
      this.about,
      this.userGraduations,
      this.matches,
      this.likesSended,
      this.likeReceived,
      this.images,
      this.token,
      this.job,
      this.company});

  User.fromJson(Map<String, dynamic> json) {
    idUser = json['id_user'];
    avatar = json['avatar'];
    userName = json['user_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    birthday = json['birthday'];
    email = json['email'];
    about = json['about'];
    usertype = json['usertype'];
    // userGraduations?.addAll((json["userGraduations"] as List).map((g) => Graduation.fromJson(g)).toList());
    if (json['userGraduations'] != null) {
      userGraduations?.addAll((json['userGraduations']! as List)
          .map((g) => Graduation.fromJson(g))
          .toList());
    }
    if (json['matches'] != null) {
      // matches = <Match>[];
      matches?.addAll((json['matches']! as List).map((m) => Match.fromJson(m)));
    }
    if (json['likesSended'] != null) {
      // likesSended = <Like>[];
      likesSended?.addAll((json['likesSended']! as List)
          .map((like) => Like.fromJson(like))
          .toList());
    }
    if (json['likeReceived'] != null) {
      // likeReceived = <Like>[];
      likeReceived?.addAll((json['likeReceived']! as List)
          .map((lr) => Like.fromJson(lr))
          .toList());
    }
    if (json['images'] != null) {
      // images = <Image>[];
      images?.addAll(
          (json['images']! as List).map((i) => Image.fromJson(i)).toList());
    }
    token = json['token'];
    job = json['job_title'];
    company = json['company'];
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
    data['about'] = this.about;
    data['token'] = this.token;
    data['job_title'] = this.job;
    data['company'] = this.company;
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
