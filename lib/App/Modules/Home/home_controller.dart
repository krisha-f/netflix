
import 'package:get/get.dart';
import 'package:netflix/App/Data/Services/apiservice.dart';

import '../../Data/Models/movie_model.dart';

class HomeController extends GetxController{
  late Future<Movies?> moviesData;
  final ApiService apiService = ApiService();


  @override
  void onInit() {
    super.onInit();
    moviesData =apiService.fetchMovies();
  }


}