import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'hotnews_controller.dart';

class HotNewsView extends GetView<HotNewsController> {
  const HotNewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("hot news")),);}}