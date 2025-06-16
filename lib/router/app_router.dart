import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import '../features/splash/splash_screen.dart';
import '../features/auth/sign_in.dart';
import '../features/auth/sign_in_password.dart';
import '../features/auth/create_account.dart';
import '../features/auth/forgot_password.dart';
import '../features/auth/reset_password.dart';
import '../features/home/home.dart';
import '../features/home/about.dart';
import '../features/home/category/categories_list.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/',
      page: SplashScreenRoute.page,
      initial: true,
    ),
    AutoRoute(
      path: '/sign-in',
      page: SignInRoute.page,
    ),
    AutoRoute(
      path: '/sign-in-password',
      page: SignInPasswordRoute.page,
    ),
    AutoRoute(
      path: '/create-account',
      page: CreateAccountRoute.page,
    ),
    AutoRoute(
      path: '/forgot-password',
      page: ForgotPasswordRoute.page,
    ),
    AutoRoute(
      path: '/reset-password',
      page: ResetPasswordRoute.page,
    ),
    AutoRoute(
      path: '/home',
      page: HomePageRoute.page,
    ),
    AutoRoute(
      path: '/about',
      page: AboutRoute.page,
    ),
    AutoRoute(
      path: '/categories-list',
      page: CategoriesListRoute.page,
    ),
  ];
}
