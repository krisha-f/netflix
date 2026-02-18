// // import 'dart:async';
// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get_core/src/get_main.dart';
// // import 'package:get/get_navigation/src/extension_navigation.dart';
// // import 'package:get/get_rx/src/rx_types/rx_types.dart';
// // import 'package:get/get_state_manager/src/simple/get_view.dart';
// // import 'package:netflix/App/Data/Services/utils.dart';
// // import 'package:netflix/Constant/app_colors.dart';
// // import 'package:netflix/Constant/app_size.dart';
// // import '../../../Constant/app_strings.dart';
// // import '../../Data/Models/search_movie_model.dart';
// // import '../../Data/Models/trending_movie_model.dart';
// // import '../../Data/Services/apiservice.dart';
// // import '../../Routes/app_pages.dart';

// // class SearchView extends GetView<SearchController> {
// //   SearchView({super.key});

// //   final ApiService apiService = ApiService();
// //   // TextEditingController sController = TextEditingController();
// //   SearchMovies? searchMovie;
// //   final TextEditingController sController = TextEditingController();
// //   var isLoading = false.obs;
// //   Timer? _debounce;
// //   String _lastQuery = "";
// //   bool _isSearching = false;
// //   late Future<TrendingMovies?> treadingMoviesData = apiService.trendingMovies();

// //   // void search(String query) {
// //   //   apiService.searchMovies(query).then((result) {
// //   //     searchMovie = result;
// //   //   });
// //   // }

// //   Future<void> search(String query) async {
// //     // if (query.isEmpty) return;
// //     //
// //     // try {
// //     //   isLoading.value = true;
// //     //   searchMovie = await apiService.searchMovies(query);
// //     // } catch (e) {
// //     //   print(e);
// //     // } finally {
// //     //   isLoading.value = false;
// //     // }
// //     if (_isSearching) return; // prevent overlapping calls

// //     try {
// //       _isSearching = true;
// //       searchMovie = await apiService.searchMovies(query);
// //     } catch (e) {
// //       print("Search Error: $e");
// //     } finally {
// //       _isSearching = false;
// //     }
// //   }

// //   void initState(){
// //     // super.initState();
// //     // debounce(
// //     //   sController.text.obs,
// //     //       (_) => search(sController.text),
// //     //   time: Duration(milliseconds: 500),
// //     // );
// //     // treadingMoviesData = apiService.trendingMovies();

// //     sController.addListener(() {
// //       if (_debounce?.isActive ?? false) _debounce!.cancel();

// //       _debounce = Timer(const Duration(milliseconds: 600), () {
// //         final query = sController.text.trim();

// //         if (query.isNotEmpty && query != _lastQuery) {
// //           _lastQuery = query;
// //           // search(query);
// //           if (query.length >= 3) {
// //             search(query);
// //           }
// //         }
// //       });
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     sController.dispose();
// //     _debounce?.cancel();
// //     // super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
// //       appBar: AppBar( backgroundColor: Theme.of(context).scaffoldBackgroundColor, foregroundColor: whiteColor),
// //       body: SingleChildScrollView(
// //         child: Column(
// //           children: [
// //             CupertinoSearchTextField(
// //               controller: sController,
// //               padding: EdgeInsets.all(10),
// //               prefixIcon: Icon(Icons.search, color: whiteColor),
// //               suffixIcon: Icon(Icons.cancel, color: whiteColor),
// //               style: TextStyle(color: whiteColor),
// //               backgroundColor: greyColor,
// //               onChanged: (value) {
// //                 if (value.isEmpty) {
// //                 } else {
// //                   search(sController.text);
// //                 }
// //               },
// //             ),
// //             SizedBox(height: size1,),
// //             sController.text.isEmpty
// //                 ?
// //             // SizedBox()
// //             FutureBuilder(
// //               future: treadingMoviesData,
// //               builder: (context, snapshot) {

// //                 if (snapshot.connectionState == ConnectionState.waiting) {
// //                   return const Center(
// //                     child: CircularProgressIndicator(),
// //                   );
// //                 }

