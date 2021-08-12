class EventOwnerAvatar {
  String? imageId;
  String? name;
  String? contentType;
  int? size;
  String? url;

  EventOwnerAvatar({this.imageId, this.name, this.contentType, this.size, this.url});

  EventOwnerAvatar.fromJson(Map<String, dynamic> json) {
    imageId = json['avatar_id'];
    name = json['name'];
    contentType = json['contentType'];
    size = json['size'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar_id'] = this.imageId;
    data['name'] = this.name;
    data['contentType'] = this.contentType;
    data['size'] = this.size;
    data['url'] = this.url;
    return data;
  }
}
