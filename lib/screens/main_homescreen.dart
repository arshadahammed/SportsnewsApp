import 'dart:developer';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:sportsnews/inner_screens/deeplink_blogdetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sportsnews/inner_screens/search_screen.dart';
import 'package:sportsnews/models/news_model.dart';
import 'package:sportsnews/providers/firebase_dynamic_link.dart';
import 'package:sportsnews/screens/account.dart';
import 'package:sportsnews/screens/all_news.dart';
import 'package:sportsnews/screens/category_pages/all_news.dart';
import 'package:sportsnews/screens/favourite.dart';
import 'package:sportsnews/screens/home_screen.dart';
import 'package:sportsnews/services/utils.dart';
import 'package:sportsnews/providers/search_news_provider.dart';
import 'package:provider/provider.dart';

import 'package:sportsnews/widgets/drawer_widget.dart';
import 'package:sportsnews/widgets/snackbar.dart';

class MainHomeScreen extends StatefulWidget {
  MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen>
    with WidgetsBindingObserver {
  DateTime preBackpress = DateTime.now();
  //int _selectedIndex = 0;
  //late PageController _pageController;
  int myIndex = 0;
  //AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  //bool isPaused = false;

  @override
  void initState() {
    super.initState();
    handleInitialLink();
    initDynamicLinks(context);

    //FirebaseDynamicLinkService.initDynamicLinks(   context);
    // appOpenAdManager.loadAd();
    // WidgetsBinding.instance.addObserver(this);
    // _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.paused) {
  //     isPaused = true;
  //   }
  //   if (state == AppLifecycleState.resumed && isPaused) {
  //     // print("Resumed==========================");
  //     appOpenAdManager.showAdIfAvailable();
  //     isPaused = false;
  //   }
  // }

  // deeplink

  // Get any initial links
  // Future<void> initDynamicLinks(BuildContext context) async {
  //   final searchNewsProvider = Provider.of<SearchNewsProvider>(context);
  //   try {
  //     //await searchNewsProvider.fetchAllNews();
  //     FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
  //       final Uri deepLink = dynamicLinkData.link;

  //       handleDeepLink(deepLink);
  //     }).onError((error) {
  //       print('onLink error');
  //       print(error.message);
  //     });
  //   } catch (error) {
  //     print('Fetch news error: $error');
  //   }
  // }

  Future<void> initDynamicLinks(BuildContext context) async {
    //await Future.delayed(Duration(seconds: 1));
    //final searchNewsProvider = Provider.of<SearchNewsProvider>(context);

    //await searchNewsProvider.fetchAllNews();

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      print("DYnamic Link Started");

      final Uri deepLink = dynamicLinkData.link;
      //deepLink != null
      handleDeepLink(deepLink);
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }

  //initial
  Future<void> handleInitialLink() async {
    //await Future.delayed(Duration(seconds: 1));
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      final Uri deepLink = initialLink.link;

      handleDeepLink(deepLink);
    }
  }

  // Future<void> handleInitialLink(BuildContext context) async {
  //   final searchNewsProvider = Provider.of<SearchNewsProvider>(context);
  //   try {
  //     await searchNewsProvider.fetchAllNews();
  //     //await Future.delayed(Duration(seconds: 1));
  //     final PendingDynamicLinkData? initialLink =
  //         await FirebaseDynamicLinks.instance.getInitialLink();
  //     if (initialLink != null) {
  //       final Uri deepLink = initialLink.link;

  //       handleDeepLink(deepLink);
  //     }
  //   } catch (error) {
  //     print('Fetch news error: $error');
  //   }
  // }

  //handle deep link
  void handleDeepLink(Uri deepLink) {
    final List<String> pathSegments = deepLink.pathSegments;
    if (pathSegments.isNotEmpty && pathSegments.first == 'sportsNews') {
      final String newsId = pathSegments.last;

      // Navigate to the news article page using the newsId
      print('Navigating to news article with ID: $newsId');
      Navigator.pushNamed(context, DeepLinkNewsDetailsScreen.routeName,
          arguments: newsId);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      HomeScreen(),
      AllCategoryNews(),
      FavouriteNews(),
      AccountPage(),
    ];
    final Color color = Utils(context).getColor;
    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(preBackpress);
        //  print('$timegap');
        final canExit = timegap >= const Duration(seconds: 2);

        preBackpress = DateTime.now();
        if (canExit) {
          //show snackbar
          // const snack = SnackBar(
          //   content: Text('Press back button again to Exit'),
          //   duration: Duration(seconds: 2),
          // );
          // ScaffoldMessenger.of(context).showSnackBar(snack);
          EssentialWidgets.showSnackBar(
              context, "Press back button again to Exit");
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: color),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            centerTitle: true,
            title: Text(
              'Sports News',
              style: GoogleFonts.lobster(
                  textStyle: TextStyle(
                      color: color, fontSize: 20, letterSpacing: 0.6)),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const SearchScreen(),
                        inheritTheme: true,
                        ctx: context),
                  );
                },
                icon: const Icon(
                  IconlyLight.search,
                ),
              )
            ],
          ),
          drawer: const DrawerWidget(),
          body: IndexedStack(
            index: myIndex,
            children: widgetList,
          ),
          bottomNavigationBar: BottomNavigationBar(
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              onTap: (index) {
                setState(() {
                  myIndex = index;
                });
              },
              currentIndex: myIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                  backgroundColor: Colors.amber,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper),
                  label: 'All News',
                  backgroundColor: Colors.indigo,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.heart_broken),
                  label: 'Favourite',
                  backgroundColor: Colors.blue,
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Account',
                    backgroundColor: Color.fromARGB(255, 173, 173, 169)),
              ])),
    );
  }
}
