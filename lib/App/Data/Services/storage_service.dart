
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
  void saveUserEmail(String email) {
    _box.write('userEmail', email);
  }

  // ---------------- THEME ----------------
  bool get isDarkMode => _box.read('isDark') ?? true;

  void saveTheme(bool value) {
    _box.write('isDark', value);
  }

  String? get selectedProfileId =>
      _box.read("selectedProfileId");

  void saveSelectedProfile(String id) {
    _box.write("selectedProfileId", id);
  }
  String? getSelectedProfile() {
    return _box.read('selectedProfileId');
  }


  void clearSelectedProfile() {
    _box.remove('selectedProfileId');
  }


  List getMyList() {
    final profileId = selectedProfileId;
    if (profileId == null) return [];
    return _box.read('myList_$profileId') ?? [];
  }

  void saveMyList(List data) {
    final profileId = selectedProfileId;
    if (profileId == null) return;
    _box.write('myList_$profileId', data);
  }


  List getDownloads() {
    final profileId = selectedProfileId;
    if (profileId == null) return [];
    return _box.read('downloads_$profileId') ?? [];
  }

  void saveDownloads(List data) {
    final profileId = selectedProfileId;
    if (profileId == null) return;
    _box.write('downloads_$profileId', data);
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