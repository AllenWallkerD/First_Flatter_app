import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/api/product.dart';
import 'package:app/models/product_model.dart';

abstract class TopSellingEvent {}
class LoadTopSelling extends TopSellingEvent {}

abstract class TopSellingState {}
class TopSellingLoading extends TopSellingState {}
class TopSellingLoaded extends TopSellingState {
  final List<ProductModel> items;
  TopSellingLoaded(this.items);
}
class TopSellingError extends TopSellingState {}

class TopSellingBloc extends Bloc<TopSellingEvent, TopSellingState> {
  final Product product;

  TopSellingBloc(this.product) : super(TopSellingLoading()) {
    on<LoadTopSelling>((event, emit) async {
      try {
        emit(TopSellingLoading());
        final response = await product.getTopSellingProducts();
        emit(TopSellingLoaded(response.products));
      } catch (e) {
        emit(TopSellingError());
      }
    });
  }
}