import 'package:facebook_clone/controllers/post_controller.dart';
import 'package:facebook_clone/data/repositories/post_repository.dart';
import 'package:get/get.dart';

import '../../data/provider/post_provider.dart';

class PostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostController>(
      () => PostController(postRepo: PostRepo(postProvider: PostProvider())),
    );
  }
}
