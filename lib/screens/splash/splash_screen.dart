import "package:flutter/material.dart";
import 'package:sportsnews/ads_helper/app_open_admanager.dart';
import 'package:sportsnews/providers/theme_provider.dart';
import "package:sportsnews/screens/main_homescreen.dart";
import 'package:sportsnews/providers/all_news_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  @override
  void initState() {
    appOpenAdManager.loadAd();
    //set time to load the new page
    // Future.delayed(const Duration(seconds: 4), () {
    //   //appOpenAdManager.showAdIfAvailable();
    //   // Navigator.pushReplacement(
    //   //     context,
    //   //     MaterialPageRoute(
    //   //       builder: (context) => MainHomeScreen(),
    //   //     ));
    // });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.getDarkTheme;

    final dataProvider = Provider.of<AllNewsProvider>(context, listen: false);

    // Fetch data when the SplashScreen widget is built
    dataProvider.fetchAllNews().then((_) {
      // Data fetched, navigate to the next screen

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainHomeScreen(),
        ),
      );
      appOpenAdManager.showAdIfAvailable();

      // Future.delayed(Duration(seconds: 2), () {
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(
      //       builder: (context) => MainHomeScreen(),
      //     ),
      //   );
      //appOpenAdManager.showAdIfAvailable();

      // });
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/png/logo2.png'),
                      fit: BoxFit.cover)),
            ),
            // const SizedBox(height: 10),
            // const Text(
            //   "The Essence of Dairy Farming",
            //   style: TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.bold,
            //     color: Color.fromARGB(255, 6, 141, 10),
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Theme.of(context).scaffoldBackgroundColor,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Powered by ",
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const Text(
              "SeyFert Soft&Tech",
              style: TextStyle(
                  color: Color.fromARGB(255, 13, 70, 116),
                  fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
