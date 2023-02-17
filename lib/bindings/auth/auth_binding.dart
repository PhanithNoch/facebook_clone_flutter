import 'package:facebook_clone/data/provider/auth_provider.dart';
import 'package:facebook_clone/data/repositories/auth_repository.dart';
import 'package:get/get.dart';

import '../../controllers/auth/authentication_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AuthenticationController(
        authRepository: AuthRepository(authProvider: AuthProvider()),
      ),
    );
  }
}
