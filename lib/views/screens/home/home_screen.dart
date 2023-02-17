import 'package:facebook_clone/controllers/home/home_controller.dart';
import 'package:facebook_clone/data/repositories/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/provider/auth_provider.dart';
import '../../../data/provider/post_provider.dart';
import '../../../data/repositories/post_repository.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({Key? key}) : super(key: key);
  final controller = Get.put(HomeController(
    userRepository: UserRepo(
      authProvider: AuthProvider(),
    ),
    postRepository: PostRepo(
      postProvider: PostProvider(),
    ),
  ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: GetBuilder<HomeController>(builder: (_) {
        if (controller.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (controller.isError) {
          return Center(
            child: Text('Error Occurred'),
          );
        }
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(controller.userInfo.user!.name ?? ''),
                accountEmail: Text('${controller.userInfo.user!.email}'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage:
                      NetworkImage('${controller.userInfo.user!.image}'),
                ),
              ),
              ListTile(
                title: Text('Home'),
                onTap: () {
                  Get.back();
                },
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  controller.logout();
                },
              ),
            ],
          ),
        );
      }),
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              controller.logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            MaterialButton(
              onPressed: () async {
                // controller.pickImage();
                final data = await Get.toNamed('create_post_screen');
                if (data != null) {
                  /// refresh the post
                }
              },
              child: Row(
                children: [
                  Spacer(),
                  Icon(Icons.camera_alt),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Photo'),
                  Spacer(),
                ],
              ),
            ),
            Expanded(
              child: GetBuilder<HomeController>(builder: (_) {
                if (controller.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (controller.isError) {
                  return Center(
                    child: Text('Error Occurred'),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.builder(
                    itemCount: controller.posts.length,
                    itemBuilder: (context, index) {
                      final post = controller.posts[index];
                      final user = controller.posts[index].user;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: [
                            /// user info
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(user!.image ?? ''),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.name ?? ''),
                                    Text(controller
                                        .timeAgoSinceDate(post.createdAt!)),
                                  ],
                                ),

                                /// edit and delete
                                /// adding menu dropdown
                                Spacer(),
                                PopupMenuButton(
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        child: Text('Edit'),
                                        value: 'edit',
                                      ),
                                      PopupMenuItem(
                                        child: Text('Delete'),
                                        value: 'delete',
                                      ),
                                    ];
                                  },
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      Get.toNamed('edit_post_screen',
                                          arguments: post);
                                    } else if (value == 'delete') {
                                      controller.deletePost(index);
                                    }
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text('${post.title}'),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Image.network(
                              post.image ?? '',
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text('${post.likesCount} likes'),
                                InkWell(
                                  onTap: () {
                                    if (post.likesCount! > 0)
                                      controller
                                          .getPostLiked(post.id.toString());

                                    ///show bottom sheet for who is liked the post
                                  },
                                  child: Text(
                                    " ${post.firstUserLiked!.name} and ${post.likes!.isNotEmpty ? "${post.likes!.length - 1} others" : 0} " ??
                                        '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                            Divider(
                              thickness: 1,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (!post.liked!) {
                                          controller.likePost(index);
                                        } else {
                                          if (post.likesCount! > 0 &&
                                              post.liked != null) {
                                            controller.unlikePost(index);
                                          }
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.thumb_up,
                                              color: post.liked!
                                                  ? Colors.blue
                                                  : Colors.black),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text('Like'),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: InkWell(
                                  child: Row(
                                    children: [
                                      Icon(Icons.comment),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('${post.commentsCount} comments'),
                                    ],
                                  ),
                                  onTap: () {
                                    if (post.commentsCount! > 0)
                                      controller.getCommentByPostId(
                                          post.id.toString());
                                  },
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );

                      // ListTile(
                      //   title: Text(controller.posts[index].title ?? ''),
                      //   subtitle: Text(controller.posts[index].desc ?? ''),
                      //   leading: CircleAvatar(
                      //     backgroundImage: NetworkImage(
                      //       controller.posts[index].image ?? '',
                      //     ),
                      //   ),
                      // );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
