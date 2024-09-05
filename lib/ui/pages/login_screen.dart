import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_validators.dart';
import '../../constants/enums.dart';
import '../../controllers/auth/auth_bloc.dart';
import '../../controllers/auth/auth_event.dart';
import '../../controllers/auth/auth_state.dart';
import '../../utils/widget_utils.dart';
import '../../utils/widgets/app_button.dart';
import '../../constants/app_strings.dart';
import '../../utils/widgets/app_textformfield.dart';
import '../../constants/app_theme.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      onWillPop: () => WidgetUtils.showExitPopUp(context),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Form(
              key: _formKey,
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Spacer(),
                    _titleView(),
                    const SizedBox(height: 20),
                    const Spacer(),
                    _emailView(),
                    const SizedBox(height: 16),
                    _passwordView(),
                    const Spacer(),
                    const SizedBox(height: 20),
                    _buttonView(),
                    const SizedBox(height: 50),
                    _versionView(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleView() {
    return Text(
      AppStrings.appName.toUpperCase(),
      style: appTheme.textTheme.headlineMedium,
    );
  }

  Widget _versionView() {
    return BlocSelector<AuthBloc, AuthStates, String?>(
        selector: (AuthStates state) => state.version,
        builder: (context, String? data) {
          return Text(
            "App Version - ${data ?? " "}",
            style: appTheme.textTheme.bodySmall,
          );
        });
  }

  Widget _emailView() {
    return AppTextFormField(
      controller: emailController,
      label: AppStrings.email,
      validator: AppValidators.email,
    );
  }

  Widget _passwordView() {
    return AppTextFormField(
      controller: passwordController,
      label: AppStrings.password,
      validator: AppValidators.password,
    );
  }

  Widget _buttonView() {
    return BlocSelector<AuthBloc, AuthStates, PageState>(
        selector: (AuthStates state) => state.pageState,
        builder: (context, PageState data) {
          return AppButton(
              title: AppStrings.login,
              isLoading: data == PageState.loading,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  BlocProvider.of<AuthBloc>(context).add(LoginEvent(
                      email: emailController.text,
                      password: passwordController.text));
                }
              });
        });
  }
}
