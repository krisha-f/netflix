import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netflix/App/Data/Services/utils.dart';
import 'package:netflix/App/Routes/app_pages.dart';
import 'package:netflix/Constant/app_size.dart';
import '../../../Constant/app_colors.dart';
import '../../../Constant/app_images.dart';
import '../../../Constant/app_strings.dart';
import '../../Data/Models/movie_details_model.dart';
import '../MyList/mylist_controller.dart';
import '../trailer_player_screen.dart';
import 'movie_details_controller.dart';
import 'package:share_plus/share_plus.dart';

class MovieDetailsView extends GetView<MovieDetailsController> {
  const MovieDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String formateRuntime(int runtime) {
      int hours = runtime ~/ 60;
      int minute = runtime % 60;
      return "${hours}h ${minute}m";
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: controller.movieDetailsData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              print("ERROR: ${snapshot.error}");
              return Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Center(child: Text("Network Error: please check your network")),
              );
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text(noDataFound));
            }
            if (snapshot.hasData) {
              final movie = snapshot.data;
              String genresText =
                  movie?.genres?.map((genre) => genre.name).join(", ") ?? "";
              return Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: size.height * 0.5,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              "$imageUrl${movie?.posterPath}",
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 30,
                        top: 50,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: CircleAvatar(
                                backgroundColor: blackColor,
                                child: Icon(Icons.close, color: whiteColor),
                              ),
                            ),
                            SizedBox(width: size1),
                            CircleAvatar(
                              backgroundColor: blackColor,
                              child: Icon(Icons.cast, color: whiteColor),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 100,
                        bottom: 100,
                        right: 100,
                        left: 100,
                        child: InkWell(
                          onTap: () async {
                            Get.dialog(
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                              barrierDismissible: false,
                            );

                            final trailerData = await controller.fetchTrailer(
                              movie?.id ?? 0,
                            );

                            Get.back();

                            if (trailerData != null &&
                                trailerData.results != null &&
                                trailerData.results!.isNotEmpty) {
                              // Find official YouTube trailer
                              final trailer = trailerData.results!.firstWhere(
                                (video) =>
                                    video.type == "Trailer" &&
                                    video.site == "YouTube",
                                orElse: () => trailerData.results!.first,
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
                              Get.snackbar("Error", "Trailer not available");
                            }
                          },
                          child: Icon(
                            Icons.play_circle_outline,
                            color: whiteColor,
                            size: cHeight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size1),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 6,
                              child: Text(
                                movie?.title ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppThemeHelper.textColor(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Image.asset(
                                splashLogo,
                                height: cHeight,
                                width: cWidth2,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              movie?.releaseDate ?? "",
                              style: TextStyle(
                                color:  AppThemeHelper.textColor(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: size1),
                            Text(formateRuntime(movie?.runtime ?? 0),style: TextStyle(color:  AppThemeHelper.textColor(context)),),
                            SizedBox(width: size1),
                            Text(
                              hd,
                              style: TextStyle(
                                color:  AppThemeHelper.textColor(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size1),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              Get.dialog(
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                barrierDismissible: false,
                              );

                              final trailerData = await controller.fetchTrailer(
                                movie?.id ?? 0,
                              );

                              Get.back();

                              if (trailerData != null &&
                                  trailerData.results != null &&
                                  trailerData.results!.isNotEmpty) {
                                // Find official YouTube trailer
                                final trailer = trailerData.results!.firstWhere(
                                  (video) =>
                                      video.type == "Trailer" &&
                                      video.site == "YouTube",
                                  orElse: () => trailerData.results!.first,
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
                                Get.snackbar("Error", "Trailer not available");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:  AppThemeHelper.textColor(context),
                              foregroundColor:  AppThemeHelper.reverseTextColor(context),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              playText,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: size1),
                        SizedBox(
                          width: double.infinity,
                          height: cHeight,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.download);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: greyColor,
                              foregroundColor: blackColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.download, color: whiteColor),
                                SizedBox(width: size1),
                                const Text(
                                  download,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: whiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: size1),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            genresText,
                            style: TextStyle(color:  AppThemeHelper.primaryColor(context)),
                          ),
                        ),

                        Text(
                          movie?.overview ?? "",
                          style: TextStyle(color:  AppThemeHelper.textColor(context)),
                        ),
                        Divider(thickness: 2),
                        TabBar(
                          controller: controller.tabController,
                          indicatorColor: Colors.red,
                          labelColor:  AppThemeHelper.textColor(context),
                          unselectedLabelColor: Colors.grey,
                          tabs: const [
                            Tab(text: "My List",),
                            Tab(text: "Rate"),
                            Tab(text: "Share"),
                            Tab(text: "More"),
                          ],
                        ),

                        SizedBox(
                          height: 250,
                          child: TabBarView(
                            controller: controller.tabController,
                            children: [
                              _buildMyListTab(movie,context),
                              _buildRateTab(context),
                              _buildShareTab(movie),
                              _buildMoreTab(movie),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Text(somethingWentWrong,style: TextStyle(color:  AppThemeHelper.textColor(context)),);
            }
          },
        ),
      ),
    );
  }

  Widget _buildMyListTab(MovieDetails? movie,context) {
    // final myListController = Get.find<MyListController>();
    final myListController = Get.isRegistered<MyListController>()
        ? Get.find<MyListController>()
        : Get.put(MyListController());

    return Obx(() {
      if (myListController.myMovies.isEmpty) {
        return Center(
          child: Text("No Movies", style: TextStyle(color:  AppThemeHelper.textColor(context))),
        );
      }

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: myListController.myMovies.length,
        itemBuilder: (_, index) {
          final item = myListController.myMovies[index];
          return Padding(
            padding: const EdgeInsets.all(8),
            child: CachedNetworkImage(
              imageUrl: "$imageUrl${item.posterPath}",
              width: 120,
              fit: BoxFit.cover,
            ),
          );
        },
      );
    });
  }

  Widget _buildRateTab(context) {
    final textController = TextEditingController();

    return Column(
      children: [
        SizedBox(height: size2),


           GestureDetector(
            onTap: () {
              showAddReviewDialog(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF11998E).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.rate_review, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Add Review",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),


        SizedBox(height: size2),
        Obx(() {
          return SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.reviews.length,
              separatorBuilder: (_, __) => const SizedBox(width: 18),
              itemBuilder: (_, index) {
                final review = controller.reviews[index];

                return Container(
                  width: 280,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1C),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFF2A2A2A),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        review["email"] ?? "Unknown",
                        style: const TextStyle(
                          color: whiteColor,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: List.generate(
                          5,
                              (starIndex) => Padding(
                            padding: const EdgeInsets.only(right: 3),
                            child: Icon(
                              starIndex < (review["rating"] ?? 0)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: const Color(0xFFBDBDBD),
                              size: 18,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      Expanded(
                        child: Text(
                          review["review"] ?? "",
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color:whiteColor,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),      ],
    );
  }

  void showAddReviewDialog(context) {
    final textController = TextEditingController();
    RxInt selectedRating = 0.obs;

    Get.dialog(
      Dialog(
        backgroundColor:  Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text(
                "Add Review",
                style: TextStyle(
                  color: AppThemeHelper.textColor(context),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 20),

              Obx(
                    () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                        (index) => GestureDetector(
                      onTap: () {
                        selectedRating.value = index + 1;
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          index < selectedRating.value
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.redAccent,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: textController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Write your review...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1F1F1F),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              GestureDetector(
                onTap: () {
                  if (selectedRating.value == 0) {
                    Get.snackbar("Error", "Please select rating");
                    return;
                  }

                  if (textController.text.isEmpty){
                    Get.snackbar("Error","please write review");
                    return;
                  }

                  controller.addReview(
                    textController.text.trim(),
                    selectedRating.value.toDouble(),
                  );

                  Get.back();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF11998E),
                        Color(0xFF38EF7D),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoreTab(MovieDetails? movie) {
    return FutureBuilder(
      future: controller.movieRecommendationsData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              somethingWentWrong,
              style: TextStyle(color: AppThemeHelper.textColor(context)),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox();
        }

        final movie = snapshot.data;

        if (movie?.results == null || movie!.results!.isEmpty) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: size2),
            const Text(moreLikeThis, style: TextStyle(color: whiteColor)),
            const SizedBox(height: size1),
            SizedBox(
              height: cHeight4,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movie.results!.length,
                itemBuilder: (context, index) {
                  final item = movie.results![index];

                  if (item.posterPath == null) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CachedNetworkImage(
                      imageUrl: "$imageUrl${item.posterPath}",
                      height: cHeight4,
                      width: cWidth1,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShareTab(MovieDetails? movie) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Share.share("Check out this movie: ${movie?.title}");
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.share, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Share Movie",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
