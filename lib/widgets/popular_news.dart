import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sportsnews/inner_screens/blog_details.dart';
import 'package:sportsnews/inner_screens/popular_blog_details.dart';
import 'package:sportsnews/models/news_model.dart';
import 'package:sportsnews/services/utils.dart';

class PopularNews extends StatelessWidget {
  String getTimeDifference(DateTime publishedTime) {
    final now = DateTime.now();

    if (publishedTime.isAfter(now)) {
      return 'Just published';
    }

    final difference = now.difference(publishedTime);

    if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    }
  }

  const PopularNews({super.key});

  @override
  Widget build(BuildContext context) {
    final newsModelProvider = Provider.of<NewsModel>(context);
    final size = Utils(context).getScreenSize;
    final Color color = Utils(context).getColor;
    DateTime publishedTime = DateTime.parse(newsModelProvider.publishedAt);

    final timeDifference = getTimeDifference(publishedTime);

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          onTap: () {
            // Navigator.pushNamed(context, NewsDetailsScreen.routeName,
            //     arguments: newsModelProvider.publishedAt);
            Navigator.pushNamed(context, PopularNewsDetails.routeName,
                arguments: newsModelProvider.newsId);
            // Navigator.pushNamed(context, NewsDetailsScreen.routeName,
            //     arguments: {
            //       'argumentID': newsModelProvider.newsId,
            //       'argumentDate': newsModelProvider.publishedAt,
            //     });
          },
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(left: 8),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       const Text(
              //         "Popular",
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 18,
              //         ),
              //       ),
              //       TextButton(
              //         onPressed: () {},
              //         style: TextButton.styleFrom(foregroundColor: Colors.blue),
              //         child: const Text("See All"),
              //       )
              //     ],
              //   ),
              // ),
              SizedBox(
                  height: 220,
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    width: 200,
                    // color: Colors.blue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            newsModelProvider.urlToImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            newsModelProvider.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.chathura(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                //fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            timeDifference,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
