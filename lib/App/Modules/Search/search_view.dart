import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:netflix/App/Data/Services/utils.dart';
import 'package:netflix/Constant/app_colors.dart';
import 'package:netflix/Constant/app_size.dart';
import '../../../Constant/app_strings.dart';
import '../../Data/Models/search_movie_model.dart';
import '../../Data/Models/trending_movie_model.dart';
import '../../Data/Services/apiservice.dart';
import '../../Routes/app_pages.dart';

class SearchView extends GetView<SearchController> {
  SearchView({super.key});

  final ApiService apiService = ApiService();
  // TextEditingController sController = TextEditingController();
  SearchMovies? searchMovie;
  final TextEditingController sController = TextEditingController();
  var isLoading = false.obs;
  Timer? _debounce;
  String _lastQuery = "";
  bool _isSearching = false;
  late Future<TrendingMovies?> treadingMoviesData = apiService.trendingMovies();




  // void search(String query) {
  //   apiService.searchMovies(query).then((result) {
  //     searchMovie = result;
  //   });
  // }

  Future<void> search(String query) async {
    // if (query.isEmpty) return;
    //
    // try {
    //   isLoading.value = true;
    //   searchMovie = await apiService.searchMovies(query);
    // } catch (e) {
    //   print(e);
    // } finally {
    //   isLoading.value = false;
    // }
    if (_isSearching) return; // prevent overlapping calls

    try {
      _isSearching = true;
      searchMovie = await apiService.searchMovies(query);
    } catch (e) {
      print("Search Error: $e");
    } finally {
      _isSearching = false;
    }
  }

  void initState(){
    // super.initState();
    // debounce(
    //   sController.text.obs,
    //       (_) => search(sController.text),
    //   time: Duration(milliseconds: 500),
    // );
    // treadingMoviesData = apiService.trendingMovies();

    sController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(milliseconds: 600), () {
        final query = sController.text.trim();

        if (query.isNotEmpty && query != _lastQuery) {
          _lastQuery = query;
          // search(query);
          if (query.length >= 3) {
            search(query);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    sController.dispose();
    _debounce?.cancel();
    // super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar( backgroundColor: Theme.of(context).scaffoldBackgroundColor, foregroundColor: whiteColor),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CupertinoSearchTextField(
              controller: sController,
              padding: EdgeInsets.all(10),
              prefixIcon: Icon(Icons.search, color: whiteColor),
              suffixIcon: Icon(Icons.cancel, color: whiteColor),
              style: TextStyle(color: whiteColor),
              backgroundColor: greyColor,
              onChanged: (value) {
                if (value.isEmpty) {
                } else {
                  search(sController.text);
                }
              },
            ),
            SizedBox(height: size1,),
            sController.text.isEmpty
                ?
            // SizedBox()
            FutureBuilder(
              future: treadingMoviesData,
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

                // if (movie?.results == null || movie!.results!.isEmpty) {
                //   return const SizedBox();
                // }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      topSearch,
                      style: TextStyle(color: whiteColor),
                    ),
                    const SizedBox(height: size1),
                    SizedBox(
                      height: cHeight4,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: movie?.results?.length?? 0,
                        itemBuilder: (context, index) {
                          final topMovies = movie?.results?[index];
                       return
                         Stack(
                           children: [
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: InkWell(
                                   onTap:(){
                                     Get.offAllNamed(
                                       AppRoutes.movieDetails,
                                       arguments: topMovies?.id,
                                     );
                                   },
                                   child: Container(
                                     height: cHeight5,
                                     decoration: BoxDecoration(
                                         borderRadius : BorderRadius.circular(20)
                                     ),
                                     child: Row(
                                       children: [
                                         CachedNetworkImage(imageUrl:"$imageUrl${topMovies?.backdropPath}",fit: BoxFit.contain,),
                                         SizedBox(width: size1,),
                                         Flexible(child: Text(topMovies?.title ?? "",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: whiteColor,fontWeight: FontWeight.bold),))
                                       ],
                                     ),
                                   )),
                             ),
                             Positioned(
                                 right:320,
                                 top:30,
                                 child: Icon(Icons.play_circle_outline,color: whiteColor,size: 27,))
                           ],
                         );
                        },
                      ),
                    ),
                  ],
                );
              },
            )

                : searchMovie == null
                ? SizedBox.shrink()
                : ListView.builder(
               shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: searchMovie?.results?.length,
                  physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                 final search = searchMovie?.results?[index];
                  return search?.backdropPath == null? SizedBox():
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            onTap:(){
                              Get.offAllNamed(
                                AppRoutes.movieDetails,
                                arguments: search?.id,
                              );
                            },
                            child: Container(
                              height: cHeight5,
                              decoration: BoxDecoration(
                                          borderRadius : BorderRadius.circular(20)
                                          ),
                              child: Row(
                                children: [
                                  CachedNetworkImage(imageUrl:"$imageUrl${search?.backdropPath}",fit: BoxFit.contain,),
                                  SizedBox(width: size1,),
                                  Flexible(child: Text(search?.title ?? "",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: whiteColor,fontWeight: FontWeight.bold),))
                                ],
                              ),
                            )),
                      ),
                      Positioned(
                          right:320,
                          top:30,
                          child: Icon(Icons.play_circle_outline,color: whiteColor,size: 27,))
                    ],
                  );
            }),
          ],
        ),
      ),
    );
  }
}
