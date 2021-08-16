class LikesSent {
  String? id;
  String? username;
  String? firstname;
  String? lastname;
  String? birthday;

  LikesSent(
      {this.id, this.username, this.firstname, this.lastname, this.birthday});

  LikesSent.fromJson(Map<String, dynamic> json) {
    id = json['_id'] == null ? null : json["_id"];
    firstname = json["firstname"] == null ? null : json['firstname'];
    lastname = json['lastname'] == null ? null : json["lastname"];
    birthday = json['birthday'] == null ? null : json["birthday"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['lastname'] = this.lastname;
    data['birthday'] = this.birthday;
    return data;
  }
}
