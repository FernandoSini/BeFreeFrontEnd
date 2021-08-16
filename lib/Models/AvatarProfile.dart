class AvatarProfile {
  String? id;
  String? path;
  String? filename;
  String? contentType;

  AvatarProfile({this.id, this.path, this.filename, this.contentType});

  AvatarProfile.fromJson(Map<String, dynamic> json) {
    id = json['_id'] == null ? null : json["_id"];
    path = json['path'] == null ? null : json['path'];
    filename = json['filename'] == null ? null : json['filename'];
    contentType = json['contentType'] == null ? null : json['contentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['path'] = this.path;
    data['filename'] = this.filename;
    data['contentType'] = this.contentType;
    return data;
  }
}
