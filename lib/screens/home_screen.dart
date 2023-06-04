import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';

import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sportsnews/consts/global_colors.dart';
import 'package:sportsnews/consts/vars.dart';
import 'package:sportsnews/inner_screens/search_screen.dart';
import 'package:sportsnews/models/main_categories.dart';
import 'package:sportsnews/providers/popular_news_provider.dart';
import 'package:sportsnews/providers/toptrending_provider.dart';
import 'package:sportsnews/screens/all_news.dart';
import 'package:sportsnews/screens/category_pages/all_news.dart';
import 'package:sportsnews/screens/category_pages/cricket_news.dart';
import 'package:sportsnews/screens/category_pages/football.dart';
import 'package:sportsnews/screens/category_pages/other_news.dart';
import 'package:sportsnews/screens/category_pages/tennis_news.dart';
import 'package:sportsnews/services/utils.dart';
import 'package:sportsnews/widgets/category_box.dart';
import 'package:sportsnews/widgets/drawer_widget.dart';
import 'package:sportsnews/widgets/empty_screen.dart';
import 'package:sportsnews/widgets/popular_loadingwidget.dart';
import 'package:sportsnews/widgets/popular_news.dart';
import 'package:sportsnews/widgets/toptrending_loadingwidget.dart';
import 'package:sportsnews/widgets/vertical_spacing.dart';
import 'package:upgrader/upgrader.dart';

import '../models/news_model.dart';
import '../providers/news_provider.dart';
import '../providers/theme_provider.dart';
import '../services/news_api.dart';
import '../widgets/articles_widget.dart';
import '../widgets/tabs.dart';
import '../widgets/top_tending.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var newsType = NewsType.topTrending;
  int currentPageIndex = 0;
  String sortBy = SortByEnum.publishedAt.name;
  final pages = [
    FootballNews(),
    CricketNews(),
    TennisNews(),
    OtherNews(),
    //TestDart(),
  ];
  // void getCachedData() async {
  //   Provider.of<NewsProvider>(context).cachedfetchTopTrendingHeadlines();
  //   setState(() {});
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getCachedData();
    //Provider.of<NewsProvider>(context).cachedfetchTopTrendingHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).getColor;
    final newsProvider = Provider.of<NewsProvider>(context);
    final popularNewsProvider = Provider.of<PopularNewsProvider>(context);
    final topTrendingNewsProvider =
        Provider.of<TopTrendingNewsProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    //statusbar
    bool isDarkMode = themeProvider.getDarkTheme;
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: Theme.of(context).scaffoldBackgroundColor));

    //  FlutterStatusbarcolor.setStatusBarColor(
    //     isDarkMode ? Colors.black : Colors.white,
    //   );

