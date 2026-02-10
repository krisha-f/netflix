import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import 'movie_details_controller.dart';

class MovieDetailsView extends GetView<MovieDetailsController> {
  const MovieDetailsView({super.key});

  // final controller = Get.put(DetailsController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(controller.movie.title)),
      // body: Column(
      //   children: [
      //     Image.network('https://image.tmdb.org/t/p/w500${controller.movie.poster}'),
      //     Text(controller.movie.title),
      //   ],
      // ),
    );
  }

}