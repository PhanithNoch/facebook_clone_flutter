import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:facebook_clone/constant/constant.dart';
import 'package:facebook_clone/data/models/user/user_info_res_model.dart';
import 'package:get_storage/get_storage.dart';

import '../models/auth/register_user_res_model.dart';

class AuthProvider {
  ///register user with email and password and name and profile image
  final dio = Dio();
  final storage = GetStorage();

  Future<Either<String, RegisterUserResModel>> registerUser(
      {required String name,
      required String email,
      required String password,
      required File image}) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'image': await MultipartFile.fromFile(image.path),
      });
      final res = await dio.post(
        '$kBaseUrl/register',
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print(res.data);
      if (res.statusCode == 200) {
        return Right(RegisterUserResModel.fromJson(res.data));
      } else {
        return Left(res.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// login user with email and password
  Future<Either<String, RegisterUserResModel>> loginUser(
      {required String email, required String password}) async {
    try {
      final res = await dio.post(
        '$kBaseUrl/login',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print(res.data);
      if (res.statusCode == 200) {
        return Right(RegisterUserResModel.fromJson(res.data));
      } else {
        return Left(res.data['message']);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// get current user logged
  Future<Either<String, UserInfoResModel>> getCurrentUserLogged() async {
    try {
      final res = await dio.get(
        '$kBaseUrl/user',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${storage.read('token')}'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print(res.data);
      if (res.statusCode == 200) {
        return Right(UserInfoResModel.fromJson(res.data));
      } else {
        return Left(res.data['message']);
      }
    } catch (e) {
      print('error: $e');
      return Left(e.toString());
    }
  }

  /// get posts
}
