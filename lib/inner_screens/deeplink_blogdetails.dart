import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportsnews/ads_helper/ads_helper.dart';
import 'package:sportsnews/models/bookmarks_model.dart';
import 'package:cross_file/cross_file.dart';
import 'package:sportsnews/models/news_model.dart';
import 'package:sportsnews/providers/all_news_provider.dart';
import 'package:sportsnews/providers/firebase_dynamic_link.dart';
import 'package:sportsnews/providers/search_news_provider.dart';
import 'package:sportsnews/widgets/twittter_embed.dart';

import '../consts/styles.dart';
import '../providers/bookmarks_provider.dart';
import '../providers/news_provider.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import '../widgets/vertical_spacing.dart';

class DeepLinkNewsDetailsScreen extends StatefulWidget {
  static const routeName = "/DeepLinkNewsDetailsScreen";
  const DeepLinkNewsDetailsScreen({Key? key}) : super(key: key);

  @override
  State<DeepLinkNewsDetailsScreen> createState() =>
      _DeepLinkNewsDetailsScreenState();
}

class _DeepLinkNewsDetailsScreenState extends State<DeepLinkNewsDetailsScreen> {
  //String? publishedAt;
  String? newsId;

  bool _isFavorite = false;
  List<String> _favoriteIds = [];

  NativeAd? _nativeAd1;
  bool isNativeAdLoaded1 = false;
  NativeAd? _nativeAd2;
  bool isNativeAdLoaded2 = false;

  @override
  void didChangeDependencies() {
    //publishedAt = ModalRoute.of(context)!.settings.arguments as String;
    newsId = ModalRoute.of(context)!.settings.arguments as String;

    super.didChangeDependencies();
  }