// //                 if (snapshot.hasError) {
// //                   return const Center(
// //                     child: Text(
// //                       somethingWentWrong,
// //                       style: TextStyle(color: whiteColor),
// //                     ),
// //                   );
// //                 }

// //                 if (!snapshot.hasData || snapshot.data == null) {
// //                   return const SizedBox();
// //                 }

// //                 final movie = snapshot.data;

// //                 // if (movie?.results == null || movie!.results!.isEmpty) {
// //                 //   return const SizedBox();
// //                 // }

// //                 return Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const Text(
// //                       topSearch,
// //                       style: TextStyle(color: whiteColor),
// //                     ),
// //                     const SizedBox(height: size1),
// //                     SizedBox(
// //                       height: cHeight4,
// //                       child: ListView.builder(
// //                         physics: NeverScrollableScrollPhysics(),
// //                         scrollDirection: Axis.vertical,
// //                         itemCount: movie?.results?.length?? 0,
// //                         itemBuilder: (context, index) {
// //                           final topMovies = movie?.results?[index];
// //                        return
// //                          Stack(
// //                            children: [
// //                              Padding(
// //                                padding: const EdgeInsets.all(8.0),
// //                                child: InkWell(
// //                                    onTap:(){
// //                                      Get.offAllNamed(
// //                                        AppRoutes.movieDetails,
// //                                        arguments: topMovies?.id,
// //                                      );
// //                                    },
// //                                    child: Container(
// //                                      height: cHeight5,
// //                                      decoration: BoxDecoration(
// //                                          borderRadius : BorderRadius.circular(20)
// //                                      ),
// //                                      child: Row(
// //                                        children: [
// //                                          CachedNetworkImage(imageUrl:"$imageUrl${topMovies?.backdropPath}",fit: BoxFit.contain,),
// //                                          SizedBox(width: size1,),
// //                                          Flexible(child: Text(topMovies?.title ?? "",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: whiteColor,fontWeight: FontWeight.bold),))
// //                                        ],
// //                                      ),
// //                                    )),
// //                              ),
// //                              Positioned(
// //                                  right:320,
// //                                  top:30,
// //                                  child: Icon(Icons.play_circle_outline,color: whiteColor,size: 27,))
// //                            ],
// //                          );
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 );
// //               },
// //             )

// //                 : searchMovie == null
// //                 ? SizedBox.shrink()
// //                 : ListView.builder(
// //                shrinkWrap: true,
// //                 padding: EdgeInsets.zero,
// //                 itemCount: searchMovie?.results?.length,
// //                   physics: NeverScrollableScrollPhysics(),
// //                 itemBuilder: (context, index) {
// //                  final search = searchMovie?.results?[index];
// //                   return search?.backdropPath == null? SizedBox():
// //                   Stack(
// //                     children: [
// //                       Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: InkWell(
// //                             onTap:(){
// //                               Get.offAllNamed(
// //                                 AppRoutes.movieDetails,
// //                                 arguments: search?.id,
// //                               );
// //                             },
// //                             child: Container(
// //                               height: cHeight5,
// //                               decoration: BoxDecoration(
// //                                           borderRadius : BorderRadius.circular(20)
// //                                           ),
// //                               child: Row(
// //                                 children: [
// //                                   CachedNetworkImage(imageUrl:"$imageUrl${search?.backdropPath}",fit: BoxFit.contain,),
// //                                   SizedBox(width: size1,),
// //                                   Flexible(child: Text(search?.title ?? "",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: whiteColor,fontWeight: FontWeight.bold),))
// //                                 ],
// //                               ),
// //                             )),
// //                       ),
// //                       Positioned(
// //                           right:320,
// //                           top:30,
// //                           child: Icon(Icons.play_circle_outline,color: whiteColor,size: 27,))
// //                     ],
// //                   );
// //             }),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:async';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:netflix/App/Data/Services/utils.dart';
// import 'package:netflix/Constant/app_colors.dart';
// import 'package:netflix/Constant/app_size.dart';
// import '../../../Constant/app_strings.dart';
// import '../../Data/Models/search_movie_model.dart';
// import '../../Data/Models/trending_movie_model.dart';
// import '../../Data/Services/apiservice.dart';
// import '../../Routes/app_pages.dart';
// import 'search_controller.dart';

