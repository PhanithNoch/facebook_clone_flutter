import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:facebook_clone/data/models/auth/register_user_res_model.dart';

import '../provider/auth_provider.dart';

class AuthRepository {
  final AuthProvider authProvider;
  AuthRepository({required this.authProvider});

  /// register user

  Future<Either<String, RegisterUserResModel>> registerUser(
      {required String name,
      required String email,
      required String password,
      required File image}) async {
    return authProvider.registerUser(
        name: name, email: email, password: password, image: image);
  }

  /// login user with email and password
  Future<Either<String, RegisterUserResModel>> loginUser(
      {required String email, required String password}) async {
    return authProvider.loginUser(email: email, password: password);
  }
}
