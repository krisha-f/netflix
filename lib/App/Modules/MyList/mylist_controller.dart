import 'package:get/get.dart';
import '../../Data/Models/movie_model.dart';

class MyListController extends GetxController {
  var myMovies = <Results>[].obs;

  void addMovie(Results movie) {
    if (!myMovies.any((m) => m.id == movie.id)) {
      myMovies.add(movie);
    }
  }

  void removeMovie(Results movie) {
    myMovies.removeWhere((m) => m.id == movie.id);
  }

  bool isAdded(Results movie) {
    return myMovies.any((m) => m.id == movie.id);
  }
}