import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sportsnews/ads_helper/ads_helper.dart';
import 'package:sportsnews/providers/theme_provider.dart';
import 'package:sportsnews/screens/contact_us.dart';
import 'package:sportsnews/screens/privacy_policy.dart';
import 'package:sportsnews/services/utils.dart';
import 'package:sportsnews/widgets/setting_item.dart';
import 'package:provider/provider.dart';
import 'package:sportsnews/widgets/twittter_embed.dart';

import '../consts/global_colors.dart';

const int maxFailedLoadAttempts = 3;

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  //ads
  int _interstitialLoadAttempts = 0;

  InterstitialAd? _interstitialAd;

  late BannerAd _bottomBannerAd;

  bool _isBottomBannerAdLoaded = false;

  // // Banner Ad
  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(onAdLoaded: (_) {
        setState(() {
          _isBottomBannerAdLoaded = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        ad.dispose();
      }),
    );
    _bottomBannerAd.load();
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
    _createBottomBannerAd();
    _createInterstitialAd();
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();

    _interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    // bool isDarkMode = themeProvider.getDarkTheme;

    //statusbar
    return CustomScrollView(
      slivers: <Widget>[
        // SliverAppBar(
        //     backgroundColor: ,
        //     pinned: true,
        //     snap: true,
        //     floating: true,
        //     title: getHeader()),
        SliverToBoxAdapter(child: getBody())
      ],
    );
  }

  getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "Account",
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget getBody() {
    final themeProvider = Provider.of<ThemeProvider>(context);

    bool isDarkMode = themeProvider.getDarkTheme;
    final Color color = Utils(context).getColor;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          Column(
            children: [
              // CustomImage(
              //   profile["image"]!,
              //   width: 100,
              //   height: 70,
              //   radius: 20,
              // ),
              Card(
                //color: Colors.green,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: isDarkMode
                            ? Theme.of(context).scaffoldBackgroundColor
                            : const Color.fromARGB(255, 5, 51, 84),
                        image: const DecorationImage(
                          image: AssetImage('assets/png/logo.png'),
                          fit: BoxFit.cover,
                        )),
                    // child: ClipRRect(
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                  ),
                ),
              ),

              // Text(
              //   //profile["name"]!
              //   "Sports Caster",
              //   style:
              //       const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              // ),
            ],
          ),

          // ignore: avoid_unnecessary_containers
          // Container(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Expanded(
          //           child: SettingBox(
          //         title: "9 courses",
          //         icon: "assets/icons/work.svg",
          //       )),
          //       SizedBox(
          //         width: 10,
          //       ),
          //       Expanded(
          //           child: SettingBox(
          //         title: "55 hours",
          //         icon: "assets/icons/time.svg",
          //       )),
          //       SizedBox(
          //         width: 10,
          //       ),
          //       Expanded(
          //           child: SettingBox(
          //         title: "4.8",
          //         icon: "assets/icons/star.svg",
          //       )),
          //     ],
          //   ),
          // ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: isDarkMode
                  ? Theme.of(context).scaffoldBackgroundColor
                  : cardColor,
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(children: [
              SettingItem(
                title: "Share to your friends",
                leadingIcon: "assets/icons/share.svg",
                bgIconColor: blue,
                titleColor: color,
                onTap: () {
                  //https://play.google.com/store/apps/details?id=com.seyfert.sportsnews
                  Share.share(
                    'https://play.google.com/store/apps/details?id=com.seyfert.sportsnews',
                    subject: "Check It Out!!!",
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 45),
                child: Divider(
                  height: 0,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              SettingItem(
                title: "Review & Rate us",
                titleColor: color,
                leadingIcon: "assets/icons/star.svg",
                bgIconColor: green,
                onTap: () async {
                  final InAppReview inAppReview = InAppReview.instance;
                  if (await inAppReview.isAvailable()) {
                    inAppReview.requestReview();
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 45),
                child: Divider(
                  height: 0,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              SettingItem(
                title: "Bookmark",
                titleColor: color,
                leadingIcon: "assets/icons/bookmark.svg",
                bgIconColor: primary,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const TwitterEmbedd(twitterId: "51544")));
                },
              ),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: isDarkMode
                  ? Theme.of(context).scaffoldBackgroundColor
                  : cardColor,
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(children: [
              SettingItem(
                title: "Contact Us",
                titleColor: color,
                leadingIcon: "assets/icons/contact.svg",
                bgIconColor: purple,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Contactus()));
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 45),
                child: Divider(
                  height: 0,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              SettingItem(
                title: "Privacy",
                titleColor: color,
                leadingIcon: "assets/icons/shield.svg",
                bgIconColor: orange,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PrivacyPolicy()));
                },
              ),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: isDarkMode
                  ? Theme.of(context).scaffoldBackgroundColor
                  : cardColor,
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(children: [
              SettingItem(
                title: "Exit",
                titleColor: color,
                leadingIcon: "assets/icons/logout.svg",
                bgIconColor: darker,
                onTap: () {
                  _showInterstitialAd();
                  SystemNavigator.pop();
                },
              ),
            ]),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              child: _isBottomBannerAdLoaded
                  ? Container(
                      alignment: Alignment.center,
                      height: _bottomBannerAd.size.height.toDouble(),
                      width: _bottomBannerAd.size.width.toDouble(),
                      child: AdWidget(ad: _bottomBannerAd),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
