import 'dart:convert';

import 'package:archo/util/util.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

printIfDebug(message) {
  if (!kReleaseMode) print(message);
}

printFullResponse(statement) {
  if (!kReleaseMode) {
    String printResponse = statement.toString();
    for (int i = 0; i <= printResponse.length / 1000; i++) {
      int start = i * 1000;
      int end = (i + 1) * 1000;
      end = end > printResponse.length ? printResponse.length : end;
      printIfDebug(printResponse.substring(start, end));
    }
  }
}

class Api {
  Api();

  // URLs ---------------------------- //

  static String get baseUrl => 'https://gorest.co.in/';

  static String get usersUrl =>
      'public-api/users?_format=json&access-token=$token&page=2';

  static String get anotherUrl => 'api/another_url';

  // API METHODS ---------------------------- //

  static Future<Map> getApiExample(
      {int page = 0, bool forceRefresh = false}) async {
    return dioGet(usersUrl, apiInfo: "Get Users");
  }

  static Future<Map> anotherGetApiExample(
          {Map<String, dynamic> queryParams = const {},
          bool forceRefresh = false}) async =>
      await dioGet(anotherUrl,
          queryParams: queryParams,
          forceRefresh: forceRefresh,
          apiInfo: "Get Another Api");

  static Future<Map> postApiExample(Map<String, dynamic> data,
          {bool forceRefresh = false}) async =>
      await dioPost(anotherUrl, data,
          forceRefresh: forceRefresh, apiInfo: 'Post API Example');

  static Future<Map> anotherPostApiExample(Map<String, dynamic> data,
          {Map<String, dynamic> queryParams = const {},
          bool forceRefresh = false}) async =>
      await dioPost(anotherUrl, data,
          queryParams: queryParams,
          forceRefresh: forceRefresh,
          apiInfo: "Post Another Api");

  // DIO METHODS ---------------------------- //

  static Map<String, dynamic> get getHeaders =>
      {"api_key": "", "authorization": ""};

  static Future<Map> dioGet(String urlPath,
      {Map<String, dynamic> queryParams = const {},
      @required String apiInfo,
      bool forceRefresh = false}) async {
    String url = baseUrl + urlPath;
    printIfDebug("GET_URL: " + url);
    printIfDebug("QUERY_PARAMS: " + queryParams.toString());

    if (forceRefresh) dioCacheManager.deleteByPrimaryKey(urlPath);

    var options =
        buildCacheOptions(Duration(days: 1), forceRefresh: forceRefresh)
            .merge(headers: getHeaders);

    printIfDebug("HEADERS: " + options.headers.toString());
    Response response = await dio.get(
      url,
      queryParameters: queryParams,
      options: options,
    );
    printIfDebug("$apiInfo Response: ${response.data.toString()}");
    return response.data is Map ? response.data : jsonDecode(response.data);
  }

  static Future<Map> dioPost(String urlPath, Map<String, dynamic> data,
      {Map<String, dynamic> queryParams = const {},
      String apiInfo,
      bool forceRefresh = false}) async {
    String url = baseUrl + urlPath;
    printIfDebug("POST_URL: " + url);
    printIfDebug("QUERY_PARAMS: " + queryParams.toString());
    printIfDebug("POST_DATA: " + data.toString());

    var options =
        buildCacheOptions(Duration(days: 1), forceRefresh: forceRefresh)
            .merge(headers: getHeaders);

    printIfDebug("HEADERS: " + options.headers.toString());
    Response response = await dio.post(
      url,
      data: FormData.fromMap(data),
      options: options,
      queryParameters: queryParams,
      onSendProgress: (int sent, int total) {
        printIfDebug("$sent $total");
      },
    );
    printIfDebug("$apiInfo Response: ${response.data.toString()}");
    return response.data is Map ? response.data : jsonDecode(response.data);
  }

  static Future dioDownload(String url, String path, ProgressCallback callback,
      {Map<String, dynamic> queryParams = const {},
      bool forceRefresh = false}) async {
    printIfDebug("DOWNLOAD_URL: " + url);
    var options = Options(headers: getHeaders);

    printIfDebug("HEADERS: " + options.headers.toString());
    await dio.download(url, path,
        options: options, onReceiveProgress: callback);
  }
}