// class SearchView extends GetView<CustomSearchController> {
//   const SearchView({super.key});

//   // Don't create new instances here - use controller.searchController etc.

//   @override
//   Widget build(BuildContext context) {
//     // Use controller for all data and methods
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         foregroundColor: whiteColor,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Use controller.searchController for the text field
//             CupertinoSearchTextField(
//               controller: controller.searchController, // Use controller's controller
//               padding: EdgeInsets.all(10),
//               prefixIcon: Icon(Icons.search, color: whiteColor),
//               suffixIcon: Icon(Icons.cancel, color: whiteColor),
//               style: TextStyle(color: whiteColor),
//               backgroundColor: greyColor,
//               onChanged: (value) {
//                 if (value.isEmpty) {
//                   // Handle empty search
//                 }
//               },
//             ),
//             SizedBox(height: size1),

//             // Use Obx to reactively update UI
//             Obx(() {
//               if (controller.searchController.text.isEmpty) {
//                 return _buildTrendingSection();
//               } else if (controller.isLoading.value) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (controller.searchResults.value?.results == null ||
//                   controller.searchResults.value!.results!.isEmpty) {
//                 return Center(
//                   child: Text(
//                     'No results found',
//                     style: TextStyle(color: whiteColor),
//                   ),
//                 );
//               } else {
//                 return _buildSearchResults();
//               }
//             }),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTrendingSection() {
//     return FutureBuilder(
//       future: controller.trendingMoviesData, // Use controller's future
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(
//             child: Text(
//               somethingWentWrong,
//               style: TextStyle(color: whiteColor),
//             ),
//           );
//         }
//         if (!snapshot.hasData || snapshot.data == null) {
//           return const SizedBox();
//         }

//         final movie = snapshot.data;
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               topSearch,
//               style: TextStyle(color: whiteColor),
//             ),
//             const SizedBox(height: size1),
//             SizedBox(
//               height: cHeight4,
//               child: ListView.builder(
//                 physics: NeverScrollableScrollPhysics(),
//                 scrollDirection: Axis.vertical,
//                 itemCount: movie?.results?.length ?? 0,
//                 itemBuilder: (context, index) {
//                   final topMovies = movie?.results?[index];
//                   return Stack(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: InkWell(
//                           onTap: () {
//                             Get.offAllNamed(
//                               AppRoutes.movieDetails,
//                               arguments: topMovies?.id,
//                             );
//                           },
//                           child: Container(
//                             height: cHeight5,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Row(
//                               children: [
//                                 CachedNetworkImage(
//                                   imageUrl: "$imageUrl${topMovies?.backdropPath}",
//                                   fit: BoxFit.contain,
//                                 ),
//                                 SizedBox(width: size1),
//                                 Flexible(
//                                   child: Text(
//                                     topMovies?.title ?? "",
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                       color: whiteColor,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         right: 320,
//                         top: 30,
//                         child: Icon(
//                           Icons.play_circle_outline,
//                           color: whiteColor,
//                           size: 27,
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildSearchResults() {
//     return ListView.builder(
//       shrinkWrap: true,
//       padding: EdgeInsets.zero,
//       itemCount: controller.searchResults.value?.results?.length ?? 0,
//       physics: NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         final search = controller.searchResults.value?.results?[index];
//         if (search?.backdropPath == null) return SizedBox();

//         return Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: InkWell(
//                 onTap: () {
//                   Get.offAllNamed(
//                     AppRoutes.movieDetails,
//                     arguments: search?.id,
//                   );
//                 },
//                 child: Container(
//                   height: cHeight5,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     children: [
//                       CachedNetworkImage(
//                         imageUrl: "$imageUrl${search?.backdropPath}",
//                         fit: BoxFit.contain,
//                       ),
//                       SizedBox(width: size1),
//                       Flexible(
//                         child: Text(
//                           search?.title ?? "",
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             color: whiteColor,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               right: 320,
//               top: 30,
//               child: Icon(
//                 Icons.play_circle_outline,
//                 color: whiteColor,
//                 size: 27,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// lib/app/modules/Search/search_view.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netflix/App/Modules/Search/search_controller.dart';
import 'package:netflix/Constant/app_colors.dart';
import 'package:netflix/Constant/app_size.dart';
import '../../../Constant/app_strings.dart';
import '../../Data/Models/trending_movie_model.dart';
import '../../Routes/app_pages.dart';

class SearchView extends GetView<CustomSearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: whiteColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(pad1),
        child: Column(
          children: [
            // Search Field
            CupertinoSearchTextField(
              controller: controller.searchController,
              padding: const EdgeInsets.all(10),
              prefixIcon: Icon(Icons.search, color: whiteColor),
              suffixIcon: Icon(Icons.cancel, color: whiteColor),
              style: const TextStyle(color: whiteColor),
              backgroundColor: greyColor,
              onChanged: (value) {
                // The listener in controller handles this
              },
            ),
            const SizedBox(height: size2),

            // Content based on search state
            Expanded(
              child: Obx(() {
                // Show loading
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: redColor),
                  );
                }

                // Show search results if search query exists
                if (controller.searchController.text.isNotEmpty) {
                  return _buildSearchResults();
                }

                // Show trending movies
                return _buildTrendingSection();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingSection() {
    return FutureBuilder<TrendingMovies?>(
      future: controller.trendingMoviesData, // Directly use the future
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: redColor),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: size5 * 2, color: greyColor),
                const SizedBox(height: size2),
                Text(
                  somethingWentWrong,
                  style: const TextStyle(color: whiteColor),
                ),
                const SizedBox(height: size2),
                ElevatedButton(
                  onPressed: () {
                    // Refresh trending data
                    controller.loadTrendingMovies();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: redColor),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // No data state
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Text(noDataFound, style: const TextStyle(color: whiteColor)),
          );
        }

        // Success state - properly typed as TrendingMovies
        final trendingMovies = snapshot.data!;
        final results = trendingMovies.results ?? [];

        if (results.isEmpty) {
          return Center(
            child: Text(noDataFound, style: const TextStyle(color: whiteColor)),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              topSearch,
              style: TextStyle(
                color: whiteColor,
                fontSize: size4,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: size2),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final movie = results[index];
                  return _buildSearchItem(
                    imageUrl: movie.backdropPath ?? movie.posterPath,
                    title: movie.title ?? '',
                    id: movie.id,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchResults() {
    final searchResults = controller.searchResults.value;
    final results = searchResults?.results ?? [];

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: size5 * 2, color: greyColor),
            const SizedBox(height: size2),
            const Text(
              'No results found',
              style: TextStyle(color: whiteColor, fontSize: size4),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search Results (${results.length})',
          style: const TextStyle(
            color: whiteColor,
            fontSize: size4,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: size2),
        Expanded(
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final movie = results[index];
              return _buildSearchItem(
                imageUrl: movie.backdropPath ?? movie.posterPath,
                title: movie.title ?? '',
                id: movie.id,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchItem({
    required String? imageUrl,
    required String title,
    required int? id,
  }) {
    return GestureDetector(
      onTap: () {
        if (id != null) {
          Get.toNamed(AppRoutes.movieDetails, arguments: id);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: size2),
        height: cHeight5,
        decoration: BoxDecoration(
          color: greyColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: "$imageUrl$imageUrl",
                      width: 100,
                      height: cHeight5,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 100,
                        height: cHeight5,
                        color: greyColor,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: redColor,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 100,
                        height: cHeight5,
                        color: greyColor,
                        child: const Icon(
                          Icons.broken_image,
                          color: whiteColor,
                        ),
                      ),
                    )
                  : Container(
                      width: 100,
                      height: cHeight5,
                      color: greyColor,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: whiteColor,
                      ),
                    ),
            ),

            // Title and Play Button
            Expanded(
              child: Stack(
                children: [
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: size2,
                      vertical: size2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: whiteColor,
                            fontSize: size6,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Play Icon
                  const Positioned(
                    right: size2,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        color: whiteColor,
                        size: size5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
