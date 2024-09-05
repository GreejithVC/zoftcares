import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loadmore/loadmore.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zoftcares/constants/app_strings.dart';
import 'package:zoftcares/controllers/auth/auth_event.dart';
import 'package:zoftcares/controllers/post/post_event.dart';
import 'package:zoftcares/controllers/post/post_state.dart';
import 'package:zoftcares/ui/components/post_tile.dart';

import '../../constants/app_colors.dart';
import '../../constants/enums.dart';
import '../../controllers/auth/auth_bloc.dart';
import '../../controllers/post/post_bloc.dart';
import '../../main.dart';
import '../../models/post_model.dart';
import '../../utils/widget_utils.dart';
import '../components/shimmer_tile.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final PostBloc controller = BlocProvider.of<PostBloc>(navigatorKey.currentContext!);

  @override
  void initState() {
    super.initState();
    controller.initList();
  }

  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      onWillPop: () => WidgetUtils.showExitPopUp(context),
      child: Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.appName),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
                  },
                  icon: const Icon(Icons.logout))
            ],
          ),
          body: BlocSelector<PostBloc, PostStates,
                  Tuple2<PageState, List<PostModel>>>(
              selector: (PostStates state) =>
                  Tuple2(state.pageState, state.posts),
              builder: (context, Tuple2<PageState, List<PostModel>> data) {
                if (data.item1 == PageState.loading) {
                  return _loadingView();
                } else if (data.item2.isNotEmpty) {
                  return _postsListView();
                } else {
                  return _errorView();
                }
              })),
    );
  }

  Widget _postsListView() {
    return LoadMore(
      isFinish: controller.posts.length >= controller.totalCount,
      onLoadMore: controller.loadMore,
      textBuilder: DefaultLoadMoreTextBuilder.english,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: controller.posts.length,
        itemBuilder: (final context, final index) {
          return PostTile(
              postModel: controller.posts[index],);
        },
        separatorBuilder: (final context, final index) {
          return const SizedBox(height: 12);
        },
      ),
    );
  }

  Widget _loadingView() {
    return Shimmer.fromColors(
      baseColor: AppColors.greyColor,
      highlightColor: AppColors.bgColor,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: 10,
        itemBuilder: (final context, final index) {
          return const ShimmerTile();
        },
        separatorBuilder: (final context, final index) {
          return const SizedBox(height: 12);
        },
      ),
    );
  }

  Widget _errorView() {
    return Center(child: Text(controller.error ?? 'Unexpected error occured'));
  }
}
