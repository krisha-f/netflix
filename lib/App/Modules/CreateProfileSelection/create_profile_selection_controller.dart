import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:netflix/App/Routes/app_pages.dart';
import '../../Data/Services/storage_service.dart';
import '../Download/download_controller.dart';
import '../MyList/mylist_controller.dart';
import '../Profile/profile_controller.dart';

class ProfileSelectionController extends GetxController {
  final database = FirebaseDatabase.instance.ref();
  final storage = Get.find<StorageService>();

  RxList<Map<String, dynamic>> profiles = <Map<String, dynamic>>[].obs;
  RxBool isLoading = true.obs;

  String? get uid => FirebaseAuth.instance.currentUser?.uid;


  @override
  void onInit() {
    super.onInit();
    loadProfiles();
  }

  Future<void> loadProfiles() async {
    if (uid == null) return;

    final snapshot =
    await database.child("users/$uid/profiles").get();

    if (!snapshot.exists) {
      isLoading.value = false;
      return;
    }

    final value = snapshot.value;

    if (value is Map) {
      // profiles.assignAll(
      //   value.entries.map((e) {
      //     return Map<String, dynamic>.from(e.value);
      //   }).toList(),
      // );
      profiles.assignAll(
        value.entries.map((e) {
          final map = Map<String, dynamic>.from(e.value);
          map["id"] = e.key;
          return map;
        }).toList(),
      );
    }

    isLoading.value = false;

    if (profiles.length == 1) {
      selectProfile(profiles.first["id"]);
    }
  }



  Future<void> selectProfile(String profileId) async {
    final profileController = Get.find<ProfileController>();
    profileController.selectedProfileId.value = profileId;
    storage.saveSelectedProfile(profileId);
    await database
        .child("users/$uid/selectedProfileId")
        .set(profileId);

    Get.toNamed(AppRoutes.bottomAppBar);
    await Get.find<MyListController>().loadMyListFromFirebase();
    await Get.find<DownloadController>().loadDownloadsFromFirebase();
  }
}