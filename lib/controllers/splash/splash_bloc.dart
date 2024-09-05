import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoftcares/constants/enums.dart';
import 'package:zoftcares/controllers/splash/splash_event.dart';
import 'package:zoftcares/controllers/splash/splash_state.dart';

import '../../main.dart';
import '../../repo/shared_preference_repository.dart';
import '../../ui/pages/login_screen.dart';
import '../../ui/pages/post_list_screen.dart';

class SplashBloc extends Bloc<SplashEvents, SplashStates> {
  SplashBloc() : super(SplashStates(pageState: PageState.initial)) {
    startTimer();
  }

  @override
  Stream<SplashStates> mapEventToState(SplashEvents event) async* {
    if (event is StartTimerEvent) {
      startTimer();
    } else if (event is UpdatePageStatusEvent) {
      yield SplashStates(pageState: event.pageState);
    }
  }

  Future<void> startTimer() async {
    await Future.delayed(const Duration(seconds: 3));
    await checkUserToken();
  }

  Future<void> checkUserToken() async {
    try {
      String? token = await SharedPreferenceRepository.getToken();
      if (token.isNotEmpty == true) {
        loadHomeScreen();
      } else {
        loadSignInScreen();
      }
      add(UpdatePageStatusEvent(pageState: PageState.success));
    } on SocketException {
      add(UpdatePageStatusEvent(pageState: PageState.error));
    } catch (onError) {
      add(UpdatePageStatusEvent(pageState: PageState.error));
    }
  }

  loadHomeScreen() {
    // BlocProvider.of<HomeBloc>(navigatorKey.currentContext!).add(FetchDataEvent());
    Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => const PostListScreen(),
        ),
        (Route<dynamic> route) => false);
  }

  loadSignInScreen() {
    Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
        (Route<dynamic> route) => false);
  }
}
