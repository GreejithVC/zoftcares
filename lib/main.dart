import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoftcares/controllers/post/post_bloc.dart';
import 'package:zoftcares/ui/pages/splash_screen.dart';

import 'constants/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/auth/auth_bloc.dart';
import 'controllers/splash/splash_bloc.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(create: (BuildContext context) => SplashBloc()),
        BlocProvider<AuthBloc>(create: (BuildContext context) => AuthBloc()),
        BlocProvider<PostBloc>(create: (BuildContext context) => PostBloc()),
      ],
      child: MaterialApp(
        navigatorKey:navigatorKey ,
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        home:  const SplashScreen(),
      ),
    );
  }
}