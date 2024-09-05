import 'package:zoftcares/constants/enums.dart';

import '../../models/post_model.dart';

class PostStates {
  final PageState pageState;
  final List<PostModel> posts;

  PostStates({required this.pageState, required this.posts});
}
