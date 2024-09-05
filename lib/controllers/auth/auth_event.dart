import 'package:zoftcares/constants/enums.dart';

abstract class AuthEvents {}

class LoginEvent extends AuthEvents {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class UpdateAuthStatusEvent extends AuthEvents {
  final PageState pageState;

  UpdateAuthStatusEvent({required this.pageState});
}

class UpdateVersionEvent extends AuthEvents {
  final String? version;

  UpdateVersionEvent({required this.version});
}

class LogoutEvent extends AuthEvents {}
