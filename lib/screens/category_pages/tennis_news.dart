import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sportsnews/ads_helper/ads_helper.dart';
import 'package:sportsnews/models/news_model.dart';
import 'package:sportsnews/providers/news_provider.dart';
import 'package:sportsnews/providers/tennis_news_provider.dart';
import 'package:sportsnews/services/utils.dart';
import 'package:sportsnews/widgets/articles_widget.dart';
import 'package:sportsnews/widgets/empty_screen.dart';
import 'package:sportsnews/widgets/listview_loadingwidget.dart';
import 'package:sportsnews/widgets/tennis_article.widget.dart';
import 'package:sportsnews/widgets/vertical_spacing.dart';

class TennisNews extends StatefulWidget {
  const TennisNews({super.key});

  @override
  State<TennisNews> createState() => _TennisNewsState();
}

class _TennisNewsState extends State<TennisNews> {
  int currentPageIndex = 0;
  int perPage = 4;
  int futureBuilderItemCount = 0;

  ScrollController _scrollController = ScrollController();

  final adPosition = 2;
  late BannerAd _inlineBannerAd;
  bool _isInlineBannerAdLoaded = false;

  //inline Ad
  void _createInlineBannerAd() {
    _inlineBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.mediumRectangle,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isInlineBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _inlineBannerAd.load();
  }

  @override
  void initState() {
    super.initState();

    _createInlineBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
    _inlineBannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).getColor;
    Size size = Utils(context).getScreenSize;
    final newsProvider = Provider.of<TennisNewsProvider>(context);
    int totalItemsListLength = newsProvider.newsList.length;

    int ItemCount = (totalItemsListLength / perPage).ceil();
    ItemCount = ItemCount > 0 ? ItemCount : 1;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: color),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          'All News',
          style: GoogleFonts.lobster(
              textStyle:
                  TextStyle(color: color, fontSize: 20, letterSpacing: 0.6)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          children: [
            //pagintion
            SizedBox(
              height: kBottomNavigationBarHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  paginationButtons(
                    text: "Prev",
                    function: () {
                      if (currentPageIndex == 0) {
                        return;
                      }
                      setState(() {
                        currentPageIndex -= 1;
                      });
                      _scrollController.animateTo(
                        currentPageIndex *
                            MediaQuery.of(context).size.width /
                            ItemCount, // replace buttonWidth with the actual width of your button
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  Flexible(
                    flex: 2,
                    child: ListView.builder(
                        controller: _scrollController,
                        //should dynamically change item count
                        itemCount: ItemCount,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              color: currentPageIndex == index
                                  ? Colors.blue
                                  : Theme.of(context).cardColor,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    currentPageIndex = index;
                                  });
                                  _scrollController.animateTo(
                                    index *
                                        MediaQuery.of(context).size.width /
                                        10, // replace buttonWidth with the actual width of your button
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${index + 1}"),
                                )),
                              ),
                            ),
                          );
                        })),
                  ),
                  paginationButtons(
                    text: "Next",
                    function: () {
                      //(currentPageIndex + 1) * perPage >= 50
                      // currentPageIndex == 4
                      if ((currentPageIndex + 1) * perPage >= 50) {
                        return;
                      }

                      setState(() {
                        currentPageIndex += 1;
                      });
                      _scrollController.animateTo(
                        currentPageIndex *
                            MediaQuery.of(context).size.width /
                            ItemCount, // replace buttonWidth with the actual width of your button
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );

                      // print('$currentPageIndex index');
                    },
                  ),
                ],
              ),
            ),
            const VerticalSpacing(10),
            //futureBuilder
            FutureBuilder<List<NewsModel>>(
                future: newsProvider.fetchTennisNews(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListViewLoadingWidget();
                  } else if (snapshot.hasError) {
                    return Expanded(
                      child: EmptyNewsWidget(
                        text: "an error occured ${snapshot.error}",
                        imagePath: 'assets/images/no_news.png',
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
                  //TennisArticlesWidget
                  return Expanded(
                    child: ListView.builder(
                        //(currentPageIndex + 1) * perPage
                        //itemCount: snapshot.data!.length,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (ctx, index) {
                          if (index == adPosition) {
                            // Render the ad widget
                            return Container(
                              padding: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              width: _inlineBannerAd.size.width.toDouble(),
                              height: _inlineBannerAd.size.height.toDouble(),
                              child: AdWidget(ad: _inlineBannerAd),
                            ); // Replace with your ad widget implementation
                          } else {
                            // Calculate the actual index excluding the ad position
                            int actualIndex =
                                index - (index > adPosition ? 1 : 0);

                            if (actualIndex >= (currentPageIndex * perPage) &&
                                actualIndex <
                                    ((currentPageIndex + 1) * perPage)) {
                              // Render the article widget
                              return ChangeNotifierProvider.value(
                                value: snapshot.data![actualIndex],
                                child: const TennisArticlesWidget(
                                    // Rest of your code for rendering articles
                                    ),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          }
                        }),
                  );
                })),
          ],
        ),
      ),
    );
  }
}

//pagination button widget
Widget paginationButtons({required Function function, required String text}) {
  return ElevatedButton(
    onPressed: () {
      function();
    },
    child: Text(text),
    style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        padding: EdgeInsets.all(6),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  );
}
