import 'package:facebook_clone/bindings/post/post_binding.dart';
import 'package:facebook_clone/views/screens/auth/login_screen.dart';
import 'package:facebook_clone/views/screens/auth/register_screen.dart';
import 'package:facebook_clone/views/screens/home/home_screen.dart';
import 'package:facebook_clone/views/screens/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'bindings/auth/auth_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // initialBinding: HomeBinding(),
      initialRoute: 'main',
      getPages: [
        GetPage(
            name: '/login', page: () => LoginScreen(), binding: AuthBinding()),
        GetPage(
          name: '/register',
          page: () => RegisterScreen(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/main',
          page: () => HomeScreen(),
        ),
        GetPage(
            name: '/create_post_screen',
            page: () => CreatePostScreen(),
            binding: PostBinding()),
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: LoginScreen(),
    );
  }
}
