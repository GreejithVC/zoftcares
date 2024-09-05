import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../constants/enums.dart';
import '../../controllers/splash/splash_bloc.dart';
import '../../controllers/splash/splash_event.dart';
import '../../controllers/splash/splash_state.dart';
import '../../utils/widget_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SplashBloc>(context).add(StartTimerEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBodyWidget(context),
    );
  }

  Widget _buildBodyWidget(BuildContext context) {
    return BlocSelector<SplashBloc, SplashStates, PageState>(
        selector: (SplashStates state) => state.pageState,
        builder: (context, PageState data) {
          return data == PageState.error
              ? WidgetUtils.errorWidget("Something went wrong",
                  color: AppColors.textBlackColor)
              : WidgetUtils.logoWidget();
        });
  }
}
