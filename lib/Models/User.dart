// import 'dart:convert';

// import 'package:be_free_v1/Models/Avatar.dart';
// import 'package:be_free_v1/Models/Event.dart';
// import 'package:be_free_v1/Models/Usertype.dart';
// import 'package:enum_to_string/enum_to_string.dart';
// import 'package:intl/intl.dart';

// import 'Like.dart';
// import 'Match.dart';
// import 'ImageModel.dart';

// class User {
//   String? idUser;
//   String? userName;
//   String? firstName;
//   String? lastName;
//   String? gender;
//   String? birthday;
//   String? email;
//   Usertype? usertype;
//   String? about;
//   List<Match>? matches;
//   List<Like>? likesSended;
//   List<Like>? likeReceived;
//   List<ImageModel>? images;
//   String? token;
//   String? job;
//   String? company;
//   String? school;
//   String? livesIn;
//   String? createdAt;
//   List<Event>? events;
//   Avatar? avatarProfile;

//   User(
//       {this.idUser,
//       this.userName,
//       this.firstName,
//       this.lastName,
//       this.gender,
//       this.birthday,
//       this.email,
//       this.usertype,
//       this.about,
//       this.matches,
//       this.likesSended,
//       this.likeReceived,
//       this.images,
//       this.token,
//       this.job,
//       this.school,
//       this.livesIn,
//       this.company,
//       this.createdAt,
//       this.avatarProfile,
//       this.events});

//   User.fromJson(Map<String, dynamic> json) {
//     idUser = json['id_user'];
//     avatarProfile = json['avatar_profile'] != null
//         ? new Avatar.fromJson(json['avatar_profile'])
//         : null;
//     userName = json['user_name'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     gender = json['gender'];
//     birthday = json['birthday'];
//     email = json['email'];
//     usertype = EnumToString.fromString(Usertype.values, json['usertype']);
//     about = json['about'];
//     token = json['token'];
//     job = json['job_title'];
//     company = json['company'];
//     school = json['school'];
//     createdAt = json['createdAt'];
//     livesIn = json["livesIn"];
//     if (json['events'] != null) {
//       events = [];
//       (json['events'] as List<dynamic>).forEach((v) {
//         events?.add(new Event.fromJson(v));
//       });
//     }
//     if (json['matches'] != null) {
//       matches = [];
//       (json['matches'] as List<dynamic>).forEach((v) {
//         matches?.add(new Match.fromJson(v));
//       });
//     }
//     if (json['likesSended'] != null) {
//       likesSended = [];
//       (json['likesSended'] as List<dynamic>).forEach((v) {
//         likesSended?.add(new Like.fromJson(v));
//       });
//     }
//     if (json['likeReceived'] != null) {
//       likeReceived = [];
//       (json['likeReceived'] as List<dynamic>).forEach((v) {
//         likeReceived?.add(new Like.fromJson(v));
//       });
//     }
//     if (json['images'] != null) {
//       images = [];
//       (json['images'] as List<dynamic>).forEach((v) {
//         images?.add(new ImageModel.fromJson(v));
//       });
//     }
//   }
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id_user'] = this.idUser;
//     data['user_name'] = this.userName;
//     data['first_name'] = this.firstName;
//     data['last_name'] = this.lastName;
//     data['gender'] = this.gender;
//     data['birthday'] = this.birthday;
//     data['email'] = this.email;
//     data['usertype'] = EnumToString.convertToString(this.usertype);
//     data['about'] = this.about;
//     data['token'] = this.token;
//     data['job_title'] = this.job;
//     data['company'] = this.company;
//     data['school'] = this.school;
//     data['createdAt'] = this.createdAt;
//     data["livesIn"] = this.livesIn;
//     if (this.avatarProfile != null) {
//       data['avatar_profile'] = this.avatarProfile?.toJson();
//     }
//     if (this.events != null) {
//       data['events'] = this.events?.map((v) => v.toJson()).toList();
//     }
//     if (this.matches != null) {
//       data['matches'] = this.matches?.map((v) => v.toJson()).toList();
//     }
//     if (this.likesSended != null) {
//       data['likesSended'] = this.likesSended?.map((v) => v.toJson()).toList();
//     }
//     if (this.likeReceived != null) {
//       data['likeReceived'] = this.likeReceived?.map((v) => v.toJson()).toList();
//     }
//     if (this.images != null) {
//       data['images'] = this.images?.map((v) => v.toJson()).toList();
//     }

//     return data;
//   }
// }

import 'package:be_free_v1/Models/Gender.dart';
import 'package:be_free_v1/Models/Match.dart';
import 'package:be_free_v1/Models/Usertype.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'AvatarProfile.dart';
import 'LikesReceived.dart';
import 'LikesSent.dart';
import 'Photos.dart';

class User {
  String? id;
  String? username;
  String? firstname;
  String? lastname;
  String? birthday;
  Gender? gender;
  String? email;
  AvatarProfile? avatarProfile;
  String? about;
  Usertype? usertype;
  String? job;
  String? school;
  String? company;
  List<Photos>? photos;
  List<LikesSent>? likesSent;
  List<LikesReceived>? likesReceived;
  List<Match>? matches;
  String? role;
  String? createdAt;
  String? token;
  String? livesIn;

