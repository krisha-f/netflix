
import 'package:get/get.dart';
import '../../Data/Models/hot_news_model.dart';
import '../../Data/Services/apiservice.dart';

class HotNewsController extends GetxController {
  final ApiService _apiService = ApiService();

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
      isLoading.value = true;
      errorMessage.value = null;
      hasError.value = false;


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

  Future<void> refreshHotNews() async {
    await loadHotNews();
  }

  String getDisplayDate(Result item) {
    if (item.releaseDate != null && item.releaseDate!.isNotEmpty) {
      return item.releaseDate!;
    } else if (item.firstAirDate != null && item.firstAirDate!.isNotEmpty) {
      return item.firstAirDate!;
    }
    return '';
  }

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
    super.onClose();
  }
}