  Future<void> _getFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteIds = prefs.getStringList('favoriteIds') ?? [];
    });
  }

  void loadNativeAd1() {
    _nativeAd1 = NativeAd(
      adUnitId: AdHelper.nativeAdUnitId,
      factoryId: "listTileMedium",
      listener: NativeAdListener(onAdLoaded: (ad) {
        setState(() {
          isNativeAdLoaded1 = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        _nativeAd1!.dispose();
      }),
      request: const AdRequest(),
    );
    _nativeAd1!.load();
  }

  void loadNativeAd2() {
    _nativeAd2 = NativeAd(
      adUnitId: AdHelper.nativeAdUnitId2,
      factoryId: "listTileMedium",
      listener: NativeAdListener(onAdLoaded: (ad) {
        setState(() {
          isNativeAdLoaded2 = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        _nativeAd2!.dispose();
      }),
      request: const AdRequest(),
    );
    _nativeAd2!.load();
  }

  @override
  void initState() {
    super.initState();

    loadNativeAd1();
    loadNativeAd2();

    // _createInterstitialAd();
  }

  @override
  void dispose() {
    super.dispose();
    //_interstitialAd?.dispose();
    _nativeAd1!.dispose();
    _nativeAd2!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Utils(context).getColor;
    final newsProvider = Provider.of<AllNewsProvider>(context);
    //final bookmarksProvider = Provider.of<BookmarksProvider>(context);

    final currentNews = newsProvider.findById(id: newsId);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: color),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          //"By ${currentNews.authorName}",
          "By ${currentNews.newsId}",
          textAlign: TextAlign.center,
          style: TextStyle(color: color),
        ),
        // leading: IconButton(
        //   icon: Icon(
        //     IconlyLight.arrowLeft,
        //     color: color,
        //   ),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentNews.title,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.chathura(
                    //wordSpacing: 5,
                    //letterSpacing: 2,
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      //fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const VerticalSpacing(25),
                Row(
                  children: [
                    Text(
                      currentNews.dateToShow,
                      style: smallTextStyle,
                    ),
                    const Spacer(),
                    Text(
                      currentNews.readingTimeText,
                      style: smallTextStyle,
                    ),
                  ],
                ),
                const VerticalSpacing(20),
              ],
            ),
          ),
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Hero(
                    tag: currentNews.publishedAt,
                    child: FancyShimmerImage(
                      boxFit: BoxFit.fill,
                      errorWidget: Image.asset('assets/images/empty_image.png'),
                      imageUrl: currentNews.urlToImage,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 10,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          try {
                            //dynamic link
                            String generatedDeepLink =
                                await FirebaseDynamicLinkService
                                    .createDynamicLink(false, currentNews);
                            print(generatedDeepLink);
                            print(currentNews.newsId);
                            // await Share.share(generatedDeepLink,
                            //     subject: 'Look what I made!');

                            //imgesend
                            //image download
                            String url = currentNews.urlToImage;
                            Dio dio = Dio();
                            Response response = await dio.get(
                              url,
                              options:
                                  Options(responseType: ResponseType.bytes),
                            );
                            Directory tempDir = await getTemporaryDirectory();

                            final path = '${tempDir.path}/image.jpg';
                            File file = File(path);
                            file.createSync();
                            file.writeAsBytesSync(response.data);
                            if (file.existsSync() == true) {
                              // await Share.shareXFiles(
                              //   [Xfile(file.path)],

                              // );
                              String subject =
                                  "*${currentNews.content}*\n\n*Read News From here*:-\n\n$generatedDeepLink";
                              await Share.shareXFiles(
                                [XFile(file.path)],
                                text: subject,
                              );
                              // await Share.share('dsdss',
                              //     subject: "helloooooooo");

                              //await Share.shareFiles([path], text: "hello");
                            }

                            //await Share.shareFiles([path], text: "hello");
                          } catch (err) {
                            GlobalMethods.errorDialog(
                                errorMessage: err.toString(), context: context);
                          }
                        },
                        child: Card(
                          elevation: 10,
                          shape: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              IconlyLight.send,
                              size: 28,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                          // await _updateFavorites();

                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          List<String> favoriteIds =
                              prefs.getStringList('favoriteIds') ?? [];
                          setState(() {
                            if (_favoriteIds.contains(currentNews.newsId)) {
                              print("Id already exist");
                              return;
                            }
                            if (_isFavorite) {
                              favoriteIds.add(currentNews.newsId);
                              print("After added : ${favoriteIds.length}");
                            } else {
                              favoriteIds.remove(currentNews.newsId);
                              //  print("After removed : ${favoriteIds.length}");
                            }
                          });

                          await prefs.setStringList('favoriteIds', favoriteIds);
                        },
                        child: Card(
                          elevation: 10,
                          shape: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              _isFavorite
                                  ? IconlyBold.bookmark
                                  : IconlyLight.bookmark,
                              size: 28,
                              color: _isFavorite ? Colors.red : color,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          //native ads
          const VerticalSpacing(20),

          isNativeAdLoaded1
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    height: 265,
                    child: AdWidget(
                      ad: _nativeAd1!,
                    ),
                  ),
                )
              : const SizedBox(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextContent(
                  label: 'Description',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const VerticalSpacing(10),
                TextDescription(
                  label: currentNews.description,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
                currentNews.twitter.isNotEmpty
                    ? SizedBox(
                        height:
                            550, // Adjust the height according to your needs
                        child: TwitterEmbedd(
                          twitterId: currentNews.twitter,
                        ))
                    : SizedBox.shrink(),

                //native ads
                const VerticalSpacing(
                  10,
                ),
                //ads
                isNativeAdLoaded2
                    ? Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        height: 265,
                        child: AdWidget(
                          ad: _nativeAd2!,
                        ),
                      )
                    : const SizedBox(),
                const VerticalSpacing(
                  20,
                ),
                const TextContent(
                  label: 'Contents',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const VerticalSpacing(
                  10,
                ),
                TextContent(
                  label: currentNews.content,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TextDescription extends StatelessWidget {
  const TextDescription({
    Key? key,
    required this.label,
    required this.fontSize,
    required this.fontWeight,
  }) : super(key: key);

  final String label;
  final double fontSize;
  final FontWeight fontWeight;
  @override
  Widget build(BuildContext context) {
    return SelectableText(
      label,
      textAlign: TextAlign.center,
      style: GoogleFonts.roboto(fontSize: fontSize, fontWeight: fontWeight),
    );
  }

  //content
}

class TextContent extends StatelessWidget {
  const TextContent({
    Key? key,
    required this.label,
    required this.fontSize,
    required this.fontWeight,
  }) : super(key: key);

  final String label;
  final double fontSize;
  final FontWeight fontWeight;
  @override
  Widget build(BuildContext context) {
    return SelectableText(
      label,
      textAlign: TextAlign.start,
      style: GoogleFonts.roboto(fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}
