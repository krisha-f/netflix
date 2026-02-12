import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../Data/Models/search_movie_model.dart';
import '../../Data/Services/apiservice.dart';

class SearchController extends GetxController {
  final ApiService apiService = ApiService();
  // TextEditingController sController = TextEditingController();
  SearchMovies? searchMovie;

  @override
  void onInit() {
    super.onInit();
  }

  void onClose(){
      // sController.dispose();
      super.onClose();
  }

  void search(String query) {
    apiService.searchMovies(query).then((result) {
        searchMovie = result;
    });
    update();
  }
}
