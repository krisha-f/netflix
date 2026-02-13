// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// class StorageService extends GetxService {
//   final SharedPreferences _prefs = Get.find();
//
//
//   static const _loginKey = 'is_logged_in';
//   static const _watchlistKey = 'watchlist_ids';
//
//
//   bool get isLoggedIn => _prefs.getBool(_loginKey) ?? false;
//
//
//   Future<void> saveLogin() async {
//     await _prefs.setBool(_loginKey, true);
//   }
//
//
//   Future<void> logout() async {
//     await _prefs.clear();
//   }
//
//
//   List<int> getWatchlist() {
//     return _prefs.getStringList(_watchlistKey)?.map(int.parse).toList() ?? [];
//   }
// }

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  late GetStorage _box;

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  // ---------------- THEME ----------------
  bool get isDarkMode => _box.read('isDark') ?? true;

  void saveTheme(bool value) {
    _box.write('isDark', value);
  }

  // ---------------- AUTH ----------------
  bool get isLoggedIn => _box.read('isLoggedIn') ?? false;

  void saveLoginStatus(bool value) {
    _box.write('isLoggedIn', value);
  }

  void clearAll() {
    _box.erase();
  }
}