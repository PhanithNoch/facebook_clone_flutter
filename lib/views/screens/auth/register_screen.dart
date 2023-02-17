import 'package:facebook_clone/controllers/auth/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/constant.dart';

class RegisterScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // final controller = Get.put(AuthenticationController());
  RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Facebook Clone'.toUpperCase(),
                  style: kLoginTitleTextStyle,
                ),

                /// pick image from gallery
                SizedBox(
                  height: 10,
                ),
                GetBuilder<AuthenticationController>(builder: (con) {
                  if (con.image != null) {
                    return Container(
                        child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 53,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(con.image!),
                          ),
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
                  } else {
                    return Container(
                        child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey,
                          child: ClipOval(
                            child: SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.network(
                                  'https://www.w3schools.com/howto/img_avatar.png',
                                  fit: BoxFit.fill,
                                )),
                          ),
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (Get.find<AuthenticationController>().image == null) {
                      Get.snackbar('Error', 'Please select image');
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      Get.find<AuthenticationController>().regiser(
                        name: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        image: Get.find<AuthenticationController>().image!,
                      );

                      /// clear text field
                      /// after register
                      nameController.clear();
                      emailController.clear();
                      passwordController.clear();
                    }
                  },
                  child: const Text('Sign Up'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
