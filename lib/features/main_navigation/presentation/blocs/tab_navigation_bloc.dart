import 'package:flutter_bloc/flutter_bloc.dart';

enum TabItem { home, notifications, orders, profile }

class TabNavigationEvent {
  final TabItem tab;
  TabNavigationEvent(this.tab);
}

class TabNavigationBloc extends Bloc<TabNavigationEvent, TabItem> {
  TabNavigationBloc() : super(TabItem.home) {
    on<TabNavigationEvent>((event, emit) => emit(event.tab));
  }
}