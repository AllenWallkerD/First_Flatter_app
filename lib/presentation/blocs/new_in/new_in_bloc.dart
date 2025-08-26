import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/get_products.dart';

abstract class NewInEvent extends Equatable {
  const NewInEvent();

  @override
  List<Object> get props => [];
}

class LoadNewIn extends NewInEvent {
  final int limit;

  const LoadNewIn({this.limit = 10});

  @override
  List<Object> get props => [limit];
}

class RefreshNewIn extends NewInEvent {
  const RefreshNewIn();
}

abstract class NewInState extends Equatable {
  const NewInState();

  @override
  List<Object> get props => [];
}

class NewInInitial extends NewInState {
  const NewInInitial();
}

class NewInLoading extends NewInState {
  const NewInLoading();
}

class NewInLoaded extends NewInState {
  final List<Product> products;

  const NewInLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class NewInError extends NewInState {
  final String message;

  const NewInError(this.message);

  @override
  List<Object> get props => [message];
}

class NewInBloc extends Bloc<NewInEvent, NewInState> {
  final GetNewInProducts getNewInProducts;

  NewInBloc({required this.getNewInProducts}) : super(const NewInInitial()) {
    on<LoadNewIn>(_onLoadNewIn);
    on<RefreshNewIn>(_onRefreshNewIn);
  }

  Future<void> _onLoadNewIn(LoadNewIn event, Emitter<NewInState> emit) async {
    if (state is! NewInLoaded) {
      emit(const NewInLoading());
    }

    final result = await getNewInProducts(limit: event.limit);

    result.fold(
      (failure) {
        emit(NewInError(failure.message));
      },
      (products) {
        emit(NewInLoaded(products));
      },
    );
  }

  Future<void> _onRefreshNewIn(RefreshNewIn event, Emitter<NewInState> emit) async {
    emit(const NewInLoading());
    add(const LoadNewIn());
  }
}
