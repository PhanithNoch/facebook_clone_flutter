import 'package:facebook_clone/controllers/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePostScreen extends GetView<PostController> {
  CreatePostScreen({Key? key}) : super(key: key);
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Post'),
          actions: [
            IconButton(
                onPressed: () {
                  controller.createPost(
                      title: titleController.text, body: titleController.text);
                },
                icon: const Icon(Icons.send)),
          ],
        ),
        body: Column(
          children: [
            /// pick image from gallery or camera and show it in image widget
            /// show image in image widget
            TextFormField(
              controller: titleController,
              maxLines: 5,
              decoration: const InputDecoration(
                  labelText: 'What\'s on your mind?', border: InputBorder.none),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GetBuilder<PostController>(builder: (con) {
                  if (con.image != null) {
                    return Container(
                        child: Stack(
                      children: [
                        Image(
                          image: FileImage(con.image!),
                          fit: BoxFit.cover,
                          width: Get.width,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: IconButton(
                              onPressed: () {
                                con.pickImage();
                              },
                              icon: Icon(Icons.camera_alt),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ));
                  } else {
                    return Container(
                        child: Stack(
                      children: [
                        Image.network(
                          width: Get.width,
                          'https://www.w3schools.com/howto/img_avatar.png',
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: IconButton(
                              onPressed: () {
                                con.pickImage();
                              },
                              icon: Icon(Icons.camera_alt),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ));
                  }
                }),
              ],
            ),
          ],
        ));
  }
}
