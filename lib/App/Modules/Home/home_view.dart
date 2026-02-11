import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:netflix/App/Data/Models/movie_model.dart';
import 'package:netflix/Constant/app_colors.dart';
import '../../../Constant/app_images.dart';
import '../../../Constant/app_size.dart';
import '../../../Constant/app_strings.dart';
import '../../Data/Services/utils.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: Column(
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
                  onPressed: () {},
                  icon: Icon(Icons.search, color: whiteColor),
                ),
                Icon(Icons.download_sharp, color: whiteColor),
                SizedBox(width: size1,),
                Icon(Icons.cast, color: whiteColor),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: pad1),
            child: Row(
              children: [
                MaterialButton(
                  onPressed: () {},
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
                SizedBox(width: size1,),
                MaterialButton(
                  onPressed: () {},
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
                SizedBox(width: size1,),

                MaterialButton(
                  onPressed: () {},
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
                      Icon(Icons.keyboard_arrow_down,color: whiteColor,)
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsetsDirectional.symmetric(horizontal: pad1),
            child: Stack(children: [Container(
              height: 600,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: greyColor)
              ),
              child: FutureBuilder(future: controller.moviesData, builder:(context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }
                else if(snapshot.hasError){
                  return Center(child: Text("Error: ${snapshot.error}"),);
                }
                else if ( snapshot.hasData){
                  final movies = snapshot.data!.results;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: PageView.builder(
                        itemCount:movies?.length,
                        itemBuilder: (context,index)
                        {
                          final moviesData = movies?[index];
                          return GestureDetector(
                        onTap: (){},
                        child: Container(
                          height : 600,
                              width : 600,
                          decoration: BoxDecoration(
                            borderRadius:  BorderRadius.circular(20),
                            color: whiteColor,
                            image: DecorationImage(image: CachedNetworkImageProvider("$imageUrl${moviesData?.posterPath}"))
                          ),
                        ),
                      );
                    }),
                  );
                }
                else{
                  return Center(child: Text("Problem To Fetch Data"));
                }

              }),

            )],),
          )
        ],
      ),
    );
  }
}
