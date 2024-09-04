import 'package:loadmore/loadmore.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zoftcares/constants/app_strings.dart';
import 'package:zoftcares/ui/components/post_tile.dart';

import '../../constants/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/post_controller.dart';
import '../../constants/enums.dart';
import '../../main.dart';
import '../../models/post_model.dart';
import '../../utils/widget_utils.dart';
import '../components/post_image.dart';
import '../components/shimmer_tile.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final PostController controller = Provider.of<PostController>(
      navigatorKey.currentContext!,
      listen: false);
  final AuthController authController =
      Provider.of<AuthController>(navigatorKey.currentContext!, listen: false);

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
                onPressed: authController.logoutAlertBox,
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Selector<PostController, Tuple2<PageState, List<PostModel>>>(
          selector: (final context, final controller) =>
              Tuple2(controller.pageState, controller.posts),
          shouldRebuild: (Tuple2<PageState, List<PostModel>> before,
              Tuple2<PageState, List<PostModel>> after) {
            return true;
          },
          builder: (final context, final data, final child) {
            if (data.item1 == PageState.loading) {
              return _loadingView();
            } else if (data.item2.isNotEmpty) {
              return _postsListView();
            } else {
              return _errorView();
            }
          },
        ),
      ),
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
