import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netflix/App/Data/Services/utils.dart';
import 'package:netflix/Constant/app_size.dart';
import '../../../Constant/app_colors.dart';
import '../../../Constant/app_images.dart';
import '../../../Constant/app_strings.dart';
import 'movie_details_controller.dart';

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.add,color: whiteColor,),
                              SizedBox(height: size1),
                              Text(myList,style: TextStyle(color: whiteColor,),)
                            ],
                          ),
                          SizedBox(width: size1,),
                          Column(
                            children: [
                              Icon(Icons.thumb_up,color: whiteColor,),
                              SizedBox(height: size1),

                              Text(rate,style: TextStyle(color: whiteColor,),)
                            ],
                          ),
                          SizedBox(width: size1,),
                          Column(
                            children: [
                              Icon(Icons.share,color: whiteColor,),
                              SizedBox(height: size1),
                              Text(share,style: TextStyle(color: whiteColor,),)
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: size1,),
                      // FutureBuilder(future: controller.movieRecommendationsData, builder: (context,snapshot){
                      //   if(snapshot.hasData){
                      //     final movie = snapshot.data;
                      //     return (movie?.results?.isEmpty ?? true)? SizedBox(): Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text("More Like this",style:  TextStyle(color: whiteColor),),
                      //         SizedBox(height: size1,),
                      //         SizedBox(
                      //           height: 200,
                      //           child: ListView.builder(
                      //             scrollDirection: Axis.horizontal,
                      //               shrinkWrap :true,
                      //               padding : EdgeInsets.zero,
                      //               itemCount : movie?.results?.length ,
                      //               itemBuilder: (context,index){
                      //             return Padding(
                      //               padding: const EdgeInsets.all(8.0),
                      //               child: CachedNetworkImage(imageUrl: "$imageUrl${movie?.results?[index].posterPath}",height: 200,width: 200,fit: BoxFit.cover,),
                      //             );
                      //
                      //           }),
                      //         )
                      //       ],
                      //     );
                      //   }
                      //   return Text("something went wrong");
                      // })
                      FutureBuilder(
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
                      )

                    ],
                  )
                ],
              );
            } else {
              return Text(somethingWentWrong);
            }
          },
        ),
      ),
    );
  }
}
