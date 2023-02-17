import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:facebook_clone/data/repositories/auth_repository.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthenticationController extends GetxController {
  final AuthRepository authRepository;
  AuthenticationController({required this.authRepository});
  final picker = ImagePicker();
  File? image;

  /// pick image from gallery and set it to image variable
  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      update();
    } else {
      print('No image selected.');
    }
  }

  ///regiser
  void regiser(
      {required String name,
      required String email,
      required String password,
      required File image}) {
    final res = authRepository.registerUser(
        name: name, email: email, password: password, image: image);
    res.fold(
        (left) => Get.snackbar(
              "Error Occurred",
              left.toString(),
            ), (right) {
      Get.snackbar("Success", "User Registered Successfully");
      print(right);
    });
  }

  /// login user
  void login({required String email, required String password}) {
    final res = authRepository.loginUser(email: email, password: password);
    res.fold(
        (left) => Get.snackbar(
              "Error Occurred",
              left.toString(),
            ), (right) {
      // Get.snackbar("Success", "User Logged In Successfully");
      saveToken(token: right.accessToken!);
      Get.offAllNamed("/main");
      print(right);
    });
  }

  /// save token to local storage and navigate to home screen if user is logged in before and token is not expired yet.
  /// if token is expired or user is not logged in before then navigate to login screen

  /// save token to local storage and navigate to home screen
  void saveToken({required String token}) async {
    await GetStorage().write("token", token);
  }
}
