// import 'package:dairyfarm_guide/ads_helper/ads_helper.dart';
// import 'package:dairyfarm_guide/models/course_details.dart';
// import 'package:dairyfarm_guide/screens/youtube_screen.dart';
// import 'package:dairyfarm_guide/theme/color.dart';
// import 'package:dairyfarm_guide/widgets/lesson_item.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class AllLessons extends StatefulWidget {
//   final Courses data;
//   const AllLessons({super.key, required this.data});

//   @override
//   State<AllLessons> createState() => _AllLessonsState();
// }

// class _AllLessonsState extends State<AllLessons> {
//   late Courses courseData;
//   final _inlineAdIndex = 2;
//   late BannerAd _inlineBannerAd;
//   bool _isInlineBannerAdLoaded = false;

//   //inline Ad
//   void _createInlineBannerAd() {
//     _inlineBannerAd = BannerAd(
//       adUnitId: AdHelper.bannerAdUnitId,
//       size: AdSize.mediumRectangle,
//       request: const AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (_) {
//           setState(() {
//             _isInlineBannerAdLoaded = true;
//           });
//         },
//         onAdFailedToLoad: (ad, error) {
//           ad.dispose();
//         },
//       ),
//     );
//     _inlineBannerAd.load();
//   }

//   int _getListViewItemIndex(int index) {
//     if (index >= _inlineAdIndex && _isInlineBannerAdLoaded) {
//       return index - 1;
//     }
//     return index;
//   }

//   @override
//   void initState() {
//     super.initState();
//     courseData = widget.data;
//     _createInlineBannerAd();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _inlineBannerAd.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: appBarColor,
//           centerTitle: true,
//           title: const Text(
//             "All lessons",
//             style: TextStyle(
//               color: textColor,
//             ),
//           ),
//           iconTheme: const IconThemeData(color: textColor),
//           leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             color: Colors.black,
//             icon: const Icon(Icons.arrow_back_ios),
//           ),
//         ),
//         body: getLessons());
//   }

//   Widget getLessons() {
//     return ListView.builder(
//         itemCount:
//             courseData.lessons.length + (_isInlineBannerAdLoaded ? 1 : 0),
//         itemBuilder: (context, index) {
//           if (_isInlineBannerAdLoaded && index == _inlineAdIndex) {
//             return Container(
//               padding: const EdgeInsets.only(
//                 bottom: 10,
//               ),
//               width: _inlineBannerAd.size.width.toDouble(),
//               height: _inlineBannerAd.size.height.toDouble(),
//               child: AdWidget(ad: _inlineBannerAd),
//             );
//           }
//           return GestureDetector(
//             onTap: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => YoutubeVideoScreen(
//                     youtubeLink: courseData
//                         .lessons[_getListViewItemIndex(index)].video_url,
//                   ),
//                 ),
//               );
//             },
//             child: LessonItem(
//               data: courseData.lessons[_getListViewItemIndex(index)],
//             ),
//           );
//         });
//   }
// }





//all news



// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:provider/provider.dart';
// import 'package:sportsnews/ads_helper/ads_helper.dart';
// import 'package:sportsnews/models/news_model.dart';
// import 'package:sportsnews/providers/all_news_provider.dart';
// import 'package:sportsnews/providers/news_provider.dart';
// import 'package:sportsnews/services/utils.dart';
// import 'package:sportsnews/widgets/articles_widget.dart';
// import 'package:sportsnews/widgets/empty_screen.dart';
// import 'package:sportsnews/widgets/listview_loadingwidget.dart';
// import 'package:sportsnews/widgets/vertical_spacing.dart';

// class AllCategoryNews extends StatefulWidget {
//   const AllCategoryNews({super.key});

//   @override
//   State<AllCategoryNews> createState() => _AllCategoryNewsState();
// }

// class _AllCategoryNewsState extends State<AllCategoryNews> {
//   int currentPageIndex = 0;
//   int perPage = 6;
//   int futureBuilderItemCount = 0;

  

//   ScrollController _scrollController = ScrollController();


//   //ads 
//   final _inlineAdIndex = 2;
//   late BannerAd _inlineBannerAd;
//   bool _isInlineBannerAdLoaded = false;
  

//     //inline Ad
//   void _createInlineBannerAd() {
//     _inlineBannerAd = BannerAd(
//       adUnitId: AdHelper.bannerAdUnitId,
//       size: AdSize.mediumRectangle,
//       request: const AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (_) {
//           setState(() {
//             _isInlineBannerAdLoaded = true;
//           });
//         },
//         onAdFailedToLoad: (ad, error) {
//           ad.dispose();
//         },
//       ),
//     );
//     _inlineBannerAd.load();
//   }

//   int _getListViewItemIndex(int index) {
//     if (index >= _inlineAdIndex && _isInlineBannerAdLoaded) {
//       return index - 1;
//     }
//     return index;
//   }

//   @override
//   void initState() {
//     super.initState();
  
//     _createInlineBannerAd();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _inlineBannerAd.dispose();
//   }



//   @override
//   Widget build(BuildContext context) {
//     final Color color = Utils(context).getColor;
//     Size size = Utils(context).getScreenSize;
//     final allNewsProvider = Provider.of<AllNewsProvider>(context);
//     int totalItemsListLength = allNewsProvider.newsList.length;

