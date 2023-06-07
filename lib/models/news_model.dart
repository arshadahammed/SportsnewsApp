// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:reading_time/reading_time.dart';
import 'package:sportsnews/services/global_methods.dart';

class NewsModel with ChangeNotifier {
  String newsId,
      sourceName,
      authorName,
      title,
      description,
      url,
      urlToImage,
      publishedAt,
      dateToShow,
      content,
      category,
      readingTimeText,
      slug,
      twitter;
  bool top_trend, popular;

  NewsModel({
    required this.newsId,
    required this.sourceName,
    required this.authorName,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.dateToShow,
    required this.readingTimeText,
    required this.category,
    required this.slug,
    required this.top_trend,
    required this.popular,
    required this.twitter,
  });

  factory NewsModel.fromJson(dynamic json) {
    String title = json["title"] ?? "";
    String content = json["content"] ?? "";
    String description = json["description"] ?? "";

    String dateToShow = "";
    if (json["publishedAt"] != null) {
      dateToShow = GlobalMethods.formattedDateText(json["publishedAt"]);
    }
    return NewsModel(
      newsId: json["source"]["id"] ?? "",
      sourceName: json["source"]["name"] ?? "",
      authorName: json["author"] ?? "",
      title: title,
      description: description,
      url: json["url"] ?? "",
      urlToImage: json["urlToImage"] ??
          "https://techcrunch.com/wp-content/uploads/2022/01/locket-app.jpg?w=1390&crop=1",
      publishedAt: json["publishedAt"] ?? "",
      category: json["category"] ?? "",
      content: content,
      dateToShow: dateToShow,
      readingTimeText: readingTime(title + description + content).msg,
      popular: json["popular"] ?? "",
      top_trend: json["top_trend"] ?? "",
      slug: json["slug"] ?? "",
      twitter: json["twitter"] ?? "",
    );
  }

  static List<NewsModel> newsFromSnapshot(List newSnapshot) {
    return newSnapshot.map((json) {
      return NewsModel.fromJson(json);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["newsId"] = newsId;
    data["sourceName"] = sourceName;
    data["authorName"] = authorName;
    data["title"] = title;
    data["description"] = description;
    data["url"] = url;
    data["urlToImage"] = urlToImage;
    data["publishedAt"] = publishedAt;
    data["dateToShow"] = dateToShow;
    data["content"] = content;
    data["category"] = category;
    data["readingTimeText"] = readingTimeText;
    data["popular"] = popular;
    data["top_trend"] = top_trend;
    data["slug"] = slug;
    data["twitter"] = twitter;
    return data;
  }

  // @override
  // String toString() {
  //   return "news {newid: $newsId}";
  // }
}
