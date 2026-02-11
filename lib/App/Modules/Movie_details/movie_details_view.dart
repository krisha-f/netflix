import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:netflix/App/Data/Services/utils.dart';
import 'package:netflix/Constant/app_size.dart';
import '../../../Constant/app_colors.dart';
import '../../../Constant/app_images.dart';
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
      backgroundColor: blackColor,
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
                child: Text("No Data Found"),
              );
            }
            if (snapshot.hasData) {
              final movie = snapshot.data;
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
                            GestureDetector(
                              onTap: (){
                                  // Get.off(context).pop();
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
                        child: Icon(Icons.play_circle_outline,color: whiteColor,size: 50,)),
                    ],
                  ),
                  SizedBox(height: size1,),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            movie?.title ?? "",
                            style: TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Image.asset(splashLogo,height: 50,width: 100,)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            movie?.releaseDate ?? "",
                            style: TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(formateRuntime(movie?.runtime ?? 0)),
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
                            "Play",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ) ,
                      SizedBox(height: size1,),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
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
                                "Download",
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
                      Text(movie?.overview ?? "",style: TextStyle(color: whiteColor),),
                      Divider(thickness: 2,),

                      Align(
                          alignment: Alignment.topLeft,
                          child: Text("Title : ${movie?.title ?? ""}",style: TextStyle(color: whiteColor))),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text("Status : ${movie?.status ?? ""}",style: TextStyle(color: whiteColor),)),
                      Row(
                        children: [
                          Column(
                            children: [
                              Icon(Icons.add,color: whiteColor,),
                              SizedBox(height: size1),
                              Text("Add",style: TextStyle(color: whiteColor,),)
                            ],
                          ),
                          SizedBox(width: size1,),
                          Column(
                            children: [
                              Icon(Icons.add,color: whiteColor,),
                              SizedBox(height: size1),

                              Text("Add",style: TextStyle(color: whiteColor,),)
                            ],
                          ),
                          SizedBox(width: size1,),
                          Column(
                            children: [
                              Icon(Icons.add,color: whiteColor,),
                              SizedBox(height: size1),
                              Text("Add",style: TextStyle(color: whiteColor,),)
                            ],
                          )
                        ],
                      )


                    ],
                  )
                ],
              );
            } else {
              return Text("something went wrong");
            }
          },
        ),
      ),
    );
  }
}
