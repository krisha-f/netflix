// // import 'package:get/get.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// //
// // class StorageService extends GetxService {
// //   final SharedPreferences _prefs = Get.find();
// //
// //
// //   static const _loginKey = 'is_logged_in';
// //   static const _watchlistKey = 'watchlist_ids';
// //
// //
// //   bool get isLoggedIn => _prefs.getBool(_loginKey) ?? false;
// //
// //
// //   Future<void> saveLogin() async {
// //     await _prefs.setBool(_loginKey, true);
// //   }
// //
// //
// //   Future<void> logout() async {
// //     await _prefs.clear();
// //   }
// //
// //
// //   List<int> getWatchlist() {
// //     return _prefs.getStringList(_watchlistKey)?.map(int.parse).toList() ?? [];
// //   }
// // }
//
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
//
// class StorageService extends GetxService {
//   late GetStorage _box;
//
//   Future<StorageService> init() async {
//     await GetStorage.init();
//     _box = GetStorage();
//     return this;
//   }
//
//   // ---------------- THEME ----------------
//   bool get isDarkMode => _box.read('isDark') ?? true;
//
//   void saveTheme(bool value) {
//     _box.write('isDark', value);
//   }
//
//   // ---------------- AUTH ----------------
//   bool get isLoggedIn => _box.read('isLoggedIn') ?? false;
//
//   void saveLoginStatus(bool value) {
//     _box.write('isLoggedIn', value);
//   }
//
//   void clearAll() {
//     _box.erase();
//   }
// }

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  final GetStorage _box = GetStorage();

  // ---------------- AUTH ----------------
  bool get isLoggedIn => _box.read('isLoggedIn') ?? false;

  void saveLoginStatus(bool value) {
    _box.write('isLoggedIn', value);
  }

  String? get userEmail => _box.read('userEmail');
  // String? get userEmail => _box.read('userEmail');
  // set userEmail(String? value) => _box.write('userEmail', value);
  void saveUserEmail(String email) {
    _box.write('userEmail', email);
  }

  // ---------------- THEME ----------------
  bool get isDarkMode => _box.read('isDark') ?? true;

  void saveTheme(bool value) {
    _box.write('isDark', value);
  }

  // ---------------- MY LIST ----------------
  List getMyList() => _box.read('myList') ?? [];

  void saveMyList(List data) {
    _box.write('myList', data);
  }

  // ---------------- DOWNLOADS ----------------
  List getDownloads() => _box.read('downloads') ?? [];

  void saveDownloads(List data) {
    _box.write('downloads', data);
  }

  // ---------------- PROFILE IMAGE ----------------
  String? getProfileImage(String email) {
    return _box.read('profile_$email');
  }

  void saveProfileImage(String email, String path) {
    _box.write('profile_$email', path);
    // database.child("users/$email/profile/imageUrl").set(downloadUrl);
  }

  void clearAll() {
    _box.erase();
  }
}