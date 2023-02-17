class PostResModel {
  String? title;
  String? type;
  String? image;
  int? userId;
  String? updatedAt;
  String? createdAt;
  int? id;

  PostResModel(
      {this.title,
      this.type,
      this.image,
      this.userId,
      this.updatedAt,
      this.createdAt,
      this.id});

  PostResModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    type = json['type'];
    image = json['image'];
    userId = json['user_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['type'] = this.type;
    data['image'] = this.image;
    data['user_id'] = this.userId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}

//
