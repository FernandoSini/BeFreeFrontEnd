class EventPhoto {
  String? id;
  String? path;
  String? filename;
  String? contentType;

  EventPhoto({this.id, this.path, this.filename, this.contentType});

  EventPhoto.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    path = json['path'];
    filename = json['filename'];
    contentType = json['contentType'];
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
