import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Constant/app_colors.dart';
import '../../../Constant/app_strings.dart';
import '../../Data/Services/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'mylist_controller.dart';

class MyListView extends GetView<MyListController> {
  const MyListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(myList),
      ),
      body: Obx(() {
        if (controller.myMovies.isEmpty) {
          return Center(
            child: Text(
              noMoviesAdded,
              style: TextStyle(color: AppThemeHelper.textColor(context)),
            ),
          );
        }
        return GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.6,
          ),
          itemCount: controller.myMovies.length,
          itemBuilder: (context, index) {
            final movie = controller.myMovies[index];
            return Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      "$imageUrl${movie.posterPath}",
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}