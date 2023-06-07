import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sportsnews/ads_helper/ads_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportsnews/models/news_model.dart';
import 'package:sportsnews/providers/news_provider.dart';
import 'package:sportsnews/widgets/articles_widget.dart';
import 'package:sportsnews/widgets/empty_screen.dart';
import 'package:sportsnews/widgets/listview_loadingwidget.dart';
import 'package:sportsnews/widgets/vertical_spacing.dart';

const int maxFailedLoadAttempts = 3;

class FavouriteNews extends StatefulWidget {
  const FavouriteNews({super.key});

  @override
  State<FavouriteNews> createState() => _FavouriteNewsState();
}

class _FavouriteNewsState extends State<FavouriteNews> {
  int currentPageIndex = 0;
  int perPage = 3;
  int futureBuilderItemCount = 0;

  final ScrollController _scrollController = ScrollController();

  List<String> _favoriteIds = [];
  bool isListEmpty = false;

  int _interstitialLoadAttempts = 0;

  InterstitialAd? _interstitialAd;

  //inline
  //ads
  final adPosition = 0;
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

  //favourite

  Future<void> _getFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteIds = prefs.getStringList('favoriteIds') ?? [];
    });
  }

  Future<void> _clearFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteIds = prefs.getStringList('favoriteIds') ?? [];
    });

    await prefs.remove('favoriteIds');
    setState(() {
      _favoriteIds = [];
    });
  }

  //intrestial
  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback:
            InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
        }, onAdFailedToLoad: (LoadAdError error) {
          _interstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_interstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        }));
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _createInterstitialAd();
      }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _createInterstitialAd();
      });
      _interstitialAd!.show();
    }
  }

  @override
  void initState() {
    super.initState();
    _getFavorites();
    _createInlineBannerAd();
    _createInterstitialAd();
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
    _inlineBannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    int totalItemsListLength = newsProvider.newsList.length;

    // ignore: non_constant_identifier_names
    int ItemCount = (totalItemsListLength / perPage).ceil();
    ItemCount = ItemCount > 0 ? ItemCount : 1;

    return Scaffold(
      // appBar: AppBar(
      //   iconTheme: IconThemeData(color: color),
      //   elevation: 0,
      //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //   centerTitle: true,
      //   title: Text(
      //     'All News',
      //     style: GoogleFonts.lobster(
      //         textStyle:
      //             TextStyle(color: color, fontSize: 20, letterSpacing: 0.6)),
      //   ),
      // ),
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
                        duration: const Duration(milliseconds: 500),
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
                                    duration: const Duration(milliseconds: 500),
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
                        duration: const Duration(milliseconds: 500),
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
                future: newsProvider.cachedfetchFavouriteNews(),
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
                  } else if (snapshot.data!.isEmpty) {
                    return const Expanded(
                      child: EmptyNewsWidget(
                        text: "No news found",
                        imagePath: 'assets/images/no_news.png',
                      ),
                    );
                  }
                  //ArticlesWidget
                  return Expanded(
                    child: ListView.builder(
                        //(currentPageIndex + 1) * perPage
                        //itemCount: snapshot.data!.length,
                        itemCount: snapshot.data!.length + 1,
                        itemBuilder: (ctx, index) {
                          if (index == adPosition && _isInlineBannerAdLoaded) {
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
                                child: const ArticlesWidget(
                                    // Rest of your code for rendering articles
                                    ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }
                        }),
                  );
                })),
          ],
        ),
      ),
      floatingActionButton: _favoriteIds.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                // Add your button's action here
                _showInterstitialAd();
                _clearFavorites();
                // print('Button pressed!');
              },
              child: const Icon(Icons.clear),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

//pagination button widget
Widget paginationButtons({required Function function, required String text}) {
  return ElevatedButton(
    onPressed: () {
      function();
    },
    style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.all(6),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    child: Text(text),
  );
}
