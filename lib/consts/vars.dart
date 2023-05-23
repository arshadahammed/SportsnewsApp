import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

enum NewsType {
  topTrending,
  allNews,
  football,
  cricket,
}

enum SortByEnum {
  relevancy, // articles more closely related to q come first.
  popularity, // articles from popular sources and publishers come first.
  publishedAt, // newest articles come first.
}

const List<String> searchKeywords = [
  "football",
  "cricket",
  "tennis",
  "messi",
  "ipl",
  "argentina",
  "brazil",
  "ronaldo",
  "fifa",
  "icc",
];
