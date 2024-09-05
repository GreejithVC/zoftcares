import '../../constants/enums.dart';

abstract class SplashEvents {}

class StartTimerEvent extends SplashEvents {}

class UpdatePageStatusEvent extends SplashEvents {
  final PageState pageState;

  UpdatePageStatusEvent({required this.pageState});
}