//     await FlutterStatusbarcolor.setStatusBarColor(Colors.green[400]);
// if (useWhiteForeground(Colors.green[400])) {
//   FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
// } else {
//   FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
// }
    return Scaffold(
      //Theme.of(context).scaffoldBackgroundColor));
      // resizeToAvoidBottomInset: true,
      // appBar: AppBar(
      //   iconTheme: IconThemeData(color: color),
      //   elevation: 0,
      //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //   centerTitle: true,
      //   title: Text(
      //     'Sports News',
      //     style: GoogleFonts.lobster(
      //         textStyle:
      //             TextStyle(color: color, fontSize: 20, letterSpacing: 0.6)),
      //   ),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           PageTransition(
      //               type: PageTransitionType.rightToLeft,
      //               child: const SearchScreen(),
      //               inheritTheme: true,
      //               ctx: context),
      //         );
      //       },
      //       icon: const Icon(
      //         IconlyLight.search,
      //       ),
      //     )
      //   ],
      // ),
      // drawer: const DrawerWidget(),
      body: UpgradeAlert(
        upgrader: Upgrader(
          shouldPopScope: () => true,
          canDismissDialog: true,
          durationUntilAlertAgain: const Duration(hours: 1),
          dialogStyle: Platform.isIOS
              ? UpgradeDialogStyle.cupertino
              : UpgradeDialogStyle.material,
        ),
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //categories
            getCategories(),
            const SizedBox(
              height: 5,
            ),
            //top trening
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
              child: Text(
                "Top Trending",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            // getFeature(),
            FutureBuilder<List<NewsModel>>(
                future: topTrendingNewsProvider.fetchToptrendingNews(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: size.height * 0.36,
                      child: TopTrendingLoadingWidget(),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                      height: 200,
                      width: size.width,
                      child: const Expanded(
                        child: Center(child: CircularProgressIndicator()),

                        // EmptyNewsWidget(
                        //   text: "an error occured ${snapshot.error}",
                        //   imagePath: 'assets/images/no_news.png',
                        // ),
                      ),
                    );
                  } else if (snapshot.data == null) {
                    return const Expanded(
                      child: EmptyNewsWidget(
                        text: "No news found",
                        imagePath: 'assets/images/no_news.png',
                      ),
                    );
                  }
                  return SizedBox(
                    height: size.height * 0.36,
                    child: Swiper(
                      autoplayDelay: 8000,
                      autoplay: true,
                      itemWidth: size.width * 0.9,
                      layout: SwiperLayout.STACK,
                      viewportFraction: 0.9,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                          value: snapshot.data![index],
                          child: const TopTrendingWidget(
                              // url: snapshot.data![index].url,
                              ),
                        );
                      },
                    ),
                  );
                })),
            const SizedBox(
              height: 5,
            ),
            Container(
              //margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular News",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: color),
                    ),
                    Text(
                      "See all",
                      style: TextStyle(fontSize: 14, color: color),
                    ),
                  ],
                ),
              ),
            ),
            // popular
            // get popular,
            FutureBuilder<List<NewsModel>>(
                future: popularNewsProvider.fetchPopularNews(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return PopularLoadingWidget();
                  } else if (snapshot.hasError) {
                    return Container(
                      height: 200,
                      width: size.width,
                      child: Expanded(
                          child: Center(child: CircularProgressIndicator())

                          //  EmptyNewsWidget(
                          //   text: "an error occured ${snapshot.error}",
                          //   imagePath: 'assets/images/no_news.png',
                          // ),
                          ),
                    );
                  } else if (snapshot.data == null) {
                    return const Expanded(
                      child: EmptyNewsWidget(
                        text: "No news found",
                        imagePath: 'assets/images/no_news.png',
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 5, right: 10),
                    child: SizedBox(
                      height: 220,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (ctx, index) {
                            return ChangeNotifierProvider.value(
                              value: snapshot.data![index],
                              child: const PopularNews(),
                            );
                          }),
                    ),
                  );
                }))
          ],
        ),
      ),
    );
  }

  // //build body
  // buildBody(BuildContext context, Size size, NewsProvider newsProvider) {
  //   return SingleChildScrollView(
  //     child: Padding(
  //       padding: const EdgeInsets.only(top: 10, bottom: 10),
  //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //         getCategories(),
  //         const SizedBox(
  //           height: 15,
  //         ),
  //         const Padding(
  //           padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
  //           child: Text("Featured",
  //               style: TextStyle(
  //                 color: textColor,
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: 24,
  //               )),
  //         ),
  //         //getFeature(),
  //         FutureBuilder<List<NewsModel>>(
  //             future: newsProvider.fetchTopHeadlines(),
  //             builder: ((context, snapshot) {
  //               if (snapshot.connectionState == ConnectionState.waiting) {
  //                 return const Expanded(
  //                   child: TopTrendingLoadingWidget(),
  //                 );
  //               } else if (snapshot.hasError) {
  //                 return Expanded(
  //                   child: EmptyNewsWidget(
  //                     text: "an error occured ${snapshot.error}",
  //                     imagePath: 'assets/images/no_news.png',
  //                   ),
  //                 );
  //               } else if (snapshot.data == null) {
  //                 return const Expanded(
  //                   child: EmptyNewsWidget(
  //                     text: "No news found",
  //                     imagePath: 'assets/images/no_news.png',
  //                   ),
  //                 );
  //               }
  //               return SizedBox(
  //                 height: size.height * 0.5,
  //                 child: Swiper(
  //                   autoplayDelay: 8000,
  //                   autoplay: true,
  //                   itemWidth: size.width * 0.9,
  //                   layout: SwiperLayout.STACK,
  //                   viewportFraction: 0.9,
  //                   itemCount: 5,
  //                   itemBuilder: (context, index) {
  //                     return ChangeNotifierProvider.value(
  //                       value: snapshot.data![index],
  //                       child: const TopTrendingWidget(
  //                           // url: snapshot.data![index].url,
  //                           ),
  //                     );
  //                   },
  //                 ),
  //               );
  //             })),
  //         const SizedBox(
  //           height: 15,
  //         ),
  //         Container(
  //           margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: const [
  //               Text(
  //                 "Popular News",
  //                 style: TextStyle(
  //                     fontSize: 22,
  //                     fontWeight: FontWeight.w600,
  //                     color: textColor),
  //               ),
  //               Text(
  //                 "See all",
  //                 style: TextStyle(fontSize: 14, color: darker),
  //               ),
  //             ],
  //           ),
  //         ),
  //         // get popular,
  //         FutureBuilder<List<NewsModel>>(
  //             future: newsProvider.fetchTopHeadlines(),
  //             builder: ((context, snapshot) {
  //               if (snapshot.connectionState == ConnectionState.waiting) {
  //                 return const Expanded(
  //                   child: PopularLoadingWidget(),
  //                 );
  //               } else if (snapshot.hasError) {
  //                 return Expanded(
  //                   child: EmptyNewsWidget(
  //                     text: "an error occured ${snapshot.error}",
  //                     imagePath: 'assets/images/no_news.png',
  //                   ),
  //                 );
  //               } else if (snapshot.data == null) {
  //                 return const Expanded(
  //                   child: EmptyNewsWidget(
  //                     text: "No news found",
  //                     imagePath: 'assets/images/no_news.png',
  //                   ),
  //                 );
  //               }
  //               return Expanded(
  //                 child: ListView.builder(
  //                     scrollDirection: Axis.horizontal,
  //                     itemCount: snapshot.data!.length,
  //                     itemBuilder: (ctx, index) {
  //                       return ChangeNotifierProvider.value(
  //                         value: snapshot.data![index],
  //                         child: const PopularNews(),
  //                       );
  //                     }),
  //               );
  //             }))
  //       ]),
  //     ),
  //   );
  // }

  //getcat
  int selectedCollection = 0;
  getCategories() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
      scrollDirection: Axis.horizontal,
      child: Row(
          children: List.generate(
              allCategories.length,
              (index) => Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: CategoryBox(
                    selectedColor: Colors.white,
                    data: allCategories[index],
                    onTap: () {
                      setState(() {
                        selectedCollection = index;
                      });
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => pages[index],
                        ),
                      );
                    },
                  )))),
    );
  }

  // getFeature() {
  //   return
  // }

  List<DropdownMenuItem<String>> get dropDownItems {
    List<DropdownMenuItem<String>> menuItem = [
      DropdownMenuItem(
        value: SortByEnum.relevancy.name,
        child: Text(SortByEnum.relevancy.name),
      ),
      DropdownMenuItem(
        value: SortByEnum.publishedAt.name,
        child: Text(SortByEnum.publishedAt.name),
      ),
      DropdownMenuItem(
        value: SortByEnum.popularity.name,
        child: Text(SortByEnum.popularity.name),
      ),
    ];
    return menuItem;
  }

  Widget paginationButtons({required Function function, required String text}) {
    return ElevatedButton(
      onPressed: () {
        function();
      },
      child: Text(text),
      style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          padding: EdgeInsets.all(6),
          textStyle:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
