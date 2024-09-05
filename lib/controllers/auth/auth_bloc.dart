import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoftcares/constants/enums.dart';

import '../../main.dart';
import '../../models/auth_model.dart';
import '../../networks/api_handler.dart';
import '../../repo/shared_preference_repository.dart';
import '../../services/auth_service.dart';
import '../../ui/pages/login_screen.dart';
import '../../ui/pages/post_list_screen.dart';
import '../../utils/widget_utils.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  AuthBloc() : super(AuthStates(pageState: PageState.initial, version: null)) {
    _fetchAppVersion();
  }

  String? appVersion;
  Timer? _sessionTimer;

  @override
  Stream<AuthStates> mapEventToState(AuthEvents event) async* {
    if (event is LoginEvent) {
      signIn(event.email, event.password);
    } else if (event is UpdateAuthStatusEvent) {
      yield AuthStates(pageState: event.pageState, version: state.version);
    } else if (event is UpdateVersionEvent) {
      yield AuthStates(pageState: state.pageState, version: state.version);
    }
    // else if (event is LogoutEvent) {
    //   logoutAlertBox();
    // }
  }

  Future<void> _fetchAppVersion() async {
    try {
      final response = await AuthService().fetchAppVersion();
      appVersion = response.data?.version;
      if (appVersion?.isNotEmpty == true) {
        add(UpdateVersionEvent(version: response.data?.version));
      }
    } catch (e) {}
  }

  Future<void> signIn(String email, String password) async {
    add(UpdateAuthStatusEvent(pageState: PageState.loading));
    try {
      final AuthModel authResponse =
          await AuthService().login(email: email, password: password);
      if (authResponse.status == true) {
        startSessionTimer(authResponse.data!.validity!);
        loadHomeScreen(loginModel: authResponse.data!);
      } else {
        WidgetUtils.showSnackBar(authResponse.error);
      }
      add(UpdateAuthStatusEvent(pageState: PageState.success));
    } catch (e) {
      WidgetUtils.showSnackBar(e.toString());
      add(UpdateAuthStatusEvent(pageState: PageState.error));
    }
  }

  void loadHomeScreen({required LoginModel loginModel}) async {
    authToken = loginModel.accessToken;
    await SharedPreferenceRepository.setToken(loginModel.accessToken!);
    Navigator.pushReplacement(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (final context) => const PostListScreen()),
    );
  }

  void startSessionTimer(int tokenValidity) {
    if (_sessionTimer != null) {
      _sessionTimer!.cancel();
    }
    debugPrint("tokenValidity -- $tokenValidity");
    _sessionTimer = Timer(Duration(milliseconds: tokenValidity), () {
      _handleSessionExpiry();
    });
  }

  void _handleSessionExpiry() {
    signOut();
    _showSessionExpiredNotification();
  }

  void _showSessionExpiredNotification() {
    print(DateTime.now());
    debugPrint("_showSessionExpiredNotification -- ");
    WidgetUtils.showSnackBar('Your session has expired. Please log in again.');
  }

  void stopSessionTimer() {
    if (_sessionTimer != null) {
      _sessionTimer!.cancel();
    }
  }

  Future<void> signOut() async {
    await SharedPreferenceRepository.setToken("");
    loadLoginScreen();
    stopSessionTimer();
  }

  loadLoginScreen() {
    // intiController();
    Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
        (Route<dynamic> route) => false);
  }
}
