import 'package:facebook_clone/data/models/posts/all_post_res_model.dart';
import 'package:facebook_clone/data/models/posts/post_like_res_model.dart';
import 'package:facebook_clone/data/models/user/user_info_res_model.dart';
import 'package:facebook_clone/data/repositories/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/repositories/post_repository.dart';

class HomeController extends GetxController {
  final storage = GetStorage();
  final UserRepo userRepository;
  final PostRepo postRepository;

  HomeController({required this.userRepository, required this.postRepository});

  bool isLoading = false;
  bool isError = false;
  UserInfoResModel userInfo = UserInfoResModel();
  List<AllPostResModel> posts = [];
  PostLikeResModel postLike = PostLikeResModel();
  final commentController = TextEditingController();

  @override
  void onInit() {
    getPosts();
    getCurrentUser();
    super.onInit();
  }

  @override
  void onReady() {
    checkUserLoggedIn();
    super.onReady();
  }

  /// check if user is logged in
  void checkUserLoggedIn() async {
    final token = await storage.read("token");
    print('token: $token');
    if (token == null) {
      Get.offAllNamed("/login");
    }
  }

  void logout() {
    storage.remove("token");
    Get.offAllNamed("/login");
  }

  ///get current user logged
  void getCurrentUser() async {
    isLoading = true;
    final res = await userRepository.getUserInfo();
    res.fold((left) {
      isError = true;
      // Get.snackbar(
      //   "Error Occurred",
      //   left.toString(),
      // );
      isLoading = false;
    }, (right) {
      // Get.snackbar("Success", "User Logged In Successfully");
      isLoading = false;
      userInfo = right;
      print(right);
    });
  }

  ///get posts

  void getPosts() async {
    isLoading = true;
    final res = await postRepository.getAllPosts();
    res.fold((left) {
      Get.snackbar(
        "Error Occurred",
        left.toString(),
      );
      isLoading = false;
    }, (right) {
      posts = right;
      isLoading = false;
      update();
      print(right);
    });
  }

  /// covert date to time ago
  String timeAgoSinceDate(String dateString) {
    DateTime notificationDate = DateTime.parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 7) {
      return (difference.inDays / 7).floor().toString() + 'w';
    } else if (difference.inDays > 0) {
      return difference.inDays.toString() + 'd';
    } else if (difference.inHours > 0) {
      return difference.inHours.toString() + 'h';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes.toString() + 'm';
    } else if (difference.inSeconds > 0) {
      return difference.inSeconds.toString() + 's';
    } else {
      return '0s';
    }
  }

  /// like post
  void likePost(int index) async {
    isLoading = true;
    final res = await postRepository.likePost(id: posts[index].id.toString());
    res.fold((left) {
      Get.snackbar(
        "Error Occurred",
        left.toString(),
      );
      isLoading = false;
    }, (right) {
      // posts[index].isLiked = true;
      posts[index].likesCount = posts[index].likesCount! + 1;
      posts[index].liked = true;
      isLoading = false;
      update();
      print(right);
    });
  }

  /// unlike post
  void unlikePost(int index) async {
    isLoading = true;
    final res = await postRepository.unLikePost(id: posts[index].id.toString());
    res.fold((left) {
      Get.snackbar(
        "Error Occurred",
        left.toString(),
      );
      isLoading = false;
    }, (right) {
      // posts[index].isLiked = false;
      posts[index].likesCount = posts[index].likesCount! - 1;
      isLoading = false;
      posts[index].liked = false;
      update();
      print(right);
    });
  }

  /// delete post
  void deletePost(int index) async {
    isLoading = true;
    final res = await postRepository.deletePost(id: posts[index].id.toString());
    res.fold((left) {
      Get.snackbar(
        "Error Occurred",
        left.toString(),
      );
      isLoading = false;
    }, (right) {
      posts.removeAt(index);
      isLoading = false;
      update();
      print(right);
    });
  }

  ///get posts liked by user
  void getPostLiked(String id) async {
    isLoading = true;
    final res = await postRepository.getPostLikes(id: id);
    res.fold((left) {
      Get.snackbar(
        "Error Occurred",
        left.toString(),
      );
      isLoading = false;
    }, (right) {
      print(right);
      Get.bottomSheet(
        Container(
          color: Colors.white,
          height: Get.height * 0.5,
          child: ListView.builder(
            itemCount: right[0].likes!.length,
            itemBuilder: (context, index) {
              final user = right[0].likes![index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.user!.image ?? ''),
                ),
                title: Text(user.user!.name ?? ''),
              );
            },
          ),
        ),
      );
    });
  }

  void getCommentByPostId(String id) async {
    final res = await postRepository.getCommentsByPost(id: id);
    res.fold((left) {
      Get.snackbar(
        "Error Occurred",
        left.toString(),
      );
      isLoading = false;
    }, (right) {
      return Get.bottomSheet(
        Container(
          height: Get.height * 0.5,
          child: Card(
            child: Column(
              children: [
                /// show all comments of the post and user profile
                /// and add comment
                Expanded(
                  child: ListView.builder(
                    itemCount: right.length,
                    itemBuilder: (context, index) {
                      final comment = right[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(comment.user!.image!),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comment.user!.name!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(comment.text!),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Comment can't be empty";
                            }
                          },
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: "Add Comment",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        )),
                        IconButton(
                          onPressed: () {
                            if (commentController.text.isNotEmpty)
                              postComment(id, commentController.text);
                          },
                          icon: Icon(Icons.send),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      );
    });
  }

  /// post comment

  void postComment(String postId, String comment) async {
    final res =
        await postRepository.postComment(postId: postId, comment: comment);
    res.fold((left) {
      Get.snackbar(
        "Error Occurred",
        left.toString(),
      );
      isLoading = false;
    }, (right) {
      print(right);

      /// clear textformfield
      ///
      commentController.clear();
      Get.back();
    });
  }
}
