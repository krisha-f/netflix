import 'package:get/get_navigation/src/routes/get_route.dart';
import '../Modules/BottomAppBar/bottomAppBar_binding.dart';
import '../Modules/BottomAppBar/bottomAppBar_view.dart';
import '../Modules/Home/home_binding.dart';
import '../Modules/Home/home_view.dart';
import '../Modules/HotNews/hotnews_binding.dart';
import '../Modules/HotNews/hotnews_view.dart';
import '../Modules/Login/login_binding.dart';
import '../Modules/Login/login_view.dart';
import '../Modules/Movie_details/movie_details_binding.dart';
import '../Modules/Movie_details/movie_details_view.dart';
import '../Modules/Profile/profile_binding.dart';
import '../Modules/Profile/profile_view.dart';
import '../Modules/Search/search_binding.dart';
import '../Modules/Search/search_view.dart';
import '../Modules/Splash/splash_binding.dart';
import '../Modules/Splash/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(name: AppRoutes.splash,
        page: () => const SplashView(),
        binding: SplashBinding()),
    GetPage(name: AppRoutes.login,
        page: () => const LoginView(),
        binding: LoginBinding()),
    GetPage(name: AppRoutes.home,
        page: () => const HomeView(),
        binding: HomeBindings()),
    GetPage(name: AppRoutes.movieDetails,
        page: () =>  MovieDetailsView(),
        binding: MovieDetailsBinding()),
    GetPage(name: AppRoutes.search,
        page: () => const SearchView(),
        binding: SearchBinding()),
    GetPage(name: AppRoutes.profile,
        page: () => const ProfileView(),
        binding: ProfileBinding()),
    GetPage(name: AppRoutes.watchList,
        page: () => const ProfileView(),
        binding: ProfileBinding()),
    GetPage(name: AppRoutes.settings,
        page: () => const ProfileView(),
        binding: ProfileBinding()),
    GetPage(name: AppRoutes.bottomAppBar,
        page: () => const BottomAppbarView(),
        binding: BottomAppbarBinding()),
    GetPage(name: AppRoutes.hotNews,
        page: () => const HotNewsView(),
        binding: HotNewsBinding())
  ];
}