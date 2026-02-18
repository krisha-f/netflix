// // import 'dart:async';

// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import '../../Data/Models/search_movie_model.dart';
// // import '../../Data/Models/trending_movie_model.dart';
// // import '../../Data/Services/apiservice.dart';

// // class SearchController extends GetxController {
// //   // TextEditingController sController = TextEditingController();

// //   final ApiService apiService = ApiService();
// //   // TextEditingController sController = TextEditingController();
// //   SearchMovies? searchMovie;
// //   late final TextEditingController sController ;
// //   var isLoading = false.obs;
// //   Timer? _debounce;
// //   String _lastQuery = "";
// //   bool _isSearching = false;
// //   late Future<TrendingMovies?> treadingMoviesData;

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     treadingMoviesData = apiService.trendingMovies();
// //     sController = TextEditingController();
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

// //   void onClose(){
// //     sController.dispose();
// //     _debounce?.cancel();
// //       // sController.dispose();
// //       super.onClose();
// //   }

// //   // void search(String query) {
// //   //   apiService.searchMovies(query).then((result) {
// //   //       searchMovie = result;
// //   //   });
// //   //   update();
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
// // }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../Data/Models/search_movie_model.dart';
// import '../../Data/Models/trending_movie_model.dart';
// import '../../Data/Services/apiservice.dart';

// class CustomSearchController extends GetxController {
//   final ApiService apiService = ApiService();

//   // Make these observable
//   final searchResults = Rx<SearchMovies?>(null);
//   final searchController = TextEditingController();
//   final isLoading = false.obs;

//   // Make this a proper observable future
//   late Rx<Future<TrendingMovies?>> trendingMoviesData;

//   Timer? _debounce;
//   String _lastQuery = "";
//   bool _isSearching = false;

//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize trending movies
//     trendingMoviesData = Rx<Future<TrendingMovies?>>(apiService.trendingMovies());

//     // Add listener for search
//     searchController.addListener(_onSearchChanged);
//   }

//   void _onSearchChanged() {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();

//     _debounce = Timer(const Duration(milliseconds: 600), () {
//       final query = searchController.text.trim();
//       if (query.isNotEmpty && query != _lastQuery && query.length >= 3) {
//         _lastQuery = query;
//         search(query);
//       } else if (query.isEmpty) {
//         // Clear results when search is empty
//         searchResults.value = null;
//         isLoading.value = false;
//       }
//     });
//   }

//   Future<void> search(String query) async {
//     if (_isSearching) return;

//     try {
//       isLoading.value = true;
//       _isSearching = true;
//       final results = await apiService.searchMovies(query);
//       searchResults.value = results;
//     } catch (e) {
//       print("Search Error: $e");
//       searchResults.value = null;
//     } finally {
//       isLoading.value = false;
//       _isSearching = false;
//     }
//   }

//   void clearSearch() {
//     searchController.clear();
//     searchResults.value = null;
//     _lastQuery = "";
//   }

//   @override
//   void onClose() {
//     searchController.removeListener(_onSearchChanged);
//     searchController.dispose();
//     _debounce?.cancel();
//     super.onClose();
//   }
// }

// lib/app/modules/Search/custom_search_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Data/Models/search_movie_model.dart';
import '../../Data/Models/trending_movie_model.dart';
import '../../Data/Services/apiservice.dart';
// import '../../Data/Services/connectivity_service.dart';

class CustomSearchController extends GetxController {
  final ApiService _apiService = ApiService();
  // final ConnectivityService _connectivity = Get.find<ConnectivityService>();

  // Observables
  final searchResults = Rx<SearchMovies?>(null);
  final searchController = TextEditingController();
  final isLoading = false.obs;

  // Regular Future for trending movies (not Rx)
  late Future<TrendingMovies?> trendingMoviesData;

  // Search debouncing
  Timer? _debounce;
  String _lastQuery = "";
  bool _isSearching = false;

  @override
  void onInit() {
    super.onInit();
    // Initialize trending movies future
    loadTrendingMovies();
    // Add listener for search
    searchController.addListener(_onSearchChanged);
  }

  // Separate method to load trending movies
  Future<void> loadTrendingMovies() async {
    trendingMoviesData = _apiService.trendingMovies();
    // Optionally, you can await and cache if needed
    // but for FutureBuilder, we just need the Future reference
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 600), () {
      final query = searchController.text.trim();
      if (query.isNotEmpty && query != _lastQuery && query.length >= 3) {
        _lastQuery = query;
        search(query);
      } else if (query.isEmpty) {
        // Clear results when search is empty
        searchResults.value = null;
        isLoading.value = false;
        _lastQuery = "";
      }
    });
  }

  Future<void> search(String query) async {
    // Check connectivity
    // final isConnected = await _connectivity.checkConnectivity();
    // if (!isConnected) {
    //   Get.snackbar(
    //     'No Internet',
    //     'Please check your internet connection',
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //   );
    //   return;
    // }

    if (_isSearching) return;

    try {
      isLoading.value = true;
      _isSearching = true;
      final results = await _apiService.searchMovies(query);
      searchResults.value = results;
    } catch (e) {
      print("Search Error: $e");
      searchResults.value = null;
      Get.snackbar(
        'Search Failed',
        'Failed to search movies. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      _isSearching = false;
    }
  }

  void clearSearch() {
    searchController.clear();
    searchResults.value = null;
    _lastQuery = "";
    isLoading.value = false;
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}
