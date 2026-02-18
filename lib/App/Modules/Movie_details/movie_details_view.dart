import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netflix/App/Data/Services/utils.dart';
import 'package:netflix/Constant/app_size.dart';
import '../../../Constant/app_colors.dart';
import '../../../Constant/app_images.dart';
import '../../../Constant/app_strings.dart';
import '../../Data/Models/movie_details_model.dart';
import '../MyList/mylist_controller.dart';
import 'movie_details_controller.dart';
import 'package:share_plus/share_plus.dart';


class MovieDetailsView extends GetView<MovieDetailsController> {
  const MovieDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String formateRuntime(int runtime){
        int hours = runtime   ~/ 60;
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              print("ERROR: ${snapshot.error}");
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text(noDataFound),
              );
            }
            if (snapshot.hasData) {
              final movie = snapshot.data;
              String genresText = movie?.genres
                  ?.map((genre) => genre.name)
                  .join(", ")
                  ?? "";
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
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
                                onTap: (){
                                    Get.back();
                                },
                                  child: CircleAvatar(
                                    backgroundColor: blackColor,
                                    child: Icon(Icons.close,color: whiteColor,),
                                  ),
                                ),
                              SizedBox(width: size1,),
                              CircleAvatar(
                                backgroundColor: blackColor,
                                child: Icon(Icons.cast,color: whiteColor,),
                              )
                            ],
                          ),
                        ),
                      Positioned(
                          top: 100,
                          bottom: 100,
                          right: 100,
                          left: 100,
                          child: Icon(Icons.play_circle_outline,color: whiteColor,size: cHeight,)),
                      ],
                    ),
                    SizedBox(height: size1,),
                    Column(
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
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(flex:2,child: Image.asset(splashLogo,height: cHeight,width: cWidth2,))
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              movie?.releaseDate ?? "",
                              style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: size1,),
                            Text(formateRuntime(movie?.runtime ?? 0)),
                            SizedBox(width: size1,),
                            Text(hd,   style: TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.bold,
                            ),)
                          ],
                        ),
                        SizedBox(height: size1,),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: whiteColor,
                              foregroundColor: blackColor,
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
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ) ,
                        SizedBox(height: size1,),
                        SizedBox(
                          width: double.infinity,
                          height: cHeight,
                          child: ElevatedButton(
                            onPressed: () {
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
                                Icon(Icons.download,color: whiteColor,),
                                SizedBox(width: size1,),
                                const Text(
                                  download,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: whiteColor
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ) ,
                        SizedBox(height: size1,),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Text(genresText,style: TextStyle(color: greyColor),),
                            )),

                        Text(movie?.overview ?? "",style: TextStyle(color: whiteColor),),
                        Divider(thickness: 2,),

                        // Align(
                        //     alignment: Alignment.topLeft,
                        //     child: Text("Title : ${movie?.title ?? ""}",style: TextStyle(color: whiteColor))),
                        // Align(
                        //     alignment: Alignment.topLeft,
                        //     child: Text("Status : ${movie?.status ?? ""}",style: TextStyle(color: whiteColor),)),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     Column(
                        //       children: [
                        //         Icon(Icons.add,color: whiteColor,),
                        //         SizedBox(height: size1),
                        //         Text(myList,style: TextStyle(color: whiteColor,),)
                        //       ],
                        //     ),
                        //     SizedBox(width: size1,),
                        //     Column(
                        //       children: [
                        //         Icon(Icons.thumb_up,color: whiteColor,),
                        //         SizedBox(height: size1),
                        //
                        //         Text(rate,style: TextStyle(color: whiteColor,),)
                        //       ],
                        //     ),
                        //     SizedBox(width: size1,),
                        //     Column(
                        //       children: [
                        //         Icon(Icons.share,color: whiteColor,),
                        //         SizedBox(height: size1),
                        //         Text(share,style: TextStyle(color: whiteColor,),)
                        //       ],
                        //     )
                        //   ],
                        // ),
                        // SizedBox(height: size1,),
                        // FutureBuilder(
                        //   future: controller.movieRecommendationsData,
                        //   builder: (context, snapshot) {
                        //
                        //
                        //     if (snapshot.connectionState == ConnectionState.waiting) {
                        //       return const Center(
                        //         child: CircularProgressIndicator(),
                        //       );
                        //     }
                        //
                        //     if (snapshot.hasError) {
                        //       return const Center(
                        //         child: Text(
                        //           somethingWentWrong,
                        //           style: TextStyle(color: whiteColor),
                        //         ),
                        //       );
                        //     }
                        //
                        //     if (!snapshot.hasData || snapshot.data == null) {
                        //       return const SizedBox();
                        //     }
                        //
                        //     final movie = snapshot.data;
                        //
                        //     if (movie?.results == null || movie!.results!.isEmpty) {
                        //       return const SizedBox();
                        //     }
                        //
                        //     return Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         const Text(
                        //           moreLikeThis,
                        //           style: TextStyle(color: whiteColor),
                        //         ),
                        //         const SizedBox(height: size1),
                        //         SizedBox(
                        //           height: cHeight4,
                        //           child: ListView.builder(
                        //             scrollDirection: Axis.horizontal,
                        //             itemCount: movie.results!.length,
                        //             itemBuilder: (context, index) {
                        //               final item = movie.results![index];
                        //
                        //               if (item.posterPath == null) {
                        //                 return const SizedBox();
                        //               }
                        //
                        //               return Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: CachedNetworkImage(
                        //                   imageUrl: "$imageUrl${item.posterPath}",
                        //                   height: cHeight4,
                        //                   width: cWidth1,
                        //                   fit: BoxFit.cover,
                        //                 ),
                        //               );
                        //             },
                        //           ),
                        //         ),
                        //       ],
                        //     );
                        //   },
                        // )

                        TabBar(
                          controller: controller.tabController,
                          indicatorColor: Colors.red,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey,
                          tabs: const [
                            Tab(text: "My List"),
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
                              _buildMyListTab(movie),
                              _buildRateTab(),
                              _buildShareTab(movie),
                              _buildMoreTab(movie),
                            ],
                          ),
                        ),

                      ],
                    )
                  ],
                ),
              );
            } else {
              return Text(somethingWentWrong);
            }
          },
        ),
      ),
    );
  }

  Widget _buildMyListTab(MovieDetails? movie) {
    final myListController = Get.find<MyListController>();

    return Obx(() {
      if (myListController.myMovies.isEmpty) {
        return Center(child: Text("No Movies", style: TextStyle(color: Colors.white)));
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

  Widget _buildRateTab() {
    final textController = TextEditingController();

    return Column(
      children: [

        ElevatedButton(
          onPressed: () {
            Get.defaultDialog(
              title: "Add Review",
              content: Column(
                children: [
                  TextField(controller: textController),
                  ElevatedButton(
                    onPressed: () {
                      controller.addReview(
                          textController.text, 4.0);
                      Get.back();
                    },
                    child: Text("Submit"),
                  )
                ],
              ),
            );
          },
          child: Text("Add Review"),
        ),

        Expanded(
          child: Obx(() {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.reviews.length,
              itemBuilder: (_, index) {
                final review = controller.reviews[index];
                return Container(
                  width: 200,
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(8),
                  color: Colors.grey[900],
                  child: Column(
                    children: [
                      Text(
                        "⭐ ${review["rating"]}",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        review["review"],
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMoreTab(MovieDetails? movie) {
    return FutureBuilder(
      future: controller.movieRecommendationsData,
      builder: (context, snapshot) {


        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              somethingWentWrong,
              style: TextStyle(color: whiteColor),
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
            const SizedBox(height: size2,),
            const Text(
              moreLikeThis,
              style: TextStyle(color: whiteColor),
            ),
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
      child: ElevatedButton.icon(
        onPressed: () {
          Share.share(
              "Check out this movie: ${movie?.title}");
        },
        icon: Icon(Icons.share),
        label: Text("Share Movie"),
      ),
    );
  }


}
