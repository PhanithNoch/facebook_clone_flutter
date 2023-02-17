import '../provider/auth_provider.dart';

class UserRepo {
  final AuthProvider authProvider;
  UserRepo({required this.authProvider});
  getUserInfo() async {
    return authProvider.getCurrentUserLogged();
  }
}
