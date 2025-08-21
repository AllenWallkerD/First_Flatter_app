import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/pagination.dart';
import '../../../domain/usecases/get_products.dart';
import '../../../domain/usecases/get_products_by_category.dart';
import '../../../core/constants/api_constants.dart';

// Events
abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductsEvent {
  final int page;
  final int limit;

  const LoadProducts({
    this.page = 1,
    this.limit = ApiConstants.defaultPageSize,
  });

  @override
  List<Object> get props => [page, limit];
}

class LoadMoreProducts extends ProductsEvent {
  const LoadMoreProducts();
}

class RefreshProducts extends ProductsEvent {
  const RefreshProducts();
}

class LoadProductsByCategory extends ProductsEvent {
  final String category;
  final int limit;

  const LoadProductsByCategory(this.category, {this.limit = 50});

  @override
  List<Object> get props => [category, limit];
}

// States
abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final bool hasReachedMax;
  final int currentPage;
  final bool isLoadingMore;

  const ProductsLoaded({
    required this.products,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.isLoadingMore = false,
  });

  ProductsLoaded copyWith({
    List<Product>? products,
    bool? hasReachedMax,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [products, hasReachedMax, currentPage, isLoadingMore];
}

class ProductsByCategoryLoaded extends ProductsState {
  final List<Product> products;
  final String category;

  const ProductsByCategoryLoaded({
    required this.products,
    required this.category,
  });

  @override
  List<Object> get props => [products, category];
}

class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetTopSellingProducts getTopSellingProducts;
  final GetProductsByCategory getProductsByCategory;

  ProductsBloc({
    required this.getTopSellingProducts,
    required this.getProductsByCategory,
  }) : super(const ProductsInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<RefreshProducts>(_onRefreshProducts);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductsState> emit) async {
    if (state is! ProductsLoaded) {
      emit(const ProductsLoading());
    }

    final params = PaginationParams(page: event.page, limit: event.limit);
    final result = await getTopSellingProducts(params);

    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (paginatedResult) => emit(ProductsLoaded(
        products: paginatedResult.items,
        hasReachedMax: !paginatedResult.hasNextPage,
        currentPage: paginatedResult.currentPage,
      )),
    );
  }

  Future<void> _onLoadMoreProducts(LoadMoreProducts event, Emitter<ProductsState> emit) async {
    final currentState = state;
    if (currentState is ProductsLoaded && !currentState.hasReachedMax && !currentState.isLoadingMore) {
      emit(currentState.copyWith(isLoadingMore: true));

      final nextPage = currentState.currentPage + 1;
      final params = PaginationParams(page: nextPage, limit: ApiConstants.defaultPageSize);
      final result = await getTopSellingProducts(params);

      result.fold(
        (failure) => emit(currentState.copyWith(isLoadingMore: false)),
        (paginatedResult) {
          final allProducts = List<Product>.from(currentState.products)
            ..addAll(paginatedResult.items);
          
          emit(ProductsLoaded(
            products: allProducts,
            hasReachedMax: !paginatedResult.hasNextPage,
            currentPage: paginatedResult.currentPage,
            isLoadingMore: false,
          ));
        },
      );
    }
  }

  Future<void> _onRefreshProducts(RefreshProducts event, Emitter<ProductsState> emit) async {
    emit(const ProductsLoading());
    add(const LoadProducts(page: 1));
  }

  Future<void> _onLoadProductsByCategory(LoadProductsByCategory event, Emitter<ProductsState> emit) async {
    emit(const ProductsLoading());

    final result = await getProductsByCategory(event.category, limit: event.limit);

    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (products) => emit(ProductsByCategoryLoaded(
        products: products,
        category: event.category,
      )),
    );
  }
}
