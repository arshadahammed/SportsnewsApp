import "package:flutter/material.dart";
import "package:sportsnews/screens/main_homescreen.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ///AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  @override
  void initState() {
    // appOpenAdManager.loadAd();
    //set time to load the new page
    Future.delayed(const Duration(seconds: 8), () {
      //appOpenAdManager.showAdIfAvailable();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainHomeScreen(),));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/png/logo.png'),
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
        color: Colors.white,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Powered by ",
            ),
            Text(
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
