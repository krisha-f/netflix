import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:netflix/App/Data/Services/utils.dart';
import 'package:netflix/App/Routes/app_pages.dart';
import 'package:netflix/Constant/app_colors.dart';
import 'package:netflix/Constant/app_size.dart';
import '../../../Constant/app_strings.dart';
import '../../Data/Models/hot_news_model.dart';
import '../../Data/Services/apiservice.dart';
import 'hotnews_controller.dart';

class HotNewsView extends GetView<HotNewsController> {
  HotNewsView({super.key});

  //
  // final ApiService apiService = ApiService();
  //  // late final Future<HotNews?> hotNewsData =  apiService.hotNews();
  //
  //  late Future<HotNews?> hotNewsData =  apiService.hotNews();

  // void initState(){
  //   hotNewsData = apiService.hotNews();
  // }

  @override
  Widget build(BuildContext context) {
    String getShortName(String name) {
      return name.length > 3 ? name.substring(0, 3) : name;
    }

    String formateDate(String apiDate) {
      DateTime parsedDate = DateTime.parse(apiDate);
      return DateFormat('MMMM').format(parsedDate);
    }

    return Scaffold(
      // backgroundColor: blackColor,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
            title: Center(child: Text("Hot News")),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: whiteColor,
      ),
      body: FutureBuilder(
        future: controller.hotNewsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            // final movies = snapshot.data!.results;
            final movies = snapshot.data?.results ?? [];
            if (movies.isEmpty) {
              return Center(child: Text(noDataFound));
            }
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final hotNewsData = movies[index];
                String firstAirDate =
                    hotNewsData.firstAirDate?.toString() ?? "";
                String releaseDate = hotNewsData.releaseDate?.toString() ?? "";

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      // Get.offAllNamed(
                      //   AppRoutes.movieDetails,
                      //   arguments: moviesDatas.id,
                      // );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Text(
                                hotNewsData.releaseDate == null
                                    ? firstAirDate
                                    : releaseDate,
                              ),
                              Text(
                                hotNewsData.releaseDate == null
                                    ? getShortName(
                                        formateDate(
                                          hotNewsData.firstAirDate
                                                  ?.toString() ??
                                              "",
                                        ),
                                      )
                                    : getShortName(
                                        formateDate(
                                          hotNewsData.releaseDate?.toString() ??
                                              "",
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: cHeight3,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                      "$imageUrl${hotNewsData.backdropPath}",
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: size1),
                              Row(
                                children: [
                                  Text(comingOn),
                                  SizedBox(width: size1,),

                                  Text(
                                    hotNewsData.releaseDate == null
                                        ? firstAirDate
                                        : releaseDate,
                                  ),
                                  SizedBox(width: size1),
                                  Text(
                                    hotNewsData.releaseDate == null
                                        ? getShortName(
                                            formateDate(
                                              hotNewsData.firstAirDate
                                                      ?.toString() ??
                                                  "",
                                            ),
                                          )
                                        : getShortName(
                                            formateDate(
                                              hotNewsData.releaseDate
                                                      ?.toString() ??
                                                  "",
                                            ),
                                          ),
                                  ),
                                  Spacer(),
                                  Icon(Icons.notifications, color: whiteColor),
                                  SizedBox(width: size2,),
                                  GestureDetector(
                                      onTap: (){
                                        Get.toNamed(AppRoutes.movieDetails,arguments: hotNewsData.id);

                                      },
                                      child: Icon(Icons.info_outline, color: whiteColor)),
                                ],
                              ),
                              SizedBox(height: size2,),

                              Text(
                                hotNewsData.overview ?? "",
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: whiteColor),
                              ),
                              SizedBox(height: size1,),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text(problemToFetchData));
          }
        },
      ),
    );
  }
}
