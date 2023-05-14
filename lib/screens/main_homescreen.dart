import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sportsnews/inner_screens/search_screen.dart';
import 'package:sportsnews/screens/account.dart';
import 'package:sportsnews/screens/all_news.dart';
import 'package:sportsnews/screens/favourite.dart';
import 'package:sportsnews/screens/home_screen.dart';
import 'package:sportsnews/services/utils.dart';
import 'package:sportsnews/widgets/drawer_widget.dart';
import 'package:sportsnews/widgets/snackbar.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

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
  List<Widget> widgetList = const [
    HomeScreen(),
    AllNews(),
    FavouriteNews(),
    AccountPage(),
  ];

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
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
              items: const [
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
                    backgroundColor: Colors.yellowAccent),
              ])),
    );
  }
}
