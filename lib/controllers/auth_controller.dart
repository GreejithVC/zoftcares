import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zoftcares/services/auth_service.dart';

import '../constants/enums.dart';
import '../main.dart';
import '../models/auth_model.dart';
import '../networks/api_handler.dart';
import '../repo/shared_preference_repository.dart';
import '../ui/pages/post_list_screen.dart';
import '../ui/pages/login_screen.dart';
import '../utils/widget_utils.dart';

class AuthController with ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? error;
  String? appVersion;
  Timer? _sessionTimer;

  PageState _pageState = PageState.loading;

  set pageState(final PageState value) {
    _pageState = value;
    notifyListeners();
  }

  PageState get pageState => _pageState;

  intiController() {
    _pageState = PageState.initial;
    _fetchAppVersion();
    emailController.clear();
    passwordController.clear();
  }

  Future<bool> _fetchAppVersion() async {
    try {
      final response = await AuthService().fetchAppVersion();
      appVersion = response.data?.version ?? "";

      ///is it neccessary to handle error here or simply put page status as true///
      if (appVersion?.isNotEmpty == true) {
        error = null;
        pageState = PageState.success;
      } else {
        error = ' ';
        pageState = PageState.error;
      }
      return true;
    } on SocketException {
      error = 'Network Issue';
      pageState = PageState.error;
      return false;
    } catch (e) {
      error = e.toString();
      pageState = PageState.error;
      return false;
    }
  }

  Future<void> signIn() async {
    pageState = PageState.loading;
    try {
      final AuthModel authResponse = await AuthService().login(
          email: emailController.text, password: passwordController.text);
      if (authResponse.status == true) {
        startSessionTimer(authResponse.data!.validity!);

        loadHomeScreen(loginModel: authResponse.data!);
      } else {
        WidgetUtils.showSnackBar(authResponse.error);
      }
      pageState = PageState.success;
    } catch (e) {
      debugPrint(e.toString());
      WidgetUtils.showSnackBar(e.toString());
      pageState = PageState.error;
    }
  }

  logoutAlertBox() {
    WidgetUtils.showLogoutPopUp(navigatorKey.currentContext!,
        sBtnFunction: () => signOut());
  }

  Future<void> signOut() async {
    await SharedPreferenceRepository.setToken("");
    loadLoginScreen();
    stopSessionTimer();
  }

  loadHomeScreen({required LoginModel loginModel}) async {
    authToken = loginModel.accessToken;
    await SharedPreferenceRepository.setToken(loginModel.accessToken!);
    Navigator.pushReplacement(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (final context) => const PostListScreen()),
    );
  }

  loadLoginScreen() {
    intiController();
    Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
        (Route<dynamic> route) => false);
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
}
