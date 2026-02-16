import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../Data/Models/hot_news_model.dart';
import '../../Data/Services/apiservice.dart';

class HotNewsController extends GetxController {
  late Future<HotNews?> hotNewsData;
  final ApiService apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    hotNewsData = apiService.hotNews();
  }

}
