import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:provider/provider.dart';
import 'package:sportsnews/inner_screens/blog_details.dart';
import 'package:sportsnews/inner_screens/deeplink_blogdetails.dart';
import 'package:sportsnews/models/news_model.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class FirebaseDynamicLinkService {
  static Future<String> createDynamicLink(
    bool short,
    NewsModel newsModal,
  ) async {
    String _linkMessage;
    //${newsModal.newsId}
    final dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: 'https://sportcaster.page.link',
      link: Uri.parse(
          'https://sportcaster.page.link/sportsNews/${newsModal.newsId}'),
      androidParameters: const AndroidParameters(
        packageName: "com.seyfert.sportsnews",
        minimumVersion: 0,
      ),
    );

    socialMetaTagParameters:
    SocialMetaTagParameters(
      title: newsModal.title,
      description: newsModal.content,
      imageUrl: Uri.parse(newsModal.urlToImage),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
      url = shortLink.shortUrl;
      // final dynamicLink =
      //     await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
      //_linkMessage = url.toString();
    } else {
      url = await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    }

    _linkMessage = url.toString();
    log(newsModal.newsId);
    log(_linkMessage);
    return _linkMessage;
  }

  //

  static Future<void> initDynamicLinks(BuildContext context) async {
    dynamic newsModelProvider = Provider.of<NewsModel>(context);

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      // Extract the news item ID or other relevant information from the deep link URL
      final newsItemId = deepLink.queryParameters['id'];
      print("newsid ${newsItemId}");
      if (newsItemId != null) {
        // Perform any necessary actions based on the news item ID
        // For example, navigate to a specific news item in your app
        print("news item id is not null");
        try {
          Navigator.pushNamed(context, DeepLinkNewsDetailsScreen.routeName,
              arguments: "1");
        } catch (e) {
          print(e.toString());
        }
      }
    }

    FirebaseDynamicLinks.instance.onLink.listen(
      (PendingDynamicLinkData? dynamicLink) async {
        final Uri? deepLink = dynamicLink?.link;

        if (deepLink != null) {
          // Extract the news item ID or other relevant information from the deep link URL
          final newsItemId = deepLink.queryParameters['id'];

          if (newsItemId != null) {
            // Perform any necessary actions based on the news item ID
            // For example, navigate to a specific news item in your app

            try {
              Navigator.pushNamed(context, DeepLinkNewsDetailsScreen.routeName,
                  arguments: "1");
            } catch (e) {
              print(e.toString());
            }
          }
        }
      },
      onError: (error) async {
        // Handle any errors related to deep linking
        // You can access the error message using error.message
        print(error.toString());
      },
    );
  }
}






//
//  Future<void> initDynamicLinks(BuildContext context) async {
//     final PendingDynamicLinkData? initialLink =
//         await FirebaseDynamicLinks.instance.getInitialLink();

//     if (initialLink != null) {
//       final Uri deepLink = initialLink.link;
//       final newsItemId = deepLink.queryParameters['id'];
//       log("deep link newsid ${newsItemId}");

//       //console.log(newsItemId);
//       if (newsItemId != null) {
//         print("news item  ${newsItemId} id is not null");
//         try {
//           Navigator.pushNamed(context, DeepLinkNewsDetailsScreen.routeName,
//               arguments: newsItemId);
//         } catch (e) {
//           print(e.toString());
//         }
//       }
//       // Example of using the dynamic link to push the user to a different screen
//       // Navigator.pushNamed(context, deepLink.path);
//     }

//     FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
//       //Navigator.pushNamed(context, dynamicLinkData.link.path);
//       //final Uri deepLink = dynamicLinkData.link;
//       Navigator.pushNamed(context, DeepLinkNewsDetailsScreen.routeName,
//           arguments: dynamicLinkData.link.queryParameters['id']);
//       // if (deepLink != null) {
//       //   // Extract the news item ID or other relevant information from the deep link URL
//       //   final newsItemId = deepLink.queryParameters['id'];

//       //   if (newsItemId != null) {
//       //     // Perform any necessary actions based on the news item ID
//       //     // For example, navigate to a specific news item in your app

//       //     try {
//       //       Navigator.pushNamed(context, DeepLinkNewsDetailsScreen.routeName,
//       //           arguments: newsItemId);
//       //     } catch (e) {
//       //       print(e.toString());
//       //     }
//       //   }
//       // }
//     }).onError((error) {
//       print('onLink error');
//       print(error.message);
//     });
//   }