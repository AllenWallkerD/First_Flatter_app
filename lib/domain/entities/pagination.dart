import 'package:equatable/equatable.dart';

class PaginatedResult<T> extends Equatable {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginatedResult({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  @override
  List<Object?> get props => [
        items,
        currentPage,
        totalPages,
        totalItems,
        hasNextPage,
        hasPreviousPage,
      ];
}

class PaginationParams extends Equatable {
  final int page;
  final int limit;

  const PaginationParams({
    required this.page,
    required this.limit,
  });

  @override
  List<Object?> get props => [page, limit];
}
