class ImageModel {
  String? imageId;
  String? imageLink;

  ImageModel({this.imageId, this.imageLink});

  ImageModel.fromJson(Map<String, dynamic> json) {
    imageId = json['image_id'];
    imageLink = json['image_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_id'] = this.imageId;
    data['image_link'] = this.imageLink;
    return data;
  }

  // @override
  // String toString() {
  //   return "Image:{ id:$imageId, imageLink:$imageLink}";
  // }
}
