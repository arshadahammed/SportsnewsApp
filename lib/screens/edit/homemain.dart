// Future<void> initDynamicLinks(BuildContext context) async {
//     //await Future.delayed(Duration(seconds: 1));
//     final searchNewsProvider = Provider.of<SearchNewsProvider>(context);
//     Future<List<NewsModel>> alllist = searchNewsProvider.fetchAllNews();
//     //log(alllist.length.toString());
//     FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
//       final Uri deepLink = dynamicLinkData.link;
//       //deepLink != null
//       //searchNewsProvider.newsList.isNotEmpty
//       if (deepLink != null) {
//         handleDeepLink(deepLink);
//       }
//     }).onError((error) {
//       print('onLink error');
//       print(error.message);
//     });
//   } 



