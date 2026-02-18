// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_state_manager/src/simple/get_view.dart';
// import 'package:intl/intl.dart';
// import 'package:netflix/App/Data/Services/utils.dart';
// import 'package:netflix/Constant/app_colors.dart';
// import 'package:netflix/Constant/app_size.dart';
// import '../../../Constant/app_strings.dart';
// import '../../Data/Models/hot_news_model.dart';
// import '../../Data/Services/apiservice.dart';
// import 'hotnews_controller.dart';

// class HotNewsView extends GetView<HotNewsController> {
//    HotNewsView({super.key});

//   final ApiService apiService = ApiService();
//    // late final Future<HotNews?> hotNewsData =  apiService.hotNews();

//    late Future<HotNews?> hotNewsData =  apiService.hotNews();

//    // void initState(){
//   //   hotNewsData = apiService.hotNews();
//   // }

//   @override
//   Widget build(BuildContext context) {

//     String getShortName(String name){
//       return name.length>3? name.substring(0,3):name;
//     }

//     String formateDate(String apiDate){
//       DateTime parsedDate = DateTime.parse(apiDate);
//       return DateFormat('MMMM').format(parsedDate);
//     }

//     return Scaffold(
//       // backgroundColor: blackColor,
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: AppBar( backgroundColor: Theme.of(context).scaffoldBackgroundColor, foregroundColor: whiteColor),
//       body: FutureBuilder(
//         future: hotNewsData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (snapshot.hasData) {
//             // final movies = snapshot.data!.results;
//             final movies = snapshot.data?.results ?? [];
//             if (movies.isEmpty) {
//               return Center(child: Text(noDataFound));
//             }
//             return ListView.builder(
//               shrinkWrap: true,
//               scrollDirection: Axis.vertical,
//               itemCount: movies.length,
//               itemBuilder: (context, index) {
//                 final hotNewsData = movies[index];
//                 String firstAirDate =
//                     hotNewsData.firstAirDate?.toString() ?? "";
//                 String releaseDate =
//                     hotNewsData.releaseDate?.toString() ?? "";

//                 return Padding(
//                   padding: const EdgeInsets.only(right: 8.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       // Get.offAllNamed(
//                       //   AppRoutes.movieDetails,
//                       //   arguments: moviesDatas.id,
//                       // );
//                     },
//                     child: Row(
//                       children: [
//                         Expanded(
//                           flex: 3,
//                           child: Column(
//                             children: [
//                               Text(
//                                 hotNewsData.releaseDate == null
//                                     ? firstAirDate
//                                     : releaseDate,
//                               ),
//                               Text( hotNewsData.releaseDate == null? getShortName(formateDate(hotNewsData.firstAirDate?.toString() ?? ""),): getShortName(formateDate(hotNewsData.releaseDate?.toString() ?? ""),)
//                               )
//                             ],
//                           ),
//                         ),
//                         Expanded(flex: 7, child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               height: cHeight3,
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                     fit: BoxFit.cover,
//                                     image: CachedNetworkImageProvider("$imageUrl${hotNewsData.backdropPath}"))
//                               ),
//                             ),
//                             SizedBox(height: size1,),
//                             Row(
//                               children: [
//                                 Text(comingOn),
//                                 Text(
//                                   hotNewsData.releaseDate == null
//                                       ? firstAirDate
//                                       : releaseDate,
//                                 ),
//                                 SizedBox(width: size1,),
//                                 Text( hotNewsData.releaseDate == null? getShortName(formateDate(hotNewsData.firstAirDate?.toString() ?? ""),): getShortName(formateDate(hotNewsData.releaseDate?.toString() ?? ""),)
//                                 ),
//                                 Spacer(),
//                                 Icon(Icons.notifications,color: whiteColor,),
//                                 Icon(Icons.info_outline,color: whiteColor,)
//                               ],
//                             ),
//                             Text(hotNewsData.overview ?? "",maxLines: 4,overflow: TextOverflow.ellipsis,style: TextStyle(color: whiteColor),),
//                           ],

//                         )),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else {
//             return Center(child: Text(problemToFetchData));
//           }
//         },
//       ),
//     );
//   }
// }

// lib/app/modules/HotNews/hotnews_view.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:netflix/App/Data/Services/utils.dart';
import 'package:netflix/App/Modules/HotNews/hotnews_controller.dart';
import 'package:netflix/App/Routes/app_pages.dart';
import 'package:netflix/Constant/app_colors.dart';
import 'package:netflix/Constant/app_size.dart';
import 'package:netflix/Constant/app_strings.dart';

class HotNewsView extends GetView<HotNewsController> {
  const HotNewsView({super.key});

  // Format date to show only day
  String getDay(String dateString) {
    try {
      if (dateString.isEmpty) return '';
      final date = DateTime.parse(dateString);
      return DateFormat('dd').format(date);
    } catch (e) {
      return '';
    }
  }

  // Format date to show month (first 3 letters)
  String getMonth(String dateString) {
    try {
      if (dateString.isEmpty) return '';
      final date = DateTime.parse(dateString);
      return DateFormat('MMM').format(date).substring(0, 3);
    } catch (e) {
      return '';
    }
  }

