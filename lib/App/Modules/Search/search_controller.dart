import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Data/Models/search_movie_model.dart';
import '../../Data/Models/trending_movie_model.dart';
import '../../Data/Services/apiservice.dart';

class SearchController extends GetxController {
  // TextEditingController sController = TextEditingController();

  final ApiService apiService = ApiService();
  // TextEditingController sController = TextEditingController();
  SearchMovies? searchMovie;
  late final TextEditingController sController ;
  var isLoading = false.obs;
  Timer? _debounce;
  String _lastQuery = "";
  bool _isSearching = false;
  late Future<TrendingMovies?> treadingMoviesData;

  @override
  void onInit() {
    super.onInit();
    treadingMoviesData = apiService.trendingMovies();
    sController = TextEditingController();
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

  void onClose(){
    sController.dispose();
    _debounce?.cancel();
      // sController.dispose();
      super.onClose();
  }

  // void search(String query) {
  //   apiService.searchMovies(query).then((result) {
  //       searchMovie = result;
  //   });
  //   update();
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
}
