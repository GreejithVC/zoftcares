import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoftcares/constants/enums.dart';
import 'package:zoftcares/controllers/post/post_event.dart';
import 'package:zoftcares/controllers/post/post_state.dart';

import '../../models/post_model.dart';
import '../../services/posts_service.dart';

class PostBloc extends Bloc<PostEvents, PostStates> {
  PostBloc() : super(PostStates(pageState: PageState.loading, posts: 0)) {
    on<UpdateHomePageStatusEvent>((event, emit) =>
        emit(PostStates(pageState: event.pageState, posts: state.posts)));
    on<FetchDataEvent>((event, emit) => loadMore());
    on<UpdateDataEvent>((event, emit) {
      emit(PostStates(pageState: PageState.success, posts: event.posts));
    });
    initList();
  }

  List<PostModel> posts = [];
  bool isLoadingMore = false;
  int totalCount = 0;
  int page = 1;
  String? error;

  Future<bool> loadMore() async {
    if (totalCount > posts.length && isLoadingMore != true) {
      isLoadingMore = true;
      page++;
      final result = await _fetchPosts();
      return result;
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
        add(UpdateDataEvent(posts: posts.length));
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
