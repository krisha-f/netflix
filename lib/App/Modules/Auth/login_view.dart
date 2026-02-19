import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:netflix/Constant/app_size.dart';
import '../../../Constant/app_colors.dart';
import '../../../Constant/app_strings.dart';
import '../../Routes/app_pages.dart';
import '../Auth/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  netflix,
                  style: TextStyle(
                    color: redColor,
                    fontSize: size4,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: size5),
                Text(
                  logIn,
                  style: TextStyle(
                    color: AppThemeHelper.textColor(context),
                    fontSize: size4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: size2),

                TextField(
                  controller: controller.emailController,
                  style: TextStyle(color: AppThemeHelper.textColor(context)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: textFieldColor,
                    hintText: email,
                    hintStyle: TextStyle(color: greyColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                SizedBox(height: size6),

                TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  style: TextStyle(color: AppThemeHelper.textColor(context)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: textFieldColor,
                    hintText: password,
                    hintStyle: TextStyle(color: greyColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                SizedBox(height: size7),

                Obx(
                  () => controller.isLoading.value
                      ? CircularProgressIndicator(color: redColor)
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:redColor,
                            ),
                            onPressed: controller.login,
                            child: Text(signIn),
                          ),
                        ),
                ),

                SizedBox(height: size2),

                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.signup);
                  },
                  child: Text(
                    newToNetflixSignup,
                    style: TextStyle(color: AppThemeHelper.textColor(context)),
                  ),
                ),

                SizedBox(height: size3),
                ElevatedButton(
                  onPressed: () {
                    controller.signInWithGoogle();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppThemeHelper.textColor(context),shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),elevation: 2.0,),
                  child: Center(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.g_mobiledata,color: blackColor,size: 40,),
                      // FaIcon(FontAwesomeIcons.google,color: blackColor,),
                      SizedBox(width: size1,),
                      Text(logInWithGoogle,style: TextStyle(color: blackColor),),
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
