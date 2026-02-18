import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:netflix/App/Modules/Search/search_controller.dart';
import 'package:netflix/Constant/app_colors.dart';
import 'package:netflix/Constant/app_size.dart';

import '../../Data/Services/utils.dart';

class SearchView extends GetView<CustomSearchController> {
  SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CupertinoSearchTextField(
              controller: controller.sController,
              onChanged: controller.updateQuery,
            ),

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
                    return Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.network(
                              "$imageUrl${movie.posterPath}",
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            Icon(
                              Icons.play_circle_outline,
                              color: whiteColor,
                            ),
                          ],
                        ),
                        SizedBox(width: size5,),
                        Expanded(
                          child: Text(
                            movie.title ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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
