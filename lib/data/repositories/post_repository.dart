import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:facebook_clone/data/models/comment_res_model.dart';
import 'package:facebook_clone/data/provider/post_provider.dart';

import '../models/posts/post_like_res_model.dart';

class PostRepo {
  final PostProvider postProvider;
  PostRepo({required this.postProvider});
  // getPosts() async {
  //   return postProvider.getPosts();
  // }

  /// create post
  createPost(
      {required String title, required String body, required File file}) async {
    return postProvider.createPost(title: title, body: body, file: file);
  }

  /// get all posts

  getAllPosts() async {
    return postProvider.getAllPosts();
  }

  ///delete post
  deletePost({required String id}) async {
    return postProvider.deletePost(id);
  }

  /// like post
  likePost({required String id}) async {
    return postProvider.likePost(id);
  }

  /// unlike post
  unLikePost({required String id}) async {
    return postProvider.unLikePost(id);
  }

  ///get post likes
  Future<Either<String, List<PostLikeResModel>>> getPostLikes(
      {required String id}) async {
    return postProvider.getPostLikedById(id);
  }

  Future<Either<String, List<CommentsResModel>>> getCommentsByPost(
      {required String id}) async {
    return postProvider.getAllCommentsByPostId(id);
  }
  Future<Either<String,String>> postComment({required String postId,required String comment}) async {
    return postProvider.postComment(postId: postId, text: comment);
  }
}
