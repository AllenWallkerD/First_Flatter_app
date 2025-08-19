import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/api/product.dart';
import 'package:app/models/product_model.dart';

abstract class TopSellingEvent {}

class LoadTopSelling extends TopSellingEvent {
  final int? limit;
  LoadTopSelling({this.limit});
}

class RefreshTopSelling extends TopSellingEvent {
  final int? limit;
  RefreshTopSelling({this.limit});
}

abstract class TopSellingState {}

class TopSellingLoading extends TopSellingState {}

class TopSellingLoaded extends TopSellingState {
  final List<ProductModel> items;
  TopSellingLoaded(this.items);
}

class TopSellingError extends TopSellingState {
  final String message;
  TopSellingError(this.message);
}

class TopSellingBloc extends Bloc<TopSellingEvent, TopSellingState> {
  final Product product;

  TopSellingBloc(this.product) : super(TopSellingLoading()) {
    on<LoadTopSelling>(_onLoadTopSelling);
    on<RefreshTopSelling>(_onRefreshTopSelling);
  }

  Future<void> _onLoadTopSelling(
      LoadTopSelling event,
      Emitter<TopSellingState> emit,
      ) async {
    try {
      emit(TopSellingLoading());
      final products = await product.getTopSellingProducts(
        limit: event.limit ?? 10,
      );
      emit(TopSellingLoaded(products as List<ProductModel>));
    } catch (e) {
      emit(TopSellingError('Failed to load top selling products: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshTopSelling(
      RefreshTopSelling event,
      Emitter<TopSellingState> emit,
      ) async {
    try {
      final products = await product.getTopSellingProducts(
        limit: event.limit ?? 10,
      );
      emit(TopSellingLoaded(products as List<ProductModel>));
    } catch (e) {
      emit(TopSellingError('Failed to refresh top selling products: ${e.toString()}'));
    }
  }
}