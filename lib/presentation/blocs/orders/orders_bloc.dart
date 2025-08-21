import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/order.dart' as OrderEntity;
import '../../../domain/usecases/cart_usecases.dart';

// Events
abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class LoadOrderHistory extends OrdersEvent {
  const LoadOrderHistory();
}

class RefreshOrderHistory extends OrdersEvent {
  const RefreshOrderHistory();
}

// States
abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

class OrdersLoaded extends OrdersState {
  final List<OrderEntity.Order> orders;

  const OrdersLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrdersError extends OrdersState {
  final String message;

  const OrdersError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrderHistory getOrderHistory;

  OrdersBloc({required this.getOrderHistory}) : super(const OrdersInitial()) {
    on<LoadOrderHistory>(_onLoadOrderHistory);
    on<RefreshOrderHistory>(_onRefreshOrderHistory);
  }

  Future<void> _onLoadOrderHistory(LoadOrderHistory event, Emitter<OrdersState> emit) async {
    if (state is! OrdersLoaded) {
      emit(const OrdersLoading());
    }

    final result = await getOrderHistory();
    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (orders) => emit(OrdersLoaded(orders)),
    );
  }

  Future<void> _onRefreshOrderHistory(RefreshOrderHistory event, Emitter<OrdersState> emit) async {
    emit(const OrdersLoading());
    
    final result = await getOrderHistory();
    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (orders) => emit(OrdersLoaded(orders)),
    );
  }
}
