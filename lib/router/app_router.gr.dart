// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AboutRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const About(),
      );
    },
    CartPageRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CartPage(),
      );
    },
    CategoriesListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CategoriesList(),
      );
    },
    CategoryListPageRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CategoryListPage(),
      );
    },
    CategoryProductsPageRoute.name: (routeData) {
      final args = routeData.argsAs<CategoryProductsPageRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CategoryProductsPage(
          key: args.key,
          categoryName: args.categoryName,
          categoryDisplayName: args.categoryDisplayName,
        ),
      );
    },
    CreateAccountRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CreateAccount(),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ForgotPassword(),
      );
    },
    HomePageRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    MainTabNavigatorRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainTabNavigator(),
      );
    },
    NewInPageRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NewInPage(),
      );
    },
    NotificationsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const Notifications(),
      );
    },
    OrdersPageRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OrdersPage(),
      );
    },
    ProductDetailPageRoute.name: (routeData) {
      final args = routeData.argsAs<ProductDetailPageRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProductDetailPage(
          key: args.key,
          product: args.product,
        ),
      );
    },
    ProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const Profile(),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ResetPassword(),
      );
    },
    SeeAllPageRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SeeAllPageRouteArgs>(
          orElse: () =>
              SeeAllPageRouteArgs(type: pathParams.getString('type')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SeeAllPage(
          type: args.type,
          key: args.key,
        ),
      );
    },
    SignInRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SignIn(),
      );
    },
    SignInPasswordRoute.name: (routeData) {
      final args = routeData.argsAs<SignInPasswordRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SignInPassword(
          key: args.key,
          email: args.email,
        ),
      );
    },
    SplashScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
    TopSellingPageRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TopSellingPage(),
      );
    },
  };
}

/// generated route for
/// [About]
class AboutRoute extends PageRouteInfo<void> {
  const AboutRoute({List<PageRouteInfo>? children})
      : super(
          AboutRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CartPage]
class CartPageRoute extends PageRouteInfo<void> {
  const CartPageRoute({List<PageRouteInfo>? children})
      : super(
          CartPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartPageRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CategoriesList]
class CategoriesListRoute extends PageRouteInfo<void> {
  const CategoriesListRoute({List<PageRouteInfo>? children})
      : super(
          CategoriesListRoute.name,
          initialChildren: children,
        );

