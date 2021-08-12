// class ImageModel {
//   String? imageId;
//   String? imageLink;

//   ImageModel({this.imageId, this.imageLink});

//   ImageModel.fromJson(Map<String, dynamic> json) {
//     imageId = json['image_id'];
//     imageLink = json['image_link'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['image_id'] = this.imageId;
//     data['image_link'] = this.imageLink;
//     return data;
//   }

//   // @override
//   // String toString() {
//   //   return "Image:{ id:$imageId, imageLink:$imageLink}";
//   // }
// }

class ImageModel {
  String? imageId;
  String? name;
  String? contentType;
  int? size;
  String? url;

  ImageModel({this.imageId, this.name, this.contentType, this.size, this.url});

  ImageModel.fromJson(Map<String, dynamic> json) {
    imageId = json['image_id'];
    name = json['name'];
    contentType = json['contentType'];
    size = json['size'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_id'] = this.imageId;
    data['name'] = this.name;
    data['contentType'] = this.contentType;
    data['size'] = this.size;
    data['url'] = this.url;
    return data;
  }
}