//     int ItemCount = (totalItemsListLength / perPage).ceil();
//     ItemCount = ItemCount > 0 ? ItemCount : 1;
//     return Scaffold(
//       // appBar: AppBar(
//       //   iconTheme: IconThemeData(color: color),
//       //   elevation:
//       //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       //   centerTitle: true,
//       //   title: Text(
//       //     'All News',
//       //     style: GoogleFonts.lobster(
//       //         textStyle:
//       //             TextStyle(color: color, fontSize: 20, letterSpacing: 0.6)),
//       //   ),
//       // ),
//       body: Padding(
//         padding: const EdgeInsets.only(left: 8, right: 8),
//         child: Column(
//           children: [
//             //pagintion
//             SizedBox(
//               height: kBottomNavigationBarHeight,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   paginationButtons(
//                     text: "Prev",
//                     function: () {
//                       if (currentPageIndex == 0) {
//                         return;
//                       }
//                       setState(() {
//                         currentPageIndex -= 1;
//                       });
//                       _scrollController.animateTo(
//                         currentPageIndex *
//                             MediaQuery.of(context).size.width /
//                             ItemCount, // replace buttonWidth with the actual width of your button
//                         duration: Duration(milliseconds: 500),
//                         curve: Curves.easeInOut,
//                       );
//                     },
//                   ),
//                   Flexible(
//                     flex: 2,
//                     child: ListView.builder(
//                         controller: _scrollController,
//                         //should dynamically change item count
//                         itemCount: ItemCount,
//                         scrollDirection: Axis.horizontal,
//                         itemBuilder: ((context, index) {
//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Material(
//                               color: currentPageIndex == index
//                                   ? Colors.blue
//                                   : Theme.of(context).cardColor,
//                               child: InkWell(
//                                 onTap: () {
//                                   setState(() {
//                                     currentPageIndex = index;
//                                   });
//                                   _scrollController.animateTo(
//                                     index *
//                                         MediaQuery.of(context).size.width /
//                                         10, // replace buttonWidth with the actual width of your button
//                                     duration: Duration(milliseconds: 500),
//                                     curve: Curves.easeInOut,
//                                   );
//                                 },
//                                 child: Center(
//                                     child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text("${index + 1}"),
//                                 )),
//                               ),
//                             ),
//                           );
//                         })),
//                   ),
//                   paginationButtons(
//                     text: "Next",
//                     function: () {
//                       //(currentPageIndex + 1) * perPage >= 50
//                       // currentPageIndex == 4
//                       if ((currentPageIndex + 1) * perPage >= 50) {
//                         return;
//                       }

//                       setState(() {
//                         currentPageIndex += 1;
//                       });
//                       _scrollController.animateTo(
//                         currentPageIndex *
//                             MediaQuery.of(context).size.width /
//                             ItemCount, // replace buttonWidth with the actual width of your button
//                         duration: Duration(milliseconds: 500),
//                         curve: Curves.easeInOut,
//                       );

//                       // print('$currentPageIndex index');
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const VerticalSpacing(10),
//             //futureBuilder
//             FutureBuilder<List<NewsModel>>(
//                 future: allNewsProvider.fetchAllNews(),
//                 builder: ((context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const ListViewLoadingWidget();
//                   } else if (snapshot.hasError) {
//                     return Expanded(
//                       child: EmptyNewsWidget(
//                         text: "an error occured ${snapshot.error}",
//                         imagePath: 'assets/images/no_news.png',
//                       ),
//                     );
//                   } else if (snapshot.data == null) {
//                     return const Expanded(
//                       child: EmptyNewsWidget(
//                         text: "No news found",
//                         imagePath: 'assets/images/no_news.png',
//                       ),
//                     );
//                   }
//                   return Expanded(
//                     child: ListView.builder(
//                         //(currentPageIndex + 1) * perPage
//                         //itemCount: snapshot.data!.length,
//                         itemCount: snapshot.data!.length,
//                         itemBuilder: (ctx, index) {
//                           if (index >= (currentPageIndex * perPage) &&
//                               index < ((currentPageIndex + 1) * perPage)) {
//                             return ChangeNotifierProvider.value(
//                               value: snapshot.data![index],
//                               child: const ArticlesWidget(
//                                   // imageUrl: snapshot.data![index].,
//                                   // dateToShow: snapshot.data![index].dateToShow,
//                                   // readingTime:
//                                   //     snapshot.data![index].readingTimeText,
//                                   // title: snapshot.data![index].title,
//                                   // url: snapshot.data![index].url,
//                                   ),
//                             );
//                           } else {
//                             // Show an empty SizedBox to keep the ListView height consistent
//                             return SizedBox.shrink();
//                           }
//                         }),
//                   );
//                 })),
//           ],
//         ),
//       ),
//     );
//   }
// }

// //pagination button widget
// Widget paginationButtons({required Function function, required String text}) {
//   return ElevatedButton(
//     onPressed: () {
//       function();
//     },
//     child: Text(text),
//     style: ElevatedButton.styleFrom(
//         primary: Colors.blue,
//         padding: EdgeInsets.all(6),
//         textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//   );
// }
