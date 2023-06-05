import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportsnews/models/bookmarks_model.dart';
import 'package:sportsnews/models/news_model.dart';
import 'package:sportsnews/providers/firebase_dynamic_link.dart';
import 'package:sportsnews/widgets/twittter_embed.dart';

import '../consts/styles.dart';
import '../providers/bookmarks_provider.dart';
import '../providers/news_provider.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import '../widgets/vertical_spacing.dart';

class NewsDetailsScreen extends StatefulWidget {
  static const routeName = "/NewsDetailsScreen";
  const NewsDetailsScreen({Key? key}) : super(key: key);

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  bool _isFavorite = false;
  List<String> _favoriteIds = [];
  //bool isInBookmark = false;
  //String? publishedAt;
  String? newsId;
  //dynamic currBookmark;
  @override
  void didChangeDependencies() {
    newsId = ModalRoute.of(context)!.settings.arguments as String;
    //Provider.of<NewsProvider>(context, listen: false).newsList.clear();
    super.didChangeDependencies();
  }

  Future<void> _getFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteIds = prefs.getStringList('favoriteIds') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    // final Map<String, dynamic> args =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // String argumentID = args['argumentID'];
    // String argumentDate = args['argumentDate'];
    // //
    final color = Utils(context).getColor;
    final newsProvider = Provider.of<NewsProvider>(context);
    //final publishedAt = ModalRoute.of(context)!.settings.arguments as String;
    //final currentNews = newsProvider.findByDate(publishedAt: publishedAt);
    //final newsId = ModalRoute.of(context)!.settings.arguments as String;
    final currentNews = newsProvider.findById(id: newsId);

    // final currentNews = newsId == null
    //   ? newsProvider.findByDate(publishedAt: publishedAt)
    //   : newsProvider.findById(id: newsId);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: color),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          "By ${currentNews.authorName}",
          //"By ${currentNews.newsId}",
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
                            // await Share.share(currentNews.url,

                            //     subject: 'Look what I made!');
                            String generatedDeepLink =
                                await FirebaseDynamicLinkService
                                    .createDynamicLink(false, currentNews);
                            print(generatedDeepLink);
                            print(currentNews.newsId);
                            await Share.share(generatedDeepLink,
                                subject: 'Look what I made!');
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
          const VerticalSpacing(20),
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
                const VerticalSpacing(
                  10,
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

  //update fav
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

  //content
}
