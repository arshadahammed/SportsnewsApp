//Packages
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsnews/inner_screens/blog_details.dart';
import 'package:sportsnews/inner_screens/deeplink_blogdetails.dart';
import 'package:sportsnews/providers/firebase_dynamic_link.dart';
import 'package:sportsnews/providers/news_provider.dart';
import 'package:sportsnews/providers/notification_provider.dart';
import 'package:sportsnews/screens/main_homescreen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//Screens
import 'providers/bookmarks_provider.dart';
import 'screens/home_screen.dart';

//Consts
import 'consts/theme_data.dart';

//Providers
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //tz.initializeTimeZones();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Need it to access the theme Provider
  ThemeProvider themeChangeProvider = ThemeProvider();

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
    LocalNotifications.sendSheduledNotification(
        "Check Sports Caster ", "New Sports news added");
  }

  //Fetch the current theme
  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          //Notify about theme changes
          return themeChangeProvider;
        }),
        ChangeNotifierProvider(
          create: (_) => NewsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BookmarksProvider(),
        ),
      ],
      child:
          //Notify about theme changes
          Consumer<ThemeProvider>(builder: (context, themeChangeProvider, ch) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'News App - Flutter&API Course',
          theme: Styles.themeData(themeChangeProvider.getDarkTheme, context),
          home: const MainHomeScreen(),
          routes: {
            NewsDetailsScreen.routeName: (ctx) => const NewsDetailsScreen(),
            DeepLinkNewsDetailsScreen.routeName: (ctx) =>
                const DeepLinkNewsDetailsScreen(),
          },
        );
      }),
    );
  }
}
