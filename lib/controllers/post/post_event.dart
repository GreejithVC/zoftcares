import 'package:zoftcares/constants/enums.dart';


abstract class PostEvents {}

class FetchDataEvent extends PostEvents {}

class UpdateHomePageStatusEvent extends PostEvents {
  final PageState pageState;

  UpdateHomePageStatusEvent({required this.pageState});
}

class UpdateDataEvent extends PostEvents {
  final int posts;

  UpdateDataEvent({required this.posts});
}
