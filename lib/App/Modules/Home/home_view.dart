import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  // final controller = Get.put(HomeController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Netflix')),
      // body: Obx(() {
      //   if (controller.loading.value) {
      //     return const Center(child: CircularProgressIndicator());
      //   }
      //   return ListView(
      //     children: [
      //       BannerWidget(movie: controller.trending.first),
      //       MovieHorizontalList(movies: controller.trending),
      //     ],
      //   );
      // }),
    );
  }
}

// class MovieHorizontalList extends StatelessWidget {
//   final List<Movie> movies;
//
//
//   const MovieHorizontalList({required this.movies});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: movies.length,
//         itemBuilder: (_, i) => Padding(
//           padding: const EdgeInsets.all(8),
//           child: Image.network(
//             'https://image.tmdb.org/t/p/w500${movies[i].poster}',
//           ),
//         ),
//       ),
//     );
//   }
// }