import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:sportsnews/models/news_model.dart';
import 'package:sportsnews/services/cached_news_api.dart';
import 'package:sportsnews/services/news_api.dart';

class NewsProvider with ChangeNotifier {
  List<NewsModel> newsList = [];

  List<NewsModel> get getNewsList {
    return newsList;
  }

  Future<List<NewsModel>> fetchAllNews(
      {required int pageIndex, required String sortBy}) async {
    newsList =
        await NewsAPiServices.getAllNews(page: pageIndex, sortBy: sortBy);
    return newsList;
  }

  Future<List<NewsModel>> fetchTopHeadlines() async {
    newsList = await NewsAPiServices.getTopHeadlines();
    log("newsid of item 2");
    //log(newsList[5].newsId);
    return newsList;
  }

  //cached
  Future<List<NewsModel>> cachedfetchTopTrendingHeadlines() async {
    newsList = await CachedNewsAPiServices.getTopHeadlines();
    log("newsid of item 2");
    //log(newsList[5].newsId);
    return newsList;
  }

  //popular
  Future<List<NewsModel>> cachedfetchPopularNews() async {
    newsList = await CachedNewsAPiServices.getpopularNews();
    log("newsid of item 2");
    //log(newsList[5].newsId);
    return newsList;
  }

  //football
  Future<List<NewsModel>> fetchFootballNews() async {
    newsList = await CachedNewsAPiServices.getFootballNews();
    return newsList;
  }

  //cricket
  Future<List<NewsModel>> fetchCricketNews() async {
    newsList = await CachedNewsAPiServices.getCricketNews();
    return newsList;
  }

  //tennis
  Future<List<NewsModel>> fetchTennisNews() async {
    newsList = await CachedNewsAPiServices.getTennisNews();
    return newsList;
  }

  //other
  Future<List<NewsModel>> fetchOtherNews() async {
    newsList = await CachedNewsAPiServices.getOtherNews();
    return newsList;
  }

  Future<List<NewsModel>> searchNewsProvider({required String query}) async {
    newsList = await NewsAPiServices.searchNews(query: query);
    return newsList;
  }

  //searchslug
  Future<List<NewsModel>> searchSlugNewsProvider(
      {required String query}) async {
    newsList = await CachedNewsAPiServices.searchNews(query: query);
    return newsList;
  }

  NewsModel findByDate({required String? publishedAt}) {
    return newsList
        .firstWhere((newsModel) => newsModel.publishedAt == publishedAt);
  }

  NewsModel findByDate2({required String? publishedAt}) {
    return newsList
        .firstWhere((newsModel) => newsModel.publishedAt == publishedAt);
  }

  //findy=byID
  NewsModel findById({required String? id}) {
    return newsList.firstWhere((newsModel) => newsModel.newsId == id);
  }
}
