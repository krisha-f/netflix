import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:netflix/App/Data/Models/movie_model.dart';
import 'package:netflix/App/Routes/app_pages.dart';
import 'package:netflix/Constant/app_colors.dart';
import '../../../Constant/app_images.dart';
import '../../../Constant/app_size.dart';
import '../../../Constant/app_strings.dart';
import '../../Data/Services/utils.dart';
import '../MyList/mylist_controller.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
   HomeView({super.key});

  final myListController = Get.put(MyListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size3),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: pad1),
              child: Row(
                children: [
                  Image.asset(splashLogo, height: imageSize1),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Get.offAllNamed(
                        AppRoutes.search,
                      );
                    },
                    icon: Icon(Icons.search, color: whiteColor),
                  ),
                  Icon(Icons.download_sharp, color: whiteColor),
                  SizedBox(width: size1),
                  Icon(Icons.cast, color: whiteColor),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: pad1),
              child: Row(
                children: [
                  MaterialButton(
                    onPressed: () {
                      controller.scrollController.animateTo(700, duration: Duration(milliseconds: 100), curve: Curves.bounceIn);

                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: greyColor),
                    ),
                    child: Text(
                      tvShows,
                      style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: size1),
                  MaterialButton(
                    onPressed: () {
                      controller.scrollController.animateTo(300, duration: Duration(milliseconds: 100), curve: Curves.bounceIn);

                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: greyColor),
                    ),
                    child: Text(
                      movies,
                      style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: size1),

                  MaterialButton(
                    onPressed: () {

                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: greyColor),
                    ),
                    child: Row(
                      children: [
                        Text(
                          categories,
                          style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down, color: whiteColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: pad1,
                vertical: pad1,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 600,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: greyColor),
                    ),
                    child: FutureBuilder(
                      future: controller.moviesData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error}"),
                          );
                        } else if (snapshot.hasData) {
                          final movies = snapshot.data!.results;
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: PageView.builder(
                              itemCount: movies?.length,
                              itemBuilder: (context, index) {
                                final moviesDatas = movies![index];
                                return GestureDetector(
                                  onTap: () {
                                    Get.offAllNamed(
                                      AppRoutes.movieDetails,
                                      arguments: moviesDatas.id,
                                    );
                                  },
                                  child: Container(
                                    height: 600,
                                    width: 600,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: whiteColor,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                          "$imageUrl${moviesDatas.posterPath}",
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Center(child: Text("Problem To Fetch Data"));
                        }
                      },
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.play_arrow, color: blackColor),
                                Text(
                                  "Play",
                                  style: TextStyle(
                                    color: blackColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: size2),
                          // Container(
                          //   height: 50,
                          //   width: 150,
                          //   decoration: BoxDecoration(
                          //     color: greyColor,
                          //     borderRadius: BorderRadius.circular(5),
                          //   ),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       Icon(Icons.list_alt, color: whiteColor),
                          //       Text(
                          //         "My List",
                          //         style: TextStyle(
                          //           color: whiteColor,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Obx(() {
                            final currentMovie = controller.currentMovie.value;

                            final isAdded =
                                currentMovie != null &&
                                    controller.myListController.isAdded(currentMovie);

                            return GestureDetector(
                              onTap: () {
                                if (currentMovie != null) {
                                  controller.myListController.addMovie(currentMovie);
                                  Get.toNamed(AppRoutes.myList);
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: greyColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isAdded ? Icons.check : Icons.list_alt,
                                      color: whiteColor,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      isAdded ? "Added" : "My List",
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            moviesTypes(
              future: controller.treadingMoviesData,
              movieType: "Trending Movies ",
              isReverse: true,
            ),
            moviesTypes(
              future: controller.upcomingMoviesData,
              movieType: "Upcoming Movies ",
              isReverse: true,
            ),
            moviesTypes(
              future: controller.topRatedMoviesData,
              movieType: "Top Rated Movies ",
              isReverse: true,
            ),
            moviesTypes(
              future: controller.tvPopularMoviesData,
              movieType: "Tv Popular Movies ",
              isReverse: true,
            ),
          ],
        ),
      ),
    );
  }

  Padding moviesTypes({
    required Future future,
    required String movieType,
    bool isReverse = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 20, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movieType,
            style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size1),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  final movies = snapshot.data!.results;
                  return ListView.builder(
                    reverse: isReverse,
                    scrollDirection: Axis.horizontal,
                    itemCount: movies?.length,
                    itemBuilder: (context, index) {
                      final moviesDatas = movies![index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            // Get.offAllNamed(
                            //   AppRoutes.movieDetails,
                            //   arguments: movies.id,
                            // );
                          },
                          child: Container(
                            height: 100,
                            width: 130,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                  "$imageUrl${moviesDatas.posterPath}",
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text("Problem To Fetch Data"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
