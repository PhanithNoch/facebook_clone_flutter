class AllPostResModel {
  int? id;
  String? title;
  Null? desc;
  String? image;
  String? userId;
  String? type;
  String? createdAt;
  String? updatedAt;
  int? likesCount;
  int? commentsCount;
  bool? liked;
  FirstUserLiked? firstUserLiked;
  FirstUserLiked? user;
  List<Likes>? likes;

  AllPostResModel(
      {this.id,
      this.title,
      this.desc,
      this.image,
      this.userId,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.likesCount,
      this.commentsCount,
      this.liked,
      this.firstUserLiked,
      this.user,
      this.likes});

  AllPostResModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    desc = json['desc'];
    image = json['image'];
    userId = json['user_id'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    likesCount = json['likes_count'];
    commentsCount = json['comments_count'];
    liked = json['liked'];
    firstUserLiked = json['first_user_liked'] != null
        ? new FirstUserLiked.fromJson(json['first_user_liked'])
        : null;
    user =
        json['user'] != null ? new FirstUserLiked.fromJson(json['user']) : null;
    if (json['likes'] != null) {
      likes = <Likes>[];
      json['likes'].forEach((v) {
        likes!.add(new Likes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['image'] = this.image;
    data['user_id'] = this.userId;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['likes_count'] = this.likesCount;
    data['comments_count'] = this.commentsCount;
    data['liked'] = this.liked;
    if (this.firstUserLiked != null) {
      data['first_user_liked'] = this.firstUserLiked!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.likes != null) {
      data['likes'] = this.likes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FirstUserLiked {
  int? id;
  String? name;
  String? email;
  String? image;
  Null? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  FirstUserLiked(
      {this.id,
      this.name,
      this.email,
      this.image,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt});

  FirstUserLiked.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['image'] = this.image;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Likes {
  int? id;
  String? userId;
  String? postId;
  String? createdAt;
  String? updatedAt;

  Likes({this.id, this.userId, this.postId, this.createdAt, this.updatedAt});

  Likes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    postId = json['post_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['post_id'] = this.postId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
