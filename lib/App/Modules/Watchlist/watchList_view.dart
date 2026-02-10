// class WatchlistView extends StatelessWidget {
//   final controller = Get.put(WatchlistController());
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Watchlist')),
//       body: Obx(() => ListView(
//         children: controller.watchlist
//             .map((m) => ListTile(title: Text(m.title)))
//             .toList(),
//       )),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netflix/App/Modules/Watchlist/watchList_controller.dart';

class WatchlistView extends GetView<WatchlistController> {
  const WatchlistView({super.key});

  // final storage = Get.find<StorageService>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Text("watchlist")
    );
  }
}