import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:netflix/App/Modules/MyList/mylist_controller.dart';
import 'package:netflix/App/Routes/app_pages.dart';
import 'package:netflix/Constant/app_colors.dart';
import '../../../Constant/app_size.dart';
import '../../../Constant/app_strings.dart';
import '../../Data/Models/comman_movie_model.dart';
import '../../Data/Models/movie_category_model.dart';
import '../../Data/Models/movie_model.dart';
import '../../Data/Services/utils.dart';
import '../Download/download_controller.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 100,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: pad1),
              child: Row(
                children: [
                  // Image.asset(splashLogo, height: imageSize1),
                  const Text(
                    netflix,
                    style: TextStyle(
                      color: redColor,
                      fontSize: size3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.search);
                    },
                    icon: Icon(
                      Icons.search,
                      color: AppThemeHelper.textColor(context),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.download);
                    },
                    icon: Icon(
                      Icons.download_sharp,
                      color: AppThemeHelper.textColor(context),
                    ),
                  ),
                  // Icon(Icons.download_sharp, color: AppThemeHelper.textColor(context)),
                  const SizedBox(width: size1),
                  Icon(Icons.cast, color: AppThemeHelper.textColor(context)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: pad1),
              child: Row(
                children: [
                  MaterialButton(
                    onPressed: () {
                      controller.scrollController.animateTo(
                        700,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceIn,
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: greyColor),
                    ),
                    child: Text(
                      tvShows,
                      style: TextStyle(
                        color: AppThemeHelper.textColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: size1),
                  MaterialButton(
                    onPressed: () {
                      controller.scrollController.animateTo(
                        300,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceIn,
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: greyColor),
                    ),
                    child: Text(
                      movies,
                      style: TextStyle(
                        color: AppThemeHelper.textColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: size1),
                  Obx(
                    () => PopupMenuButton<Genres>(
                      color: AppThemeHelper.reverseTextColor(context),
                      onSelected: (Genres genre) {
                        debugPrint("GENRE CLICKED: ${genre.name}");
                        controller.selectGenre(genre);
                      },
                      itemBuilder: (context) {
                        debugPrint("Building menu items...");
                        debugPrint(
                          "Genres length: ${controller.genres.length}",
                        );
                        final limitedGenres = controller.genres
                            .take(5)
                            .toList();
                        return limitedGenres.map((genre) {
                          return PopupMenuItem<Genres>(
                            value: genre,
                            child: Text(
                              genre.name ?? "",
                              style: TextStyle(
                                color: AppThemeHelper.textColor(context),
                              ),
                            ),
                          );
                        }).toList();
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Text(
                              controller.selectedGenre.value?.name ??
                                  "Categories",
                              style: TextStyle(
                                color: AppThemeHelper.textColor(context),
                                fontSize: size2,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: AppThemeHelper.textColor(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size1),
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
                              onPageChanged: (index) {
                                controller.currentMovie.value = movies![index];
                              },
                              itemBuilder: (context, index) {
                                final moviesDatas = movies![index];
                                return GestureDetector(
                                  onTap: () {
                                    Get.toNamed(
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
                          return Center(child: Text(NetworkError));
                        }
                      },
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.08,
                        vertical: MediaQuery.of(context).size.height * 0.02,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: cHeight,
                            width: cWidth,
                            decoration: BoxDecoration(
                              color: AppThemeHelper.textColor(context),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.play_arrow,
                                  color: AppThemeHelper.reverseTextColor(
                                    context,
                                  ),
                                ),
                                Text(
                                  playText,
                                  style: TextStyle(
                                    color: AppThemeHelper.reverseTextColor(
                                      context,
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: size2),
                          Obx(() {
                            final currentMovie = controller.currentMovie.value;

                            // final isAdded =
                            //     currentMovie != null &&
                            //         controller.myListController.isAdded(currentMovie);

                            return GestureDetector(
                              onTap: () {
                                // if (currentMovie != null) {
                                //   controller.myListController.addMovie(currentMovie);
                                Get.toNamed(AppRoutes.myList);
                                // }
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
                                    Icon(Icons.list_alt, color: whiteColor),
                                    SizedBox(width: size8),
                                    Text(
                                      myList,
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
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
              if (controller.isGenreLoading.value) {
                return Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.selectedGenre.value != null) {
                return moviesListFromRx(
                  movies: controller.selectedGenreMovies,
                  movieType: controller.selectedGenre.value!.name ?? "",
                  context: context,
                );
              }

              return Container();
            }),

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
              future: controller.upcomingMoviesData ?? Future.value(null),
              movieType: upComingMovies,
              isReverse: true,
              context: context,
              selectedIndex: controller.selectedUpcomingPosterIndex,
            ),

            moviesTypes(
              future: controller.treadingMoviesData ?? Future.value(null),
              movieType: trendingMovies,
              isReverse: true,
              context: context,
              selectedIndex: controller.selectedTrendingPosterIndex,
            ),

            moviesTypes(
              future: controller.topRatedMoviesData ?? Future.value(null),
              movieType: topRatedMovies,
              isReverse: true,
              context: context,
              selectedIndex: controller.selectedTopRatedPosterIndex,
            ),
            moviesTypes(
              future: controller.tvPopularMoviesData ?? Future.value(null),
              movieType: tvPopularMovies,
              isReverse: true,
              context: context,
              selectedIndex: controller.selectedTvPopularPosterIndex,
            ),
          ],
        ),
      ),
    );
  }

  Widget moviesListFromRx({
    required List<MovieResults> movies,
    required String movieType,
    bool isReverse = false,
    required BuildContext context,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 20, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movieType,
            style: TextStyle(
              color: AppThemeHelper.textColor(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size1),
          SizedBox(
            height: cHeight1,
            child: ListView.builder(
              reverse: isReverse,
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];

                return GestureDetector(
                  onTap: () {
                    if (controller.selectedPosterIndex.value == index) {
                      controller.selectedPosterIndex.value = -1;

                      final myListController = Get.isRegistered<MyListController>()
                          ? Get.find<MyListController>()
                          : Get.put(MyListController());

                      // if(Get.isRegistered<MyListController>())
                     myListController.addMovie(movie);

                      Get.toNamed(AppRoutes.myList);
                    } else {
                      controller.selectedPosterIndex.value = index;
                    }
                  },
                  child: Obx(() {
                    final isSelected =
                        controller.selectedPosterIndex.value == index;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: cHeight2,
                        width: cWidth1,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: CachedNetworkImage(
                                imageUrl: "$imageUrl${movie.posterPath ?? ''}",
                                fit: BoxFit.cover,
                              ),
                            ),

                            if (isSelected)
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(6),
                                      bottomRight: Radius.circular(6),
                                    ),
                                  ),
                                  child: Center(
                                    child: Wrap(
                                      spacing: 10,
                                      alignment: WrapAlignment.center,
                                      children: [
                                        Obx(() {
                                          final downloadController =
                                              Get.find<DownloadController>();

                                          final isDownloading =
                                              downloadController
                                                  .downloadingMovieId
                                                  .value ==
                                              movie.id;

                                          final isDownloaded =
                                              downloadController.isDownloaded(
                                                movie,
                                              );

                                          return GestureDetector(
                                            onTap: () {
                                              downloadController.downloadMovie(
                                                movie,
                                              );
                                            },
                                            child: isDownloading
                                                ? const SizedBox(
                                                    height: 18,
                                                    width: 18,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Colors.white,
                                                        ),
                                                  )
                                                : Icon(
                                                    isDownloaded
                                                        ? Icons.check_circle
                                                        : Icons.download_sharp,
                                                    color: isDownloaded
                                                        ? Colors.green
                                                        : Colors.white,
                                                    size: 18,
                                                  ),
                                          );
                                        }),

                                        const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 18,
                                        ),

                                        const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget moviesTypes({
    required Future future,
    required String movieType,
    required RxInt selectedIndex,
    bool isReverse = false,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movieType,
            style: TextStyle(
              color: AppThemeHelper.textColor(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size1),
          SizedBox(
            height: cHeight1,
            width: double.infinity,
            child: FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  final movies = snapshot.data!.results;
                  return SizedBox(
                    height: cHeight1,
                    child: ListView.builder(
                      reverse: isReverse,
                      scrollDirection: Axis.horizontal,
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final moviesDatas = movies[index];

                        return GestureDetector(
                          onTap: () {
                            if (selectedIndex.value == index) {
                              selectedIndex.value = -1;
                              // controller.myListController.addMovie(movies[index]);
                            } else {
                              selectedIndex.value = index;
                            }
                            //   ---------------------------------------
                            // if (controller.selectedPosterIndex.value == index) {
                            //   controller.selectedPosterIndex.value = -1;
                            //
                            //   final myListController = Get.isRegistered<MyListController>()
                            //       ? Get.find<MyListController>()
                            //       : Get.put(MyListController());
                            //
                            //   // 🔥 Convert API model → MyMovie
                            //   final myMovie = MyMovie.fromMovieResults(moviesDatas);
                            //
                            //   myListController.addMyMovie(myMovie);
                            //
                            //   Get.toNamed(AppRoutes.myList);
                            // } else {
                            //   controller.selectedPosterIndex.value = index;
                            // }

                            // --------------------------------------
                            // if (controller.selectedPosterIndex.value == index) {
                            //   controller.selectedPosterIndex.value = -1;
                            //
                            //   // controller.myListController.addMovie(movies[index]);
                            //
                            //   Get.toNamed(AppRoutes.myList);
                            // } else {
                            //   controller.selectedPosterIndex.value = index;
                            // }
                          },
                          child: Obx(() {
                            final isSelected = selectedIndex.value == index;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: cHeight2,
                                width: cWidth1,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "$imageUrl${moviesDatas.posterPath}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    if (isSelected)
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.6,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                    6,
                                                  ),
                                                  bottomRight: Radius.circular(
                                                    6,
                                                  ),
                                                ),
                                          ),
                                          child: Center(
                                            child: Wrap(
                                              spacing: 10,
                                              alignment: WrapAlignment.center,
                                              children: [
                                                Obx(() {
                                                  final downloadController =
                                                      Get.find<
                                                        DownloadController
                                                      >();

                                                  final isDownloading =
                                                      downloadController
                                                          .downloadingMovieId
                                                          .value ==
                                                      moviesDatas.id;

                                                  final isDownloaded =
                                                      downloadController
                                                          .isMovieDownloadedById(
                                                            moviesDatas.id,
                                                          );

                                                  return GestureDetector(
                                                    onTap: () {
                                                      downloadController
                                                          .downloadMovieById(
                                                            movieId:
                                                                moviesDatas.id,
                                                            movieTitle:
                                                                moviesDatas
                                                                    .title,
                                                            movieJson:
                                                                moviesDatas
                                                                    .toJson(),
                                                          );
                                                      // downloadController.downloadMovie(moviesDatas.id);
                                                    },
                                                    child: isDownloading
                                                        ? const SizedBox(
                                                            height: 18,
                                                            width: 18,
                                                            child:
                                                                CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      2,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                          )
                                                        : Icon(
                                                            isDownloaded
                                                                ? Icons
                                                                      .check_circle
                                                                : Icons
                                                                      .download_sharp,
                                                            color: isDownloaded
                                                                ? Colors.green
                                                                : Colors.white,
                                                            size: 18,
                                                          ),
                                                  );
                                                }),

                                                const Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                  size: 18,
                                                ),

                                                const Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  );
                } else {
                  return Center(child: Text(NetworkError));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
