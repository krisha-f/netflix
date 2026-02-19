// // import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// // import '../../Data/Models/hot_news_model.dart';
// // import '../../Data/Services/apiservice.dart';

// // class HotNewsController extends GetxController {
// //   late Future<HotNews?> hotNewsData;
// //   final ApiService apiService = ApiService();

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     hotNewsData = apiService.hotNews();
// //   }

// // }

// import 'package:get/get.dart';
// import '../../Data/Services/apiservice.dart';

// class HotNewsController extends GetxController {
//   final ApiService apiService = ApiService();

//   // Observable list for hot news
//   final hotNewsList = <HotNewsResult>[].obs;
//   final isLoading = false.obs;
//   final errorMessage = Rxn<String>();

//   @override
//   void onInit() {
//     super.onInit();
//     loadHotNews();
//   }

//   Future<void> loadHotNews() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = null;

//       final result = await apiService.hotNews();

//       if (result != null && result.results != null) {
//         hotNewsList.assignAll(result.results!);
//       } else {
//         hotNewsList.clear();
//       }
//     } catch (e) {
//       errorMessage.value = 'Failed to load hot news: $e';
//       print('HotNews Error: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Refresh data
//   Future<void> refreshHotNews() async {
//     await loadHotNews();
//   }
// }

// lib/app/modules/HotNews/hotnews_controller.dart
import 'package:get/get.dart';
import '../../Data/Models/hot_news_model.dart';
import '../../Data/Services/apiservice.dart';

class HotNewsController extends GetxController {
  final ApiService _apiService = ApiService();

  // Observable variables
  final hotNewsList = <Result>[].obs;
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();
  final hasError = false.obs;
  late Future<HotNews?> hotNewsData;

  @override
  void onInit() {
    super.onInit();
    hotNewsData= _apiService.hotNews();
    loadHotNews();
  }

  Future<void> loadHotNews() async {
    try {
      // Start loading
      isLoading.value = true;
      errorMessage.value = null;
      hasError.value = false;

      // // Check connectivity
      // final isConnected = await _connectivity.checkConnectivity();
      // if (!isConnected) {
      //   errorMessage.value = 'No internet connection';
      //   hasError.value = true;
      //   return;
      // }

      // Fetch hot news
      final response = await _apiService.hotNews();

      if (response != null && response.results != null) {
        hotNewsList.assignAll(response.results!);
      } else {
        hotNewsList.clear();
        errorMessage.value = 'No hot news available';
        hasError.value = true;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load hot news';
      hasError.value = true;
      print('HotNews Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh hot news
  Future<void> refreshHotNews() async {
    await loadHotNews();
  }

  // Get display date based on media type
  String getDisplayDate(Result item) {
    if (item.releaseDate != null && item.releaseDate!.isNotEmpty) {
      return item.releaseDate!;
    } else if (item.firstAirDate != null && item.firstAirDate!.isNotEmpty) {
      return item.firstAirDate!;
    }
    return '';
  }

  // Get title based on media type
  String getTitle(Result item) {
    if (item.title != null && item.title!.isNotEmpty) {
      return item.title!;
    } else if (item.name != null && item.name!.isNotEmpty) {
      return item.name!;
    } else if (item.originalTitle != null && item.originalTitle!.isNotEmpty) {
      return item.originalTitle!;
    } else if (item.originalName != null && item.originalName!.isNotEmpty) {
      return item.originalName!;
    }
    return 'Untitled';
  }

  // Get image path
  String getImagePath(Result item) {
    if (item.backdropPath != null && item.backdropPath!.isNotEmpty) {
      return item.backdropPath!;
    } else if (item.posterPath != null && item.posterPath!.isNotEmpty) {
      return item.posterPath!;
    }
    return '';
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}