  static const String name = 'CategoriesListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CategoryListPage]
class CategoryListPageRoute extends PageRouteInfo<void> {
  const CategoryListPageRoute({List<PageRouteInfo>? children})
      : super(
          CategoryListPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'CategoryListPageRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CategoryProductsPage]
class CategoryProductsPageRoute
    extends PageRouteInfo<CategoryProductsPageRouteArgs> {
  CategoryProductsPageRoute({
    Key? key,
    required String categoryName,
    required String categoryDisplayName,
    List<PageRouteInfo>? children,
  }) : super(
          CategoryProductsPageRoute.name,
          args: CategoryProductsPageRouteArgs(
            key: key,
            categoryName: categoryName,
            categoryDisplayName: categoryDisplayName,
          ),
          initialChildren: children,
        );

  static const String name = 'CategoryProductsPageRoute';

  static const PageInfo<CategoryProductsPageRouteArgs> page =
      PageInfo<CategoryProductsPageRouteArgs>(name);
}

class CategoryProductsPageRouteArgs {
  const CategoryProductsPageRouteArgs({
    this.key,
    required this.categoryName,
    required this.categoryDisplayName,
  });

  final Key? key;

  final String categoryName;

  final String categoryDisplayName;

  @override
  String toString() {
    return 'CategoryProductsPageRouteArgs{key: $key, categoryName: $categoryName, categoryDisplayName: $categoryDisplayName}';
  }
}

/// generated route for
/// [CreateAccount]
class CreateAccountRoute extends PageRouteInfo<void> {
  const CreateAccountRoute({List<PageRouteInfo>? children})
      : super(
          CreateAccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateAccountRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ForgotPassword]
class ForgotPasswordRoute extends PageRouteInfo<void> {
  const ForgotPasswordRoute({List<PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomePage]
class HomePageRoute extends PageRouteInfo<void> {
  const HomePageRoute({List<PageRouteInfo>? children})
      : super(
          HomePageRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomePageRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainTabNavigator]
class MainTabNavigatorRoute extends PageRouteInfo<void> {
  const MainTabNavigatorRoute({List<PageRouteInfo>? children})
      : super(
          MainTabNavigatorRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainTabNavigatorRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NewInPage]
class NewInPageRoute extends PageRouteInfo<void> {
  const NewInPageRoute({List<PageRouteInfo>? children})
      : super(
          NewInPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'NewInPageRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [Notifications]
class NotificationsRoute extends PageRouteInfo<void> {
  const NotificationsRoute({List<PageRouteInfo>? children})
      : super(
          NotificationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OrdersPage]
class OrdersPageRoute extends PageRouteInfo<void> {
  const OrdersPageRoute({List<PageRouteInfo>? children})
      : super(
          OrdersPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrdersPageRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProductDetailPage]
class ProductDetailPageRoute extends PageRouteInfo<ProductDetailPageRouteArgs> {
  ProductDetailPageRoute({
    Key? key,
    required Product product,
    List<PageRouteInfo>? children,
  }) : super(
          ProductDetailPageRoute.name,
          args: ProductDetailPageRouteArgs(
            key: key,
            product: product,
          ),
          initialChildren: children,
        );

  static const String name = 'ProductDetailPageRoute';

  static const PageInfo<ProductDetailPageRouteArgs> page =
      PageInfo<ProductDetailPageRouteArgs>(name);
}

class ProductDetailPageRouteArgs {
  const ProductDetailPageRouteArgs({
    this.key,
    required this.product,
  });

  final Key? key;

  final Product product;

  @override
  String toString() {
    return 'ProductDetailPageRouteArgs{key: $key, product: $product}';
  }
}

/// generated route for
/// [Profile]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ResetPassword]
class ResetPasswordRoute extends PageRouteInfo<void> {
  const ResetPasswordRoute({List<PageRouteInfo>? children})
      : super(
          ResetPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SeeAllPage]
class SeeAllPageRoute extends PageRouteInfo<SeeAllPageRouteArgs> {
  SeeAllPageRoute({
    required String type,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          SeeAllPageRoute.name,
          args: SeeAllPageRouteArgs(
            type: type,
            key: key,
          ),
          rawPathParams: {'type': type},
          initialChildren: children,
        );

  static const String name = 'SeeAllPageRoute';

  static const PageInfo<SeeAllPageRouteArgs> page =
      PageInfo<SeeAllPageRouteArgs>(name);
}

class SeeAllPageRouteArgs {
  const SeeAllPageRouteArgs({
    required this.type,
    this.key,
  });

  final String type;

  final Key? key;

  @override
  String toString() {
    return 'SeeAllPageRouteArgs{type: $type, key: $key}';
  }
}

/// generated route for
/// [SignIn]
class SignInRoute extends PageRouteInfo<void> {
  const SignInRoute({List<PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SignInPassword]
class SignInPasswordRoute extends PageRouteInfo<SignInPasswordRouteArgs> {
  SignInPasswordRoute({
    Key? key,
    required String email,
    List<PageRouteInfo>? children,
  }) : super(
          SignInPasswordRoute.name,
          args: SignInPasswordRouteArgs(
            key: key,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'SignInPasswordRoute';

  static const PageInfo<SignInPasswordRouteArgs> page =
      PageInfo<SignInPasswordRouteArgs>(name);
}

class SignInPasswordRouteArgs {
  const SignInPasswordRouteArgs({
    this.key,
    required this.email,
  });

  final Key? key;

  final String email;

  @override
  String toString() {
    return 'SignInPasswordRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [SplashScreen]
class SplashScreenRoute extends PageRouteInfo<void> {
  const SplashScreenRoute({List<PageRouteInfo>? children})
      : super(
          SplashScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TopSellingPage]
class TopSellingPageRoute extends PageRouteInfo<void> {
  const TopSellingPageRoute({List<PageRouteInfo>? children})
      : super(
          TopSellingPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'TopSellingPageRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
