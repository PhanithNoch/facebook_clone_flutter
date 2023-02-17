import 'dart:io';

import 'package:facebook_clone/data/repositories/post_repository.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final PostRepo postRepo;
  PostController({required this.postRepo});
  File? image;

  /// pick image from gallery and set it to image variable
  Future pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      update();
    } else {
      print('No image selected.');
    }
  }

  /// create post
  void createPost({required String title, required String body}) async {
    final res =
        await postRepo.createPost(title: title, body: body, file: image!);
    res.fold(
        (left) => Get.snackbar(
              "Error Occurred",
              left.toString(),
            ), (right) {
      Get.back(result: true);
      print(right);
    });
  }
}
