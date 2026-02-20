import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:netflix/App/Modules/Search/search_controller.dart';
import 'package:netflix/Constant/app_colors.dart';
import 'package:netflix/Constant/app_size.dart';
import '../../Data/Services/utils.dart';
import '../trailer_player_screen.dart';

class SearchView extends GetView<CustomSearchController> {
  SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CupertinoSearchTextField(
              controller: controller.sController,
              onChanged: controller.updateQuery,
            ),

            SizedBox(height: size2),

            Expanded(
              child: Obx(() {
                if (controller.query.value.isEmpty) {
                  return FutureBuilder(
                    future: controller.trendingMovies,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final movies = snapshot.data?.results ?? [];

                      return ListView.builder(
                        itemCount: movies.length,
                        itemBuilder: (_, index) {
                          final movie = movies[index];
                          return ListTile(title: Text(movie.title ?? ''));
                        },
                      );
                    },
                  );
                }

                if (controller.isSearching.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final results = controller.searchMovie.value?.results ?? [];

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (_, index) {
                    final movie = results[index];
                    return Column(
                      children: [
                        Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                movie.posterPath != null?
                                Image.network(
                                  "$imageUrl${movie.posterPath}",
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ):SizedBox.shrink(),
                                movie.posterPath != null?
                                InkWell(
                                  onTap: () async {
                                    Get.dialog(
                                      const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      barrierDismissible: false,
                                    );
                                    final trailerData = await controller
                                        .fetchTrailer(movie.id ?? 0);
                                    Get.back();
                                    if (trailerData != null &&
                                        trailerData.results != null &&
                                        trailerData.results!.isNotEmpty) {
                                      // Find official YouTube trailer
                                      final trailer = trailerData.results!
                                          .firstWhere(
                                            (video) =>
                                                video.type == "Trailer" &&
                                                video.site == "YouTube",
                                            orElse: () =>
                                                trailerData.results!.first,
                                          );

                                      if (trailer.key != null &&
                                          trailer.key!.isNotEmpty) {
                                        Get.to(
                                          () => TrailerPlayerScreen(
                                            videoKey: trailer.key!,
                                          ),
                                        );
                                      } else {
                                        Get.snackbar(
                                          "Error",
                                          "Trailer key not found",
                                        );
                                      }
                                    } else {
                                      Get.snackbar(
                                        "Error",
                                        "Trailer not available",
                                      );
                                    }
                                  },
                                  child: Icon(
                                    Icons.play_circle_outline,
                                    color: whiteColor,
                                  ),
                                ):SizedBox.shrink(),
                              ],
                            ),
                            SizedBox(width: size5),
                            movie.posterPath != null?
                            Text(
                              movie.title ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ):SizedBox.shrink(),
                          ],
                        ),
                        SizedBox(height: size2),
                      ],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
