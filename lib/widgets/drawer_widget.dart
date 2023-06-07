import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sportsnews/screens/about_us.dart';
import 'package:sportsnews/screens/contact_us.dart';

import '../providers/theme_provider.dart';
import 'vertical_spacing.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.getDarkTheme;

    return Drawer(
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Theme.of(context).scaffoldBackgroundColor
                    : const Color.fromARGB(255, 5, 51, 84),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image.asset(
                      'assets/png/logo.png',
                      height: 500,
                      width: 500,
                    ),
                  ),
                  const VerticalSpacing(20),
                  // Flexible(
                  //   child: Text(
                  //     'News app',
                  //     style: GoogleFonts.lobster(
                  //         textStyle: const TextStyle(
                  //             fontSize: 20, letterSpacing: 0.6)),
                  //   ),
                  // ),
                ],
              ),
            ),
            const VerticalSpacing(5),
            ListTilesWidget(
              label: "Home",
              icon: IconlyBold.home,
              fct: () {
                // Navigator.push(
                //   context,
                //   PageTransition(
                //       type: PageTransitionType.rightToLeft,
                //       child: MainHomeScreen(),
                //       inheritTheme: true,
                //       ctx: context),
                // );
                Navigator.pop(context);
              },
            ),
            // ListTilesWidget(
            //   label: "Bookmark",
            //   icon: IconlyBold.bookmark,
            //   fct: () {
            //     // Navigator.pushReplacement(
            //     //   context,
            //     //   PageTransition(
            //     //       type: PageTransitionType.rightToLeft,
            //     //       child: TwitterEmbedd(twitterId: "51544"),
            //     //       inheritTheme: true,
            //     //       ctx: context),
            //     // );
            //   },
            // ),
            const VerticalSpacing(5),
            ListTilesWidget(
              label: "About us",
              icon: IconlyBold.paper,
              fct: () {
                //LocalNotifications.showNotification();
                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const AboutUs(),
                      inheritTheme: true,
                      ctx: context),
                );
              },
            ),
            const VerticalSpacing(5),
            ListTilesWidget(
              label: "Contact us",
              icon: IconlyBold.call,
              fct: () {
                //LocalNotifications.showNotification();
                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const Contactus(),
                      inheritTheme: true,
                      ctx: context),
                );
              },
            ),
            const Divider(
              thickness: 5,
            ),
            SwitchListTile(
                title: Text(
                  themeProvider.getDarkTheme ? 'Dark' : 'Light',
                  style: const TextStyle(fontSize: 20),
                ),
                secondary: Icon(
                  themeProvider.getDarkTheme
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                value: themeProvider.getDarkTheme,
                onChanged: (bool value) {
                  setState(() {
                    //themeProvider.toggleTheme();
                    themeProvider.setDarkTheme = value;
                  });
                }),
          ],
        ),
      ),
    );
  }
}

class ListTilesWidget extends StatelessWidget {
  const ListTilesWidget({
    Key? key,
    required this.label,
    required this.fct,
    required this.icon,
  }) : super(key: key);
  final String label;
  final Function fct;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 20),
      ),
      onTap: () {
        fct();
      },
    );
  }
}
