import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:netflix/App/Modules/Auth/signup_view.dart';
import 'package:netflix/Constant/app_size.dart';
import '../../../Constant/app_colors.dart';
import '../../Routes/app_pages.dart';
import '../Auth/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "NETFLIX",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 40),
                Text(
                  "LogIn",
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),

                TextField(
                  controller: controller.emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[900],
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                SizedBox(height: 16),

                TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[900],
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                SizedBox(height: 24),

                Obx(
                  () => controller.isLoading.value
                      ? CircularProgressIndicator(color: Colors.red)
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: controller.login,
                            child: Text("Sign In"),
                          ),
                        ),
                ),

                SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.signup);
                  },
                  child: Text(
                    "New to Netflix? Sign up",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                SizedBox(height: size3),
                ElevatedButton(
                  onPressed: () {
                    controller.signInWithGoogle;
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: whiteColor,shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),elevation: 2.0,),
                  child: Center(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.google),
                      SizedBox(width: size1,),
                      Text("log In With Google"),
                    ],
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
