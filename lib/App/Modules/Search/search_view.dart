import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../Data/Models/search_movie_model.dart';
import '../../Data/Models/trending_movie_model.dart';
import '../../Data/Services/apiservice.dart';

class SearchView extends GetView<SearchController> {
  SearchView({super.key});

  final TextEditingController sController = TextEditingController();
  final ApiService apiService = ApiService();

  Rx<SearchMovies?> searchMovie = Rx<SearchMovies?>(null);
  RxBool isSearching = false.obs;
  RxString query = ''.obs;

  late Future<TrendingMovies?> trendingMovies = apiService.trendingMovies();

  Future<void> search(String text) async {
    try {
      isSearching.value = true;
      final result = await apiService.searchMovies(text);
      searchMovie.value = result;
    } catch (e) {
      print("Search Error: $e");
    } finally {
      isSearching.value = false;
    }
  }

  void updateQuery(String text) {
    query.value = text;
    if (text.isEmpty) {
      searchMovie.value = null;
    }
  }

  void initState(){
    debounce(query, (value) {
      if (value.length >= 3) {
        search(value);
      }
    }, time: const Duration(milliseconds: 600));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          CupertinoSearchTextField(
            controller: sController,
            onChanged: updateQuery,
          ),

          Expanded(
            child: Obx(() {
              if (query.value.isEmpty) {
                return FutureBuilder(
                  future: trendingMovies,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final movies = snapshot.data?.results ?? [];

                    return ListView.builder(
                      itemCount: movies.length,
                      itemBuilder: (_, index) {
                        final movie = movies[index];
                        return ListTile(
                          title: Text(movie.title ?? ''),
                        );
                      },
                    );
                  },
                );
              }

              if (isSearching.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final results =
                  searchMovie.value?.results ?? [];

              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (_, index) {
                  final movie = results[index];
                  return ListTile(
                    title: Text(movie.title ?? ''),
                  );
                },
              );
            }),
          )
        ],
      ),
    );
  }
}