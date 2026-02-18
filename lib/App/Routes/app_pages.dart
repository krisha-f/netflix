import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:netflix/App/Modules/Auth/signup_view.dart';
import '../Modules/Auth/auth_binding.dart';
import '../Modules/Auth/login_view.dart';
import '../Modules/BottomAppBar/bottomAppBar_binding.dart';
import '../Modules/BottomAppBar/bottomAppBar_view.dart';
import '../Modules/CreateProfileSelection/create_profile_selection_controller.dart';
import '../Modules/CreateProfileSelection/create_profile_selection_view.dart';
import '../Modules/Download/download_binding.dart';
import '../Modules/Download/download_view.dart';
import '../Modules/Home/home_binding.dart';
import '../Modules/Home/home_view.dart';
import '../Modules/HotNews/hotnews_binding.dart';
import '../Modules/HotNews/hotnews_view.dart';
import '../Modules/Movie_details/movie_details_binding.dart';
import '../Modules/Movie_details/movie_details_view.dart';
import '../Modules/MyList/mylist_binding.dart';
import '../Modules/MyList/mylist_view.dart';
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
        binding: AuthBinding()),
    GetPage(name: AppRoutes.signup,
        page: () => const SignUpView(),
        binding: AuthBinding()),
    GetPage(name: AppRoutes.home,
        page: () =>  HomeView(),
        binding: HomeBindings()),
    GetPage(name: AppRoutes.movieDetails,
        page: () =>  MovieDetailsView(),
        binding: MovieDetailsBinding()),
    GetPage(name: AppRoutes.search,
        page: () =>  SearchView(),
        binding: SearchBinding()),
    GetPage(name: AppRoutes.profile,
        page: () =>  ProfileView(),
        binding: ProfileBinding()),
    // GetPage(name: AppRoutes.watchList,
    //     page: () =>  ProfileView(),
    //     binding: ProfileBinding()),
    // GetPage(name: AppRoutes.settings,
    //     page: () => const ProfileView(),
    //     binding: ProfileBinding()),
    GetPage(name: AppRoutes.bottomAppBar,
        page: () => const BottomAppbarView(),
        binding: BottomAppbarBinding()),
    GetPage(name: AppRoutes.hotNews,
        page: () =>  HotNewsView(),
        binding: HotNewsBinding()),
    GetPage(name: AppRoutes.myList,
        page: () =>  MyListView(),
        binding: MyListBinding()),
    GetPage(name: AppRoutes.download,
        page: () =>  DownloadView(),
        binding: DownloadBinding()),
    GetPage(
      name: AppRoutes.profileSelection,
      page: () => const ProfileSelectionView(),
      binding: BindingsBuilder(() {
        Get.put(ProfileSelectionController());
      }),
    ),
  ];
}