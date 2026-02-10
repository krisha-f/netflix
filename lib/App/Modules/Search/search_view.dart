import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({super.key});

  // final controller = Get.put(SearchController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      // body: Obx(() => GridView.builder(
      //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      //   itemCount: controller.results.length,
      //   itemBuilder: (_, i) => Text(controller.results[i].title),
      // )),
    );
  }
}