import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sportsnews/inner_screens/bookmarks_screen.dart';
import 'package:sportsnews/inner_screens/deeplink_blogdetails.dart';
import 'package:sportsnews/providers/news_provider.dart';
import 'package:sportsnews/providers/notification_provider.dart';
import 'package:sportsnews/screens/favourite.dart';
import 'package:sportsnews/screens/home_screen.dart';
import 'package:sportsnews/services/news_api.dart';
import 'package:sportsnews/widgets/popular_loadingwidget.dart';

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
    final newsProvider = Provider.of<NewsProvider>(context);
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
                      : Colors.brown),
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
            const VerticalSpacing(20),
            ListTilesWidget(
              label: "Home",
              icon: IconlyBold.home,
              fct: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const HomeScreen(),
                      inheritTheme: true,
                      ctx: context),
                );
              },
            ),

            ListTilesWidget(
              label: "Bookmark",
              icon: IconlyBold.bookmark,
              fct: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const FavouriteNews(),
                      inheritTheme: true,
                      ctx: context),
                );
              },
            ),
            //const VerticalSpacing(20),
            ListTilesWidget(
              label: "check",
              icon: IconlyBold.home,
              fct: () {
                //NewsAPiServices.getTopHeadlines();
                newsProvider.cachedfetchFavouriteNews();
                //LocalNotifications.showNotification();
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
