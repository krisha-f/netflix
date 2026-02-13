import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:netflix/App/Routes/app_pages.dart';
import 'package:netflix/Constant/app_colors.dart';
import '../../../Constant/app_size.dart';
import '../../../Constant/app_strings.dart';
import '../../Data/Models/movie_category_model.dart';
import '../../Data/Services/utils.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
   const HomeView({super.key});

  // final myListController = Get.put(MyListController());

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
                  // Image.asset(splashLogo, height: imageSize1),
                  Text(
                   netflix,
                    style: TextStyle(
                      color: redColor,
                      fontSize: size3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Get.offAllNamed(
                        AppRoutes.search,
                      );
                    },
                    icon: Icon(Icons.search, color: AppThemeHelper.textColor(context)),
                  ),
                  Icon(Icons.download_sharp, color: AppThemeHelper.textColor(context)),
                  SizedBox(width: size1),
                  Icon(Icons.cast, color: AppThemeHelper.textColor(context)),
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
                        color: AppThemeHelper.textColor(context),
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
                        color: AppThemeHelper.textColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: size1),

                  // MaterialButton(
                  //   onPressed: () {
                  //
                  //   },
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(20),
                  //     side: BorderSide(color: greyColor),
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         categories,
                  //         style: TextStyle(
                  //           color: AppThemeHelper.textColor(context),
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       Icon(Icons.keyboard_arrow_down, color: AppThemeHelper.textColor(context)),
                  //     ],
                  //   ),
                  // ),
                  Obx(() => Positioned(
                    child: PopupMenuButton<Genres>(
                      color: Colors.black,
                      onSelected: (Genres genre) {
                        debugPrint("GENRE CLICKED: ${genre.name}");
                        controller.selectGenre(genre);
                      },
                      itemBuilder: (context) {
                        debugPrint("Building menu items...");
                        debugPrint("Genres length: ${controller.genres.length}");
                        final limitedGenres =
                        controller.genres.take(5).toList();
                        return limitedGenres.map((genre) {
                          return PopupMenuItem<Genres>(
                            value: genre,
                            child: Text(
                              genre.name ?? "",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList();
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Text(
                              controller.selectedGenre.value?.name ?? "Categories",
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(Icons.keyboard_arrow_down, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ))
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
                    height: containerSize,
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
                                    height: containerSize,
                                    width: containerSize,
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
                          return Center(child: Text(problemToFetchData));
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
                            height: cHeight,
                            width: cWidth,
                            decoration: BoxDecoration(
                              color:AppThemeHelper.textColor(context)    ,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.play_arrow, color:  AppThemeHelper.reverseTextColor(context)),
                                Text(
                                    playText,
                                  style: TextStyle(
                                    color: AppThemeHelper.reverseTextColor(context),
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
                                height: cHeight,
                                width: cWidth,
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
                                    SizedBox(width: size8),
                                    Text(
                                      isAdded ? added : myList,
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
            SizedBox(height: size3),
            // moviesTypes(
            //   future: controller.treadingMoviesData,
            //   movieType: trendingMovies,
            //   isReverse: true,
            //   context: context
            // ),
            // moviesTypes(
            //   future: controller.upcomingMoviesData,
            //   movieType: upComingMovies,
            //   isReverse: true,
            //     context: context
            //
            // ),
            Obx(() {
              debugPrint("*********************************");
              debugPrint("*********************************");
              debugPrint(controller.selectedGenre.value?.name);
              debugPrint(controller.selectedGenreMovies.value.toString());
              debugPrint("*********************************");
              debugPrint("*********************************");

              if (controller.selectedGenre.value != null &&
                  controller.selectedGenreMovies.value != null) {
                return moviesTypes(
                  future: controller.selectedGenreMovies.value!,
                  movieType: controller.selectedGenre.value!.name ?? "",
                  isReverse: true,
                  context: context,
                );
              }

              return Column(
                children: [
                  moviesTypes(
                    future: controller.treadingMoviesData,
                    movieType: trendingMovies,
                    isReverse: true,
                    context: context,
                  ),
                  moviesTypes(
                    future: controller.upcomingMoviesData,
                    movieType: upComingMovies,
                    isReverse: true,
                    context: context,
                  ),
                ],
              );
            }),

            // moviesTypes(
            //   future: controller.treadingMoviesData,
            //   movieType: trendingMovies,
            //   isReverse: true,
            //   context: context,
            // ),
            // moviesTypes(
            //   future: controller.upcomingMoviesData,
            //   movieType: upComingMovies,
            //   isReverse: true,
            //   context: context,
            // ),

            moviesTypes(
              future: controller.topRatedMoviesData,
              movieType: topRatedMovies,
              isReverse: true,
                context: context

            ),
            moviesTypes(
              future: controller.tvPopularMoviesData,
              movieType: tvPopularMovies,
              isReverse: true,
                context: context

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
    context
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 20, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movieType,
            style: TextStyle(color: AppThemeHelper.textColor(context), fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size1),
          SizedBox(
            height: cHeight1,
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
                        final isHovering = false.obs;
                        return SizedBox(
                          height: cHeight2,
                          width: cWidth1,
                          child: Obx(() => MouseRegion(
                            onEnter: (_) => isHovering.value = true,
                            onExit: (_) => isHovering.value = false,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [

                                // POSTER
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: CachedNetworkImage(
                                    imageUrl: "$imageUrl${moviesDatas.posterPath}",
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                // HOVER OVERLAY
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 200),
                                  opacity: isHovering.value ? 1 : 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.play_arrow, color: Colors.white),
                                            Icon(Icons.thumb_up, color: Colors.white),
                                            Icon(Icons.add, color: Colors.white),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                        );
                      }                      );
                } else {
                  return Center(child: Text(problemToFetchData));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

   Padding categoryMoviesTypes({
     required Future future,
     required String movieType,
     bool isReverse = false,
     context
   }) {
     return Padding(
       padding: EdgeInsets.only(left: 10, top: 20, right: 10),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(
             movieType,
             style: TextStyle(color: AppThemeHelper.textColor(context), fontWeight: FontWeight.bold),
           ),
           SizedBox(height: size1),
           SizedBox(
             height: cHeight1,
             width: double.infinity,
             child: FutureBuilder(
               future: future,
               builder: (context, snapshot) {

                 if (snapshot.connectionState == ConnectionState.waiting) {
                   return Center(child: CircularProgressIndicator());
                 }

                 if (snapshot.hasError) {
                   return Center(child: Text("Error: ${snapshot.error}"));
                 }

                 if (snapshot.hasData) {

                   final data = snapshot.data;
                   final movies = data?.results ?? [];

                   return ListView.builder(
                       reverse: isReverse,
                       scrollDirection: Axis.horizontal,
                       itemCount: movies?.length,
                       itemBuilder: (context, index) {
                         final moviesDatas = movies![index];
                         final isHovering = false.obs;
                         return SizedBox(
                           height: cHeight2,
                           width: cWidth1,
                           child: Obx(() => MouseRegion(
                             onEnter: (_) => isHovering.value = true,
                             onExit: (_) => isHovering.value = false,
                             child: Stack(
                               fit: StackFit.expand,
                               children: [

                                 // POSTER
                                 ClipRRect(
                                   borderRadius: BorderRadius.circular(6),
                                   child: CachedNetworkImage(
                                     imageUrl: "$imageUrl${moviesDatas.posterPath}",
                                     fit: BoxFit.cover,
                                   ),
                                 ),

                                 // HOVER OVERLAY
                                 AnimatedOpacity(
                                   duration: Duration(milliseconds: 200),
                                   opacity: isHovering.value ? 1 : 0,
                                   child: Container(
                                     decoration: BoxDecoration(
                                       color: Colors.black.withOpacity(0.6),
                                       borderRadius: BorderRadius.circular(6),
                                     ),
                                     child: Align(
                                       alignment: Alignment.bottomCenter,
                                       child: Padding(
                                         padding: EdgeInsets.all(8),
                                         child: Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                           children: [
                                             Icon(Icons.play_arrow, color: Colors.white),
                                             Icon(Icons.thumb_up, color: Colors.white),
                                             Icon(Icons.add, color: Colors.white),
                                           ],
                                         ),
                                       ),
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                           )),
                         );
                       }                      );
                 }
                 return SizedBox();
               },
             ),
           ),
         ],
       ),
     );
   }
}