  User(
      {this.id,
      this.username,
      this.firstname,
      this.lastname,
      this.birthday,
      this.gender,
      this.email,
      this.avatarProfile,
      this.about,
      this.usertype,
      this.job,
      this.school,
      this.company,
      this.photos,
      this.likesSent,
      this.likesReceived,
      this.matches,
      this.role,
      this.createdAt,
      this.livesIn,
      this.token});

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'] == null ? null : json["_id"];
    username = json['username'] == null ? null : json["username"];
    firstname = json['firstname'] == null ? null : json["firstname"];
    lastname = json['lastname'] == null ? null : json["lastname"];
    birthday = json['birthday'] == null ? null : json["birthday"];
    gender = json['gender'] == null
        ? null
        : EnumToString.fromString(Gender.values, json['gender']);
    email = json['email'] == null ? null : json["email"];
    avatarProfile = json['avatar_profile'] != null
        ? new AvatarProfile.fromJson(json['avatar_profile'])
        : null;
    about = json['about'] == null ? null : json["about"];
    usertype = json["usertype"] == null
        ? null
        : EnumToString.fromString(Usertype.values, json['usertype']);
    job = json['job'] == null ? null : json["job"];
    school = json['school'] == null ? null : json["school"];
    company = json['company'] == null ? null : json["company"];
    livesIn = json["livesIn"] == null ? null : json["livesIn"];
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos?.add(new Photos.fromJson(v));
      });
    }
    if (json['likesSent'] != null) {
      likesSent = <LikesSent>[];
      json['likesSent'].forEach((v) {
        likesSent?.add(new LikesSent.fromJson(v));
      });
    }
    if (json['likesReceived'] != null) {
      likesReceived = <LikesReceived>[];
      json['likesReceived'].forEach((v) {
        likesReceived?.add(new LikesReceived.fromJson(v));
      });
    }
    if (json['matches'] != null) {
      matches = <Match>[];
      json['matches'].forEach((v) {
        matches?.add(new Match.fromJson(v));
      });
    }
    // matches = json['matches'] == null ? null : json['matches'].cast<String>();
    role = json['role'] == null ? null : json["roles"];
    createdAt = json['createdAt'] == null ? null : json["createdAt"];
    token = json['token'] == null ? null : json["token"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['username'] = this.username;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['birthday'] = this.birthday;
    if (this.gender != null) {
      data['gender'] = EnumToString.convertToString(this.gender);
    }
    data['email'] = this.email;
    if (this.avatarProfile != null) {
      data['avatar_profile'] = this.avatarProfile?.toJson();
    }

    data['about'] = this.about;
    if (this.usertype != null) {
      data['usertype'] = EnumToString.convertToString(this.usertype);
    }
    data['job'] = this.job;
    data['school'] = this.school;
    data['company'] = this.company;
    data["livesIn"] = this.livesIn;
    if (this.photos != null) {
      data['photos'] = this.photos?.map((v) => v.toJson()).toList();
    }
    // if (this.likesSent != null) {
    //   data['likesSent'] = this.likesSent?.map((v) => v.toJson()).toList();
    // }
    // if (this.likesReceived != null) {
    //   data['likesReceived'] =
    //       this.likesReceived?.map((v) => v.toJson()).toList();
    // }
    data['matches'] = this.matches;
    data['role'] = this.role;
    data['createdAt'] = this.createdAt;
    data['token'] = this.token;
    return data;
  }

  Map<String, dynamic> toJsonUpdate() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.username != null) data['username'] = this.username;
    if (this.firstname != null) data['firstname'] = this.firstname;
    if (this.lastname != null) data['lastname'] = this.lastname;
    if (this.birthday != null) data['birthday'] = this.birthday;
    if (this.gender != null) {
      data['gender'] = EnumToString.convertToString(this.gender);
    }
    if (this.email != null) data['email'] = this.email;
    if (this.avatarProfile != null) {
      data['avatar_profile'] = this.avatarProfile?.toJson();
    }
    if (this.about != null) data['about'] = this.about;
    if (this.usertype != null) {
      data['usertype'] = EnumToString.convertToString(this.usertype);
    }
    if (this.job != null) data['job'] = this.job;
    if (this.school != null) data['school'] = this.school;
    if (this.company != null) data['company'] = this.company;
    if (this.livesIn != null) data["livesIn"] = this.livesIn;
    if (this.photos != null) {
      data['photos'] = this.photos?.map((v) => v.toJson()).toList();
    }
    // if (this.likesSent != null) {
    //   data['likesSent'] = this.likesSent?.map((v) => v.toJson()).toList();
    // }
    // if (this.likesReceived != null) {
    //   data['likesReceived'] =
    //       this.likesReceived?.map((v) => v.toJson()).toList();
    // }
    if (this.matches != null) data['matches'] = this.matches;
    if (this.createdAt != null) data['createdAt'] = this.createdAt;

    return data;
  }
}
