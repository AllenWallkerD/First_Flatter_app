import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/pagination.dart';
import '../../../domain/usecases/get_products.dart';
import '../../../core/constants/api_constants.dart';

abstract class TopSellingEvent extends Equatable {
  const TopSellingEvent();

  @override
  List<Object> get props => [];
}

class LoadTopSelling extends TopSellingEvent {
  final int page;
  final int limit;

  const LoadTopSelling({
    this.page = 1,
    this.limit = ApiConstants.defaultPageSize,
  });

  @override
  List<Object> get props => [page, limit];
}

class LoadMoreTopSelling extends TopSellingEvent {
  const LoadMoreTopSelling();
}

class RefreshTopSelling extends TopSellingEvent {
  const RefreshTopSelling();
}

abstract class TopSellingState extends Equatable {
  const TopSellingState();

  @override
  List<Object> get props => [];
}

class TopSellingInitial extends TopSellingState {
  const TopSellingInitial();
}

class TopSellingLoading extends TopSellingState {
  const TopSellingLoading();
}

class TopSellingLoaded extends TopSellingState {
  final List<Product> products;
  final bool hasReachedMax;
  final int currentPage;
  final bool isLoadingMore;

  const TopSellingLoaded({
    required this.products,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.isLoadingMore = false,
  });

  TopSellingLoaded copyWith({
    List<Product>? products,
    bool? hasReachedMax,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return TopSellingLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [products, hasReachedMax, currentPage, isLoadingMore];
}

class TopSellingError extends TopSellingState {
  final String message;

  const TopSellingError(this.message);

  @override
  List<Object> get props => [message];
}

class TopSellingBloc extends Bloc<TopSellingEvent, TopSellingState> {
  final GetTopSellingProducts getTopSellingProducts;

  TopSellingBloc({required this.getTopSellingProducts}) : super(const TopSellingInitial()) {
    on<LoadTopSelling>(_onLoadTopSelling);
    on<LoadMoreTopSelling>(_onLoadMoreTopSelling);
    on<RefreshTopSelling>(_onRefreshTopSelling);
  }

  Future<void> _onLoadTopSelling(LoadTopSelling event, Emitter<TopSellingState> emit) async {
    if (state is! TopSellingLoaded) {
      emit(const TopSellingLoading());
    }

    final params = PaginationParams(page: event.page, limit: event.limit);
    final result = await getTopSellingProducts(params);

    result.fold(
      (failure) {
        emit(TopSellingError(failure.message));
      },
      (paginatedResult) {
        emit(TopSellingLoaded(
          products: paginatedResult.items,
          hasReachedMax: !paginatedResult.hasNextPage,
          currentPage: paginatedResult.currentPage,
        ));
      },
    );
  }

  Future<void> _onLoadMoreTopSelling(LoadMoreTopSelling event, Emitter<TopSellingState> emit) async {
    final currentState = state;
    if (currentState is TopSellingLoaded && !currentState.hasReachedMax && !currentState.isLoadingMore) {
      emit(currentState.copyWith(isLoadingMore: true));

      final nextPage = currentState.currentPage + 1;
      final params = PaginationParams(page: nextPage, limit: ApiConstants.defaultPageSize);
      final result = await getTopSellingProducts(params);

      result.fold(
        (failure) => emit(currentState.copyWith(isLoadingMore: false)),
        (paginatedResult) {
          final allProducts = List<Product>.from(currentState.products)
            ..addAll(paginatedResult.items);
          
          emit(TopSellingLoaded(
            products: allProducts,
            hasReachedMax: !paginatedResult.hasNextPage,
            currentPage: paginatedResult.currentPage,
            isLoadingMore: false,
          ));
        },
      );
    }
  }

  Future<void> _onRefreshTopSelling(RefreshTopSelling event, Emitter<TopSellingState> emit) async {
    emit(const TopSellingLoading());
    add(const LoadTopSelling(page: 1));
  }
}
