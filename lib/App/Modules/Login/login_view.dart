import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  // final controller = Get.put(LoginController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      // body: Center(
      //   child: ElevatedButton(
      //     onPressed: controller.login,
      //     child: const Text('Login'),
      //   ),
      // ),
    );
  }
}