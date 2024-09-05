import 'package:zoftcares/constants/enums.dart';

import '../../models/post_model.dart';

abstract class PostEvents {}

class FetchDataEvent extends PostEvents {}

class UpdateHomePageStatusEvent extends PostEvents {
  final PageState pageState;

  UpdateHomePageStatusEvent({required this.pageState});
}

class UpdateDataEvent extends PostEvents {
  final List<PostModel> posts;

  UpdateDataEvent({required this.posts});
}
