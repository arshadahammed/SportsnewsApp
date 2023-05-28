//Packages
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sportsnews/inner_screens/all_news_blog.dart';
import 'package:sportsnews/inner_screens/blog_details.dart';
import 'package:sportsnews/inner_screens/cricket_news_blog.dart';
import 'package:sportsnews/inner_screens/deeplink_blogdetails.dart';
import 'package:sportsnews/inner_screens/football_news_blog.dart';
import 'package:sportsnews/inner_screens/other_blog_details.dart';
import 'package:sportsnews/inner_screens/popular_blog_details.dart';
import 'package:sportsnews/inner_screens/tennis_blog_details.dart';
import 'package:sportsnews/inner_screens/top_trending_newsdetails.dart';
import 'package:sportsnews/providers/all_news_provider.dart';
import 'package:sportsnews/providers/cricket_news_provider.dart';
import 'package:sportsnews/providers/firebase_dynamic_link.dart';
import 'package:sportsnews/providers/football_news_provider.dart';
import 'package:sportsnews/providers/news_provider.dart';
import 'package:sportsnews/providers/notification_provider.dart';
import 'package:sportsnews/providers/other_news_provider.dart';
import 'package:sportsnews/providers/popular_news_provider.dart';
import 'package:sportsnews/providers/tennis_news_provider.dart';
import 'package:sportsnews/providers/toptrending_provider.dart';
import 'package:sportsnews/screens/main_homescreen.dart';
import 'package:sportsnews/services/utils.dart';
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
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
    //getCachedData();
    super.initState();
    LocalNotifications.sendSheduledNotification(
        "Check Sports Caster ", "New Sports news added");
  }

  //Fetch the current theme
  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  // Color getCurrentCOlor() {
  //   final Color color = Utils(context).getColor;
  //   return color;
  // }

  //fetchDatafromApi and cache it
  void getCachedData() async {
    Provider.of<NewsProvider>(context).cachedfetchTopTrendingHeadlines();
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
          create: (_) => PopularNewsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TopTrendingNewsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AllNewsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FootballNewsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CricketNewsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TennisNewsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OtherNewsProvider(),
        ),
      ],
      child:
          //Notify about theme changes
          Consumer<ThemeProvider>(builder: (context, themeChangeProvider, ch) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sports Caster',
          theme: Styles.themeData(themeChangeProvider.getDarkTheme, context),
          home: const MainHomeScreen(),
          routes: {
            NewsDetailsScreen.routeName: (ctx) => NewsDetailsScreen(),
            DeepLinkNewsDetailsScreen.routeName: (ctx) =>
                const DeepLinkNewsDetailsScreen(),
            PopularNewsDetails.routeName: (ctx) => PopularNewsDetails(),
            TopTrendingNewsDetails.routeName: (ctx) => TopTrendingNewsDetails(),
            AllNewsDetails.routeName: (ctx) => AllNewsDetails(),
            FootballNewsDetails.routeName: (ctx) => FootballNewsDetails(),
            CricketNewsDetails.routeName: (ctx) => CricketNewsDetails(),
            TennisNewsDetails.routeName: (ctx) => TennisNewsDetails(),
            OtherNewsDetails.routeName: (ctx) => OtherNewsDetails(),
          },
        );
      }),
    );
  }
}
