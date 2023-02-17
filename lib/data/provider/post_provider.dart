import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:facebook_clone/constant/constant.dart';
import 'package:facebook_clone/data/models/comment_res_model.dart';
import 'package:facebook_clone/data/models/post_res_model.dart';
import 'package:facebook_clone/data/models/posts/all_post_res_model.dart';
import 'package:get_storage/get_storage.dart';

import '../models/posts/post_like_res_model.dart';

class PostProvider {
  final dio = Dio();
  final storage = GetStorage();

  Future<Either<String, PostResModel>> createPost(
      {required String title, required String body, required File file}) async {
    try {
      var formData = FormData.fromMap({
        'title': title,
        'body': body,
        'image': await MultipartFile.fromFile(file.path),
        'type': 'image',
      });
      final res = await dio.post(
        '$kBaseUrl/posts',
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-type': 'application/json',
            'Authorization': 'Bearer ${storage.read('token')}'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (res.statusCode == 200) {
        return Right(PostResModel.fromJson(res.data));
      } else {
        return Left(res.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// get all posts

  Future<Either<String, List<AllPostResModel>>> getAllPosts() async {
    final res = await dio.get("${kBaseUrl}/posts",
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-type': 'application/json',
            'Authorization': 'Bearer ${storage.read('token')}'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (res.statusCode == 200) {
      List lst = res.data;
      return Right(lst.map((e) => AllPostResModel.fromJson(e)).toList());
    } else {
      return Left(res.data['message']);
    }
  }

  /// delete post by id
  Future<Either<String, String>> deletePost(String id) async {
    final res = await dio.delete("$kBaseUrl/posts/$id",
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-type': 'application/json',
            'Authorization': 'Bearer ${storage.read('token')}'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (res.statusCode == 200) {
      return Right(res.data['message']);
    } else {
      return Left(res.data['message']);
    }
  }

  /// like post by id
  Future<Either<String, String>> likePost(String id) async {
    final res = await dio.post("$kBaseUrl/like",
        data: {'post_id': id},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-type': 'application/json',
            'Authorization': 'Bearer ${storage.read('token')}'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (res.statusCode == 200) {
      return Right("Liked");
    } else {
      return Left("Error");
    }
  }

  /// unlike post by id
  Future<Either<String, String>> unLikePost(String id) async {
    final res = await dio.post("$kBaseUrl/unlike",
        data: {'post_id': id},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-type': 'application/json',
            'Authorization': 'Bearer ${storage.read('token')}'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (res.statusCode == 200) {
      return Right("Unliked");
    } else {
      return Left("Error");
    }
  }

  /// get like by post id
  Future<Either<String, List<PostLikeResModel>>> getPostLikedById(
      String postId) async {
    final res = await dio.get("${kBaseUrl}/post/likes/$postId",
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-type': 'application/json',
            'Authorization': 'Bearer ${storage.read('token')}'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (res.statusCode == 200) {
      List lst = res.data;
      final data = lst.map((e) => PostLikeResModel.fromJson(e)).toList();
      return Right(data);
    } else {
      return Left(res.data['message']);
    }
  }

  ///get comment by post id
  Future<Either<String, List<CommentsResModel>>> getAllCommentsByPostId(
      String postId) async {
    final res = await dio.get(
      "$kBaseUrl/comments/$postId",
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${storage.read('token')}'
        },
      ),
    );
    if (res.statusCode == 200) {
      List lst = res.data;
      final data = lst.map((e) => CommentsResModel.fromJson(e)).toList();
      return Right(data);
    } else {
      return Left(res.data['message']);
    }
  }

  Future<Either<String, String>> postComment(
      {required String postId, required String text}) async {
    final res = await dio.post("$kBaseUrl/comment",
        data: {'post_id': postId, 'text': text},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-type': 'application/json',
            'Authorization': 'Bearer ${storage.read('token')}'
          },
        ));
    if (res.statusCode == 200) {
      return Right("Commented");
    } else {
      return Left(res.data['message']);
    }
  }
}
