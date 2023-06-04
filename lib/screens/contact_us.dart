import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sportsnews/ads_helper/ads_helper.dart';
import 'package:sportsnews/consts/global_colors.dart';

class Contactus extends StatefulWidget {
  const Contactus({Key? key}) : super(key: key);

  @override
  State<Contactus> createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {
  NativeAd? _nativeAd;
  bool isNativeAdLoaded = false;

  //loadNative Ad
  void loadNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: AdHelper.nativeAdUnitId,
      factoryId: "listTileMedium",
      listener: NativeAdListener(onAdLoaded: (ad) {
        setState(() {
          isNativeAdLoaded = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        _nativeAd!.dispose();
      }),
      request: const AdRequest(),
    );
    _nativeAd!.load();
  }

  @override
  void initState() {
    super.initState();
    loadNativeAd();
  }

  @override
  void dispose() {
    super.dispose();
    // _bottomBannerAd.dispose();
    _nativeAd!.dispose();
    // _interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: const Text(
          "Contact",
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
        children: [
          // Container(
          //   height: 200.0,
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage('assets/images/contact_banner.png'),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Contact Options',
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email'),
                  subtitle: const Text('seyfertsoftndtech@gmail.com'),
                  onTap: () {
                    // Add code to handle email contact option
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('Phone Number'),
                  subtitle: const Text('(123) 456-7890'),
                  onTap: () {
                    // Add code to handle phone number contact option
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text('Address'),
                  subtitle: const Text('Malappuram, Manjeri, 676122'),
                  onTap: () {
                    // Add code to handle address contact option
                  },
                ),
                const Divider(),
                //ad section

                isNativeAdLoaded
                    ? Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          height: 265,
                          child: AdWidget(
                            ad: _nativeAd!,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Thank you for contacting us!',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            ),
          ),
        ],
      ),
    );
  }
}

//https://docs.google.com/document/d/e/2PACX-1vR1ML_IrNP6zLC_skdF1F5Fj_oKtdUDZUZLLBaCND6RGt84_9913edRUypDkirLJ8cL5tn2ZOgCt7zH/pub
