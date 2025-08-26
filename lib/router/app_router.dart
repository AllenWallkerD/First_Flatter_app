import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import '../features/splash/splash_screen.dart';
import '../features/auth/sign_in.dart';
import '../features/auth/sign_in_password.dart';
import '../features/auth/create_account.dart';
import '../features/auth/forgot_password.dart';
import '../features/auth/reset_password.dart';
import '../features/home/about.dart';
import '../features/home/category/categories_list.dart';
import '../features/main_navigation/presentation/screens/main_tabs_screen.dart';
import '../features/notifications/notifications_page.dart';
import '../features/profile/profile_page.dart';
import '../features/home/see_all_page.dart';
import '../presentation/pages/home/home_page.dart';
import '../presentation/pages/cart/cart_page.dart';
import '../presentation/pages/orders/orders_page.dart';
import '../presentation/pages/category/category_products_page.dart';
import '../presentation/pages/products/products_grid_page.dart';
import '../presentation/pages/products/product_detail_page.dart';
import '../domain/entities/product.dart';

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
      path: '/main',
      page: MainTabNavigatorRoute.page,
      children: [
        AutoRoute(path: '', page: HomePageRoute.page),
        AutoRoute(path: 'notifications', page: NotificationsRoute.page),
        AutoRoute(path: 'orders', page: OrdersPageRoute.page),
        AutoRoute(path: 'profile', page: ProfileRoute.page),
      ],
    ),
    AutoRoute(
      path: '/cart',
      page: CartPageRoute.page,
    ),
    AutoRoute(
      path: '/about',
      page: AboutRoute.page,
    ),
    AutoRoute(
      path: '/categories-list',
      page: CategoriesListRoute.page,
    ),
    AutoRoute(
      path: '/see-all-page/:type',
      page: SeeAllPageRoute.page,
    ),
    AutoRoute(
      path: '/category-products',
      page: CategoryProductsPageRoute.page,
    ),
    AutoRoute(
      path: '/products-grid/:type',
      page: ProductsGridPageRoute.page,
    ),
    AutoRoute(
      path: '/product-detail',
      page: ProductDetailPageRoute.page,
    ),
  ];
}