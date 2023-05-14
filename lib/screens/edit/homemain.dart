// import 'package:bottom_navy_bar/bottom_navy_bar.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_iconly/flutter_iconly.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:sportsnews/inner_screens/search_screen.dart';
// import 'package:sportsnews/screens/account.dart';
// import 'package:sportsnews/screens/all_news.dart';
// import 'package:sportsnews/screens/favourite.dart';
// import 'package:sportsnews/screens/home_screen.dart';
// import 'package:sportsnews/services/utils.dart';
// import 'package:sportsnews/widgets/drawer_widget.dart';
// import 'package:sportsnews/widgets/snackbar.dart';

// class MainHomeScreen extends StatefulWidget {
//   const MainHomeScreen({super.key});

//   @override
//   State<MainHomeScreen> createState() => _MainHomeScreenState();
// }

// class _MainHomeScreenState extends State<MainHomeScreen>
//     with WidgetsBindingObserver {
//   DateTime preBackpress = DateTime.now();
//   int _selectedIndex = 0;
//   late PageController _pageController;

//   //AppOpenAdManager appOpenAdManager = AppOpenAdManager();
//   //bool isPaused = false;

//   @override
//   void initState() {
//     super.initState();
//     // appOpenAdManager.loadAd();
//     // WidgetsBinding.instance.addObserver(this);
//     _pageController = PageController();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _pageController.dispose();
//     WidgetsBinding.instance.removeObserver(this);
//   }

//   // @override
//   // void didChangeAppLifecycleState(AppLifecycleState state) {
//   //   super.didChangeAppLifecycleState(state);
//   //   if (state == AppLifecycleState.paused) {
//   //     isPaused = true;
//   //   }
//   //   if (state == AppLifecycleState.resumed && isPaused) {
//   //     // print("Resumed==========================");
//   //     appOpenAdManager.showAdIfAvailable();
//   //     isPaused = false;
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final Color color = Utils(context).getColor;
//     return WillPopScope(
//       onWillPop: () async {
//         final timegap = DateTime.now().difference(preBackpress);
//         //  print('$timegap');
//         final canExit = timegap >= const Duration(seconds: 2);

//         preBackpress = DateTime.now();
//         if (canExit) {
//           //show snackbar
//           // const snack = SnackBar(
//           //   content: Text('Press back button again to Exit'),
//           //   duration: Duration(seconds: 2),
//           // );
//           // ScaffoldMessenger.of(context).showSnackBar(snack);
//           EssentialWidgets.showSnackBar(
//               context, "Press back button again to Exit");
//           return false;
//         } else {
//           return true;
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           iconTheme: IconThemeData(color: color),
//           elevation: 0,
//           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//           centerTitle: true,
//           title: Text(
//             'Sports News',
//             style: GoogleFonts.lobster(
//                 textStyle:
//                     TextStyle(color: color, fontSize: 20, letterSpacing: 0.6)),
//           ),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   PageTransition(
//                       type: PageTransitionType.rightToLeft,
//                       child: const SearchScreen(),
//                       inheritTheme: true,
//                       ctx: context),
//                 );
//               },
//               icon: const Icon(
//                 IconlyLight.search,
//               ),
//             )
//           ],
//         ),
//         drawer: const DrawerWidget(),
//         body: SizedBox.expand(
//           child: PageView(
//             controller: _pageController,
//             onPageChanged: (index) {
//               setState(() {
//                 _selectedIndex = index;
//               });
//             },
//             children: const [
//               //subHomePAge
//               HomeScreen(),
//               AllNews(),
//               FavouriteNews(),
//               AccountPage(),
//             ],
//           ),
//         ),
//         bottomNavigationBar: BottomNavyBar(
//           selectedIndex: _selectedIndex,
//           showElevation: true, // use this to remove appBar's elevation
//           onItemSelected: (index) => setState(() {
//             _pageController.jumpToPage(index);
//           }),
//           items: [
//             BottomNavyBarItem(
//                 icon: const Icon(Icons.home_rounded),
//                 title: const Text('Home'),
//                 activeColor: Colors.green,
//                 inactiveColor: const Color.fromARGB(255, 179, 75, 75)),
//             BottomNavyBarItem(
//               icon: const Icon(Icons.bar_chart_rounded),
//               title: const Text('All Courses'),
//               inactiveColor: Colors.grey[500],
//               activeColor: Colors.green,
//             ),
//             BottomNavyBarItem(
//               icon: const Icon(Icons.favorite_outline_rounded),
//               title: const Text('Favourite'),
//               inactiveColor: Colors.grey[500],
//               activeColor: Colors.green,
//             ),
//             BottomNavyBarItem(
//               icon: const Icon(Icons.person_outline_rounded),
//               title: const Text('Account'),
//               inactiveColor: Colors.grey[500],
//               activeColor: Colors.green,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
