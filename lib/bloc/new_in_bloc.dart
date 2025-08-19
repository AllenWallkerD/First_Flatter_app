import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/api/product.dart';
import 'package:app/models/product_model.dart';

abstract class NewInEvent {}

class LoadNewIn extends NewInEvent {
  final int? limit;
  LoadNewIn({this.limit});
}

class RefreshNewIn extends NewInEvent {
  final int? limit;
  RefreshNewIn({this.limit});
}

abstract class NewInState {}

class NewInLoading extends NewInState {}

class NewInLoaded extends NewInState {
  final List<ProductModel> items;
  NewInLoaded(this.items);
}

class NewInError extends NewInState {
  final String message;
  NewInError(this.message);
}

class NewInBloc extends Bloc<NewInEvent, NewInState> {
  final Product product;

  NewInBloc(this.product) : super(NewInLoading()) {
    on<LoadNewIn>(_onLoadNewIn);
    on<RefreshNewIn>(_onRefreshNewIn);
  }

  Future<void> _onLoadNewIn(
      LoadNewIn event,
      Emitter<NewInState> emit,
      ) async {
    try {
      emit(NewInLoading());
      final products = await product.getNewInProducts(
        limit: event.limit ?? 10,
      );
      emit(NewInLoaded(products));
    } catch (e) {
      emit(NewInError('Failed to load new in products: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshNewIn(
      RefreshNewIn event,
      Emitter<NewInState> emit,
      ) async {
    try {
      final products = await product.getNewInProducts(
        limit: event.limit ?? 10,
      );
      emit(NewInLoaded(products));
    } catch (e) {
      emit(NewInError('Failed to refresh new in products: ${e.toString()}'));
    }
  }
}