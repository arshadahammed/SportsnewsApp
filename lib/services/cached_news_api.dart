import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportsnews/consts/api_consts.dart';
import 'package:sportsnews/consts/http_exceptions.dart';
import 'package:sportsnews/models/news_model.dart';

class CachedNewsAPiServices {
  //allnews
  static Future<List<NewsModel>> getAllNews() async {
    try {
      Dio dio = Dio();
      // DioCacheManager cacheManager =
      //     DioCacheManager(CacheConfig(baseUrl: BASEURL2));
      // dio.interceptors.add(cacheManager.interceptor);

      // Options cacheOptions = buildCacheOptions(
      //   Duration(minutes: 10),
      //   maxStale: Duration(minutes: 10),
      //   //forceRefresh: true,
      // );

      Response response = await dio.get(
        BASEURL2,
        //options: cacheOptions,
      );

      log('Response status: ${response.statusCode}');
      Map<String, dynamic> data = response.data;
      //log(response.data.toString());

      List newsTempList = [];
      if (data['code'] != null) {
        throw HttpException(data['code']);
      }
      for (var article in data["articles"]) {
        newsTempList.add(article);
      }
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (error) {
      throw error.toString();
    }
  }

  //toptrending

  static Future<List<NewsModel>> getTopHeadlines() async {
    try {
      Dio dio = Dio();
      // DioCacheManager cacheManager =
      //     DioCacheManager(CacheConfig(baseUrl: BASEURL2));
      // dio.interceptors.add(cacheManager.interceptor);

      // Options cacheOptions = buildCacheOptions(
      //   Duration(minutes: 10),
      //   maxStale: Duration(minutes: 10),
      //   //forceRefresh: true,
      // );

      Response response = await dio.get(
        BASEURL2,
        //options: cacheOptions,
      );

      log('Response status: ${response.statusCode}');
      Map<String, dynamic> data = response.data;
      //log(response.data.toString());

      List newsTempList = [];
      if (data['code'] != null) {
        throw HttpException(data['code']);
      }
      for (var article in data["articles"]) {
        if (article['top_trend'] == true) {
          newsTempList.add(article);
          //print("length ${newsTempList.length}");
        }
        //newsTempList.add(v);
      }
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (error) {
      throw error.toString();
    }
  }

  //popular
  static Future<List<NewsModel>> getpopularNews() async {
    try {
      Dio dio = Dio();
      // DioCacheManager cacheManager =
      //     DioCacheManager(CacheConfig(baseUrl: BASEURL2));
      // dio.interceptors.add(cacheManager.interceptor);

      // Options cacheOptions = buildCacheOptions(
      //   Duration(minutes: 10),
      //   maxStale: Duration(minutes: 10),
      //   //forceRefresh: true,
      // );

      Response response = await dio.get(
        BASEURL2,
        //options: cacheOptions,
      );

      log('Response status: ${response.statusCode}');
      Map<String, dynamic> data = response.data;
      //log(response.data.toString());

      List newsTempList = [];
      if (data['code'] != null) {
        throw HttpException(data['code']);
      }
      for (var article in data["articles"]) {
        if (article['popular'] == true) {
          newsTempList.add(article);
          // print("length ${newsTempList.length}");
        }
        //newsTempList.add(v);
      }
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (error) {
      throw error.toString();
    }
  }

  ////football
  static Future<List<NewsModel>> getFootballNews() async {
    try {
      Dio dio = Dio();
      // DioCacheManager cacheManager =
      //     DioCacheManager(CacheConfig(baseUrl: BASEURL2));
      // dio.interceptors.add(cacheManager.interceptor);

      // Options cacheOptions = buildCacheOptions(
      //   Duration(minutes: 10),
      //   maxStale: Duration(minutes: 10),
      //   //forceRefresh: true,
      // );

      Response response = await dio.get(
        BASEURL2,
        //options: cacheOptions,
      );

      log('Response status: ${response.statusCode}');
      Map<String, dynamic> data = response.data;
      // log(response.data.toString());

      List<Map<String, dynamic>> footballArticles = [];
      if (data['code'] != null) {
        throw HttpException(data['code']);
      }
      for (var article in data["articles"]) {
        if (article['category'] == "football") {
          footballArticles.add(article);
          // print("length ${footballArticles.length}");
        }
      }

      return NewsModel.newsFromSnapshot(footballArticles);
    } catch (error) {
      throw error.toString();
    }
  }

  //cricket

  static Future<List<NewsModel>> getCricketNews() async {
    try {
      Dio dio = Dio();
      // DioCacheManager cacheManager =
      //     DioCacheManager(CacheConfig(baseUrl: BASEURL2));
      // dio.interceptors.add(cacheManager.interceptor);

      // Options cacheOptions = buildCacheOptions(
      //   Duration(minutes: 10),
      //   maxStale: Duration(minutes: 10),
      //   //forceRefresh: true,
      // );

      Response response = await dio.get(
        BASEURL2,
        // options: cacheOptions,
      );

      log('Response status: ${response.statusCode}');
      Map<String, dynamic> data = response.data;
      //log(response.data.toString());

      List<Map<String, dynamic>> footballArticles = [];
      if (data['code'] != null) {
        throw HttpException(data['code']);
      }
      for (var article in data["articles"]) {
        if (article['category'] == "cricket") {
          footballArticles.add(article);
          //print("length ${footballArticles.length}");
        }
      }

      return NewsModel.newsFromSnapshot(footballArticles);
    } catch (error) {
      throw error.toString();
    }
  }

  //tennis
  static Future<List<NewsModel>> getTennisNews() async {
    try {
      Dio dio = Dio();
      // DioCacheManager cacheManager =
      //     DioCacheManager(CacheConfig(baseUrl: BASEURL2));
      // dio.interceptors.add(cacheManager.interceptor);

      // Options cacheOptions = buildCacheOptions(
      //   Duration(minutes: 10),
      //   maxStale: Duration(minutes: 10),
      //   //forceRefresh: true,
      // );

      Response response = await dio.get(
        BASEURL2,
        // options: cacheOptions,
      );

      log('Response status: ${response.statusCode}');
      Map<String, dynamic> data = response.data;
      // log(response.data.toString());

      List<Map<String, dynamic>> footballArticles = [];
      if (data['code'] != null) {
        throw HttpException(data['code']);
      }
      for (var article in data["articles"]) {
        if (article['category'] == "tennis") {
          footballArticles.add(article);
          //print("length ${footballArticles.length}");
        }
      }

      return NewsModel.newsFromSnapshot(footballArticles);
    } catch (error) {
      throw error.toString();
    }
  }

  //other
  static Future<List<NewsModel>> getOtherNews() async {
    try {
      Dio dio = Dio();
      // DioCacheManager cacheManager =
      //     DioCacheManager(CacheConfig(baseUrl: BASEURL2));
      // dio.interceptors.add(cacheManager.interceptor);

      // Options cacheOptions = buildCacheOptions(
      //   Duration(minutes: 10),
      //   maxStale: Duration(minutes: 10),
      //   //forceRefresh: true,
      // );

      Response response = await dio.get(
        BASEURL2,
        // options: cacheOptions,
      );

      log('Response status: ${response.statusCode}');
      Map<String, dynamic> data = response.data;
      //log(response.data.toString());

      List<Map<String, dynamic>> footballArticles = [];
      if (data['code'] != null) {
        throw HttpException(data['code']);
      }
      for (var article in data["articles"]) {
        if (article['category'] == "others") {
          footballArticles.add(article);
          //print("length ${footballArticles.length}");
        }
      }

      return NewsModel.newsFromSnapshot(footballArticles);
    } catch (error) {
      throw error.toString();
    }
  }

  //search slug
  static Future<List<NewsModel>> searchNews({required String query}) async {
    try {
      Dio dio = Dio();
      // DioCacheManager cacheManager =
      //     DioCacheManager(CacheConfig(baseUrl: BASEURL2));
      // dio.interceptors.add(cacheManager.interceptor);

      // Options cacheOptions = buildCacheOptions(
      //   Duration(minutes: 10),
      //   maxStale: Duration(minutes: 10),
      //   //forceRefresh: true,
      // );

      Response response = await dio.get(
        BASEURL2,
        // options: cacheOptions,
      );

      log('Response status: ${response.statusCode}');
      Map<String, dynamic> data = response.data;
      //log(response.data.toString());

      List<Map<String, dynamic>> footballArticles = [];
      if (data['code'] != null) {
        throw HttpException(data['code']);
      }
      for (var article in data["articles"]) {
        if (article['slug'] == query) {
          footballArticles.add(article);
          //print("length ${footballArticles.length}");
        }
      }

      return NewsModel.newsFromSnapshot(footballArticles);
    } catch (error) {
      throw error.toString();
    }
  }

  //getfavourite news
  static Future<List<NewsModel>> getFavNews() async {
    try {
      //log("Started to fetch fav");
      Dio dio = Dio();
      // DioCacheManag
      //
      //
      //er cacheManager =
      //     DioCacheManager(CacheConfig(baseUrl: BASEURL2));
      // dio.interceptors.add(cacheManager.interceptor);

      // Options cacheOptions = buildCacheOptions(
      //   Duration(minutes: 10),
      //   maxStale: Duration(minutes: 10),
      //   //forceRefresh: true,
      // );

      Response response = await dio.get(
        BASEURL2,
        // options: cacheOptions,
      );

      log('Response status: ${response.statusCode}');
      Map<String, dynamic> data = response.data;
      //log(response.data.toString());

      List newsTempList = [];
      if (data['code'] != null) {
        throw HttpException(data['code']);
      }
      for (var article in data["articles"]) {
        // if (article['top_trend'] == true) {
        //   newsTempList.add(article);
        //   print("length ${newsTempList.length}");
        // }
        newsTempList.add(article);
      }

      //log(newsTempList.length.toString());

      List<String> favoriteIds = [];
      //log(_favoriteIds.length.toString());
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      favoriteIds = prefs.getStringList('favoriteIds') ?? [];

      List<NewsModel> newsModelList = NewsModel.newsFromSnapshot(newsTempList);

      return newsModelList
          .where((news) => favoriteIds.contains(news.newsId))
          .toList();

      //return NewsModel.newsFromSnapshot(newsTempList);
    } catch (error) {
      throw error.toString();
    }
  }

  //
}
