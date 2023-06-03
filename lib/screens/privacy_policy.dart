import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sportsnews/ads_helper/ads_helper.dart';
import 'package:sportsnews/consts/global_colors.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
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
          "Privacy Policy",
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
              "Seyfert Soft&Tech built the The Essence of Dairy Farming app as a Free app. This SERVICE is provided by Seyfert Soft&Tech at no cost and is intended for use as is.This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at The Essence of Dairy Farming app unless otherwise defined in this Privacy Policy.",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: _isBottomBannerAdLoaded
      //     ? Container(
      //         alignment: Alignment.center,
      //         height: _bottomBannerAd.size.height.toDouble(),
      //         width: _bottomBannerAd.size.width.toDouble(),
      //        // child: AdWidget(ad: _bottomBannerAd),
      //       )
      //     : null,
    );
  }
}
