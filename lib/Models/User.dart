import 'dart:convert';

import 'package:be_free_front/Models/Event.dart';
import 'package:intl/intl.dart';

import 'Like.dart';
import 'Match.dart';
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
  List<Match>? matches;
  List<Like>? likesSended;
  List<Like>? likeReceived;
  List<Image>? images;
  String? token;
  String? job;
  String? company;
  String? school;
  String? createdAt;
  List<Event>? events;

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
      this.matches,
      this.likesSended,
      this.likeReceived,
      this.images,
      this.token,
      this.job,
      this.school,
      this.company,
      this.createdAt,
      this.events});

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
    about = json['about'];
    token = json['token'];
    job = json['job_title'];
    company = json['company'];
    school = json['school'];
    createdAt = json['createdAt'];
    if (json['events'] != null) {
      events = [];
      (json['events'] as List<dynamic>).forEach((v) {
        events?.add(new Event.fromJson(v));
      });
      if (json['matches'] != null) {
        matches = [];
        (json['matches'] as List<dynamic>).forEach((v) {
          matches?.add(new Match.fromJson(v));
        });
      }
      if (json['likesSended'] != null) {
        likesSended = [];
        (json['likesSended'] as List<dynamic>).forEach((v) {
          likesSended?.add(new Like.fromJson(v));
        });
      }
      if (json['likeReceived'] != null) {
        likeReceived = [];
        (json['likeReceived'] as List<dynamic>).forEach((v) {
          likeReceived?.add(new Like.fromJson(v));
        });
      }
      if (json['images'] != null) {
        images = [];
        (json['images'] as List<dynamic>).forEach((v) {
          images?.add(new Image.fromJson(v));
        });
      }
    }
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
    data['school'] = this.school;
    data['createdAt'] = this.createdAt;

    if (this.events != null) {
      data['events'] = this.events?.map((v) => v.toJson()).toList();
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
}
