import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/api/product.dart';
import 'package:app/models/product_model.dart';

abstract class NewInEvent {}
class LoadNewIn extends NewInEvent {}

abstract class NewInState {}
class NewInLoading extends NewInState {}
class NewInLoaded extends NewInState {
  final List<ProductModel> items;
  NewInLoaded(this.items);
}
class NewInError extends NewInState {}

class NewInBloc extends Bloc<NewInEvent, NewInState> {
  final Product product;

  NewInBloc(this.product) : super(NewInLoading()) {
    on<LoadNewIn>((event, emit) async {
      try {
        emit(NewInLoading());
        final products = await product.getNewInProducts();
        emit(NewInLoaded(products));
      } catch (e) {
        emit(NewInError());
      }
    });
  }
}