import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:netflix/App/Routes/app_pages.dart';
import 'package:netflix/Constant/app_colors.dart';
import '../../Data/Services/utils.dart';
import 'download_controller.dart';

class DownloadView extends GetView<DownloadController> {
  const DownloadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text("Download"),leading: GestureDetector(onTap: (){AppRoutes.home;},child: Icon(Icons.arrow_back_ios_new,color: whiteColor,size: 15,),),),
      body: Obx(() {
        final downloads =
            controller.downloadedMovies;

        if (downloads.isEmpty) {
          return Center(child: Text("No Downloads Yet"));
        }

        return ListView.builder(
          itemCount: downloads.length,
          itemBuilder: (context, index) {
            final movie = downloads[index];

            return ListTile(
              leading: CachedNetworkImage(
                imageUrl: "$imageUrl${movie.posterPath}",
                width: 50,
                fit: BoxFit.cover,
              ),
              title: Text(movie.title ?? ""),
            );
          },
        );
      }),
    );
  }
}