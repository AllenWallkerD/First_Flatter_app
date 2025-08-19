import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/main_navigation/presentation/blocs/tab_navigation_bloc.dart';

@RoutePage()
class MainTabNavigator extends StatelessWidget {
  const MainTabNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TabNavigationBloc(),
      child: BlocBuilder<TabNavigationBloc, TabItem>(
        builder: (context, activeTab) {
          return AutoTabsScaffold(
            routes: const [
              HomeRoute(),
              NotificationsRoute(),
              CartRoute(),
              ProfileRoute(),
            ],
            bottomNavigationBuilder: (_, tabsRouter) {
              return BottomNavigationBar(
                currentIndex: tabsRouter.activeIndex,
                onTap: tabsRouter.setActiveIndex,
                selectedItemColor: Colors.purple[700],
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle: const TextStyle(fontSize: 12),
                unselectedLabelStyle: const TextStyle(fontSize: 12),
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icons/home.svg',
                      colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/icons/home.svg',
                      colorFilter: ColorFilter.mode(Colors.purple[700]!, BlendMode.srcIn),
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icons/notification.svg',
                      colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/icons/notifications.svg',
                      colorFilter: ColorFilter.mode(Colors.purple[700]!, BlendMode.srcIn),
                    ),
                    label: 'Notifications',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icons/cart.svg',
                      colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/icons/cart.svg',
                      colorFilter: ColorFilter.mode(Colors.purple[700]!, BlendMode.srcIn),
                    ),
                    label: 'Cart',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icons/profile.svg',
                      colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/icons/profile.svg',
                      colorFilter: ColorFilter.mode(Colors.purple[700]!, BlendMode.srcIn),
                    ),
                    label: 'Profile',
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}