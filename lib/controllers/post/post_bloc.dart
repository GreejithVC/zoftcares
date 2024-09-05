import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoftcares/constants/enums.dart';
import 'package:zoftcares/controllers/post/post_event.dart';
import 'package:zoftcares/controllers/post/post_state.dart';

import '../../models/post_model.dart';
import '../../services/posts_service.dart';

class PostBloc extends Bloc<PostEvents, PostStates> {
  PostBloc() : super(PostStates(pageState: PageState.loading, posts: [])) {
    initList();
  }

  bool isLoadingMore = false;
  int totalCount = 0;
  int page = 1;
  List<PostModel> posts = [];
  String? error;

  @override
  Stream<PostStates> mapEventToState(PostEvents event) async* {
    if (event is UpdateHomePageStatusEvent) {
      yield PostStates(pageState: event.pageState, posts: posts);
    } else if (event is FetchDataEvent) {
      loadMore();
    } else if (event is UpdateDataEvent) {
      yield PostStates(pageState: PageState.success, posts: posts);
    }
  }

  Future<bool> loadMore() async {
    if (totalCount > posts.length && isLoadingMore != true) {
      isLoadingMore = true;
      page++;
       return _fetchPosts();
    }
    return false;

  }

  initList() async {
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
        add(UpdateHomePageStatusEvent(pageState: PageState.success));
      } else {
        error = 'No Data Available';
        add(UpdateHomePageStatusEvent(pageState: PageState.error));
      }
      return true;

    } on SocketException {
      error = 'Network Issue';
      isLoadingMore = false;
      add(UpdateHomePageStatusEvent(pageState: PageState.error));
      return false;

    } catch (e) {
      error = e.toString();
      isLoadingMore = false;
      add(UpdateHomePageStatusEvent(pageState: PageState.error));
      return false;

    }
  }
}
