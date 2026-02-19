// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:get/get.dart';
//
// class ConnectivityService extends GetxService {
//   RxBool isOnline = true.obs;
//
//   void initialize() {
//     Connectivity().onConnectivityChanged.listen((status) {
//       isOnline.value = status != ConnectivityResult.none;
//     });
//   }
// }