import 'package:archo/controller/api.dart';
import 'package:archo/model/user.dart';
import 'package:archo/util/essentials.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  HomeProvider();

  List<User> users;
  Meta meta;
  int page;
  bool isLoading = false;
  bool isLoadingMore = false;

  init() async {
    await getUsers(forceRefresh: true);
  }

  getUsers({bool forceRefresh = false}) async {
    if (forceRefresh) {
      page = 0;
      isLoading = true;
    } else
      isLoadingMore = true;
    notifyListeners();
    await Api.getApiExample(page: page, forceRefresh: forceRefresh)
        .then((response) {
      if (response != null) {
        meta = Meta.fromJson(response['_meta']);
        users = response['result']
            .map<User>((item) => User.fromJson(item))
            .toList();
        page++;
      }
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    });
  }
}
