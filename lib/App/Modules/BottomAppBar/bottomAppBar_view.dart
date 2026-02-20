import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../Constant/app_size.dart';
import '../../../Constant/app_strings.dart';
import '../Home/home_view.dart';
import '../HotNews/hotnews_view.dart';
import '../Profile/profile_view.dart';
import '../Search/search_view.dart';
import 'bottomAppBar_controller.dart';

class BottomAppbarView extends GetView<BottomAppbarController> {
  const BottomAppbarView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        bottomNavigationBar: Container(

          color: Theme.of(context).scaffoldBackgroundColor,
          height: bottomBar,
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: homeText),
              Tab(icon: Icon(Icons.search), text: searchText),
              Tab(icon: Icon(Icons.library_add), text: hotNewsText),
              Tab(icon: Icon(Icons.person_2_rounded), text: profile),
            ],
            // unselectedLabelColor: greyColor,
            // labelColor: whiteColor,
            // indicatorColor: transparentColor,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor:
            Theme.of(context).textTheme.bodyMedium!.color,
            indicatorColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        body: TabBarView(children: [

          HomeView(),
          SearchView(),
          HotNewsView(),
          ProfileView(),
        ]),
      ),
    );
  }
}
