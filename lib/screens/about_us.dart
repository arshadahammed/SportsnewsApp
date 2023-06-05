import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sportsnews/ads_helper/ads_helper.dart';
import 'package:sportsnews/consts/global_colors.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  //late var url;
  //var initialUrl =
  //  "https://docs.google.com/document/d/e/2PACX-1vR1ML_IrNP6zLC_skdF1F5Fj_oKtdUDZUZLLBaCND6RGt84_9913edRUypDkirLJ8cL5tn2ZOgCt7zH/pub";
  // double progress = 0;
  // var isLoading = false;
  //ad section
  //varibles
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

  @override
  void initState() {
    super.initState();
    _createBottomBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: const Text(
          "About Us",
          style: TextStyle(
            color: textColor,
          ),
        ),
        iconTheme: const IconThemeData(color: textColor),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          //heading
          // Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: Text(
          //     "     Privacy Policy     ",
          //     style: TextStyle(
          //         decoration: TextDecoration.underline,
          //         fontSize: 18,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.red),
          //   ),
          // ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: Text(
              "Introducing Sports Caster, the ultimate sports news app that brings you all the excitement and updates from the world of cricket, football, tennis, and beyond. Stay ahead of the game with our comprehensive coverage, expert analysis, and real-time notifications.With Sports Caster, you'll never miss a beat as we deliver breaking news, match schedules, and live scores right to your fingertips. From thrilling cricket matches to intense football rivalries, and epic tennis showdowns, we've got you covered with up-to-the-minute updates.Personalize your experience by choosing your favorite sports, teams, and players to receive tailored news and highlights. Dive deep intthe game with in-depth articles",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _isBottomBannerAdLoaded
          ? Container(
              alignment: Alignment.center,
              height: _bottomBannerAd.size.height.toDouble(),
              width: _bottomBannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bottomBannerAd),
            )
          : null,
    );
  }
}