  // Format date for coming on text
  String formatComingOnDate(String dateString) {
    try {
      if (dateString.isEmpty) return '';
      final date = DateTime.parse(dateString);
      return DateFormat('MMMM d, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          hotNewsText,
          style: const TextStyle(
            color: whiteColor,
            fontSize: size4,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        // Show loading state
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: redColor),
          );
        }

        // Show error state
        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: size5 * 2, color: greyColor),
                const SizedBox(height: size2),
                Text(
                  controller.errorMessage.value ?? somethingWentWrong,
                  style: const TextStyle(color: whiteColor, fontSize: size6),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: size3),
                ElevatedButton(
                  onPressed: controller.refreshHotNews,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: redColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: size3,
                      vertical: size2,
                    ),
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(color: whiteColor, fontSize: size6),
                  ),
                ),
              ],
            ),
          );
        }

        // Show empty state
        if (controller.hotNewsList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.new_releases_outlined,
                  size: size5 * 2,
                  color: greyColor,
                ),
                const SizedBox(height: size2),
                const Text(
                  noDataFound,
                  style: TextStyle(color: whiteColor, fontSize: size6),
                ),
                const SizedBox(height: size3),
                ElevatedButton(
                  onPressed: controller.refreshHotNews,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: redColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: size3,
                      vertical: size2,
                    ),
                  ),
                  child: const Text(
                    'Refresh',
                    style: TextStyle(color: whiteColor, fontSize: size6),
                  ),
                ),
              ],
            ),
          );
        }

        // Show hot news list
        return RefreshIndicator(
          onRefresh: controller.refreshHotNews,
          color: redColor,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: ListView.builder(
            padding: const EdgeInsets.all(pad1),
            itemCount: controller.hotNewsList.length,
            itemBuilder: (context, index) {
              final item = controller.hotNewsList[index];
              final displayDate = controller.getDisplayDate(item);
              final title = controller.getTitle(item);
              final imagePath = controller.getImagePath(item);
              final day = getDay(displayDate);
              const month = ''; // You can add month if needed

              return GestureDetector(
                onTap: () {
                  if (item.id != null) {
                    Get.toNamed(AppRoutes.movieDetails, arguments: item.id);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: size3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Column
                      SizedBox(
                        width: 60,
                        child: Column(
                          children: [
                            Text(
                              day,
                              style: const TextStyle(
                                color: whiteColor,
                                fontSize: size4,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: size1),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: size1,
                                vertical: size1 / 2,
                              ),
                              decoration: BoxDecoration(
                                color: redColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                getMonth(displayDate),
                                style: const TextStyle(
                                  color: whiteColor,
                                  fontSize: size2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: size2),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image
                            if (imagePath.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: "$imageUrl$imagePath",
                                  height: cHeight3,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    height: cHeight3,
                                    color: greyColor.withOpacity(0.3),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: redColor,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        height: cHeight3,
                                        color: greyColor.withOpacity(0.3),
                                        child: const Icon(
                                          Icons.broken_image,
                                          color: greyColor,
                                          size: size5,
                                        ),
                                      ),
                                ),
                              )
                            else
                              Container(
                                height: cHeight3,
                                color: greyColor.withOpacity(0.3),
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: greyColor,
                                    size: size5,
                                  ),
                                ),
                              ),

                            const SizedBox(height: size2),

                            // Coming On and Actions Row
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: size1,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: redColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    comingOn,
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: size2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: size1),
                                Expanded(
                                  child: Text(
                                    formatComingOnDate(displayDate),
                                    style: const TextStyle(
                                      color: whiteColor,
                                      fontSize: size6,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Add notification functionality
                                    Get.snackbar(
                                      'Reminder',
                                      'You will be notified when this releases',
                                      backgroundColor: redColor,
                                      colorText: whiteColor,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.notifications_none,
                                    color: whiteColor,
                                    size: size7,
                                  ),
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                ),
                                const SizedBox(width: size1),
                                IconButton(
                                  onPressed: () {
                                    // Show info/details
                                    Get.defaultDialog(
                                      title: title,
                                      titleStyle: const TextStyle(
                                        color: whiteColor,
                                        fontSize: size4,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      backgroundColor: Theme.of(
                                        context,
                                      ).scaffoldBackgroundColor,
                                      titlePadding: const EdgeInsets.all(size3),
                                      content: Padding(
                                        padding: const EdgeInsets.all(size2),
                                        child: Text(
                                          item.overview ??
                                              'No description available',
                                          style: const TextStyle(
                                            color: whiteColor,
                                            fontSize: size6,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      confirm: ElevatedButton(
                                        onPressed: () => Get.back(),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: redColor,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: size3,
                                            vertical: size2,
                                          ),
                                        ),
                                        child: const Text(
                                          'Close',
                                          style: TextStyle(
                                            color: whiteColor,
                                            fontSize: size6,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.info_outline,
                                    color: whiteColor,
                                    size: size7,
                                  ),
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),

                            const SizedBox(height: size1),

                            // Title
                            Text(
                              title,
                              style: const TextStyle(
                                color: whiteColor,
                                fontSize: size4,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: size1),

                            // Overview
                            if (item.overview != null &&
                                item.overview!.isNotEmpty)
                              Text(
                                item.overview!,
                                style: const TextStyle(
                                  color: greyColor,
                                  fontSize: size6,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),

                            const SizedBox(height: size2),

                            // Media Type Indicator
                            if (item.mediaType != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: size1,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  item.mediaType!.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: size2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                            const Divider(
                              color: greyColor,
                              thickness: 1,
                              height: size3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
