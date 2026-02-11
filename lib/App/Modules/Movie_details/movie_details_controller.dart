
import 'package:get/get.dart';

import '../../Data/Models/movie_details_model.dart';
import '../../Data/Services/apiservice.dart';

class MovieDetailsController extends GetxController{
  late int movieId;

  late Future<MovieDetails?> movieDetailsData;


  final ApiService apiService = ApiService();


  @override
  void onInit() {
    super.onInit();
    movieId = Get.arguments;
    print("*******************");
    print("MOVIE ID RECEIVED: $movieId");
    movieDetailsData = apiService.movieDetails(movieId);
    print("*******************");
    print("MOVIE ID RECEIVED: $movieDetailsData");
    // movieDetailsData =apiService.movieDetails();
  }

}