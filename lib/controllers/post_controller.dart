import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import '../constants/enums.dart';
import '../models/post_model.dart';
import '../services/posts_service.dart';

class PostController with ChangeNotifier {


  List<PostModel> posts = [];
  String? error;
  bool isLoadingMore = false;
  int totalCount = 0;
  int page = 1;

  PageState _pageState = PageState.loading;

  set pageState(final PageState value) {
    _pageState = value;
    notifyListeners();
  }

  PageState get pageState => _pageState;




  Future<bool> loadMore() async {
    if (totalCount > posts.length && isLoadingMore != true) {
      isLoadingMore = true;
      page++;
      return _fetchPosts();
    }
    return false;
  }

  initList() async {
    _pageState = PageState.loading;
    isLoadingMore = false;
    posts.clear();
    page = 1;
    totalCount = 0;
    _fetchPosts();
  }

  Future<bool> _fetchPosts() async {
    try {
      final response = await PostsService().fetchPosts(page);
      if (page == 1) {
        posts = response.data ?? [];
      } else {
        posts.addAll(response.data ?? []);
      }
      isLoadingMore = false;
      if (posts.isNotEmpty) {
        error = null;
        totalCount = response.totalItems ?? 0;
        pageState = PageState.success;
      } else {
        error = 'No Data Available';
        pageState = PageState.error;
      }
      return true;
    } on SocketException {
      error = 'Network Issue';
      isLoadingMore = false;
      pageState = PageState.error;
      return false;
    } catch (e) {
      error = e.toString();
      isLoadingMore = false;
      pageState = PageState.error;
      return false;
    }
  }

}
