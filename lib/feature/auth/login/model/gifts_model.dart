class GiftsModel {
  int? id;
  String? title;
  String? imageUrl;
  int? requiredPoint;
  bool? status;

  GiftsModel(
      {this.id, this.title, this.imageUrl, this.requiredPoint, this.status});

  GiftsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imageUrl = json['imageUrl'];
    requiredPoint = json['requiredPoint'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['imageUrl'] = this.imageUrl;
    data['requiredPoint'] = this.requiredPoint;
    data['status'] = this.status;
    return data;
  }
}
