import 'package:flutter/material.dart';
import 'package:sportsnews/models/news_model.dart';
import 'package:sportsnews/services/cached_news_api.dart';

class OtherNewsProvider with ChangeNotifier {
  List<NewsModel> newsList = [];

  List<NewsModel> get getNewsList {
    return newsList;
  }

  Future<List<NewsModel>> fetchOtherNews() async {
    newsList = await CachedNewsAPiServices.getOtherNews();
    //log("newsid of item 2");
    //log(newsList[5].newsId);
    return newsList.reversed.toList();
  }

  NewsModel findById({required String? id}) {
    return newsList.firstWhere((newsModel) => newsModel.newsId == id);
  }
}
