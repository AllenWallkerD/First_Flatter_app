import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../blocs/top_selling/top_selling_bloc.dart';
import '../../blocs/new_in/new_in_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/product/product_card.dart';
import '../../../router/app_router.dart';

enum ProductsType {
  topSelling,
  newIn,
}

@RoutePage()
class ProductsGridPage extends StatelessWidget {
  final String type;
  final ProductsType? productsType;
  final String? title;
  final String? emptyMessage;
  final String? loadingMessage;
  final bool? enablePagination;

  const ProductsGridPage({
    super.key,
    required this.type,
    this.productsType,
    this.title,
    this.emptyMessage,
    this.loadingMessage,
    this.enablePagination,
  });

  ProductsType get _productsType {
    return productsType ?? (type == 'top-selling' ? ProductsType.topSelling : ProductsType.newIn);
  }

  String get _title {
    return title ?? (type == 'top-selling' ? 'Top Selling' : 'New In');
  }

  String get _emptyMessage {
    return emptyMessage ?? (type == 'top-selling' ? 'No products found' : 'No new products found');
  }

  String get _loadingMessage {
    return loadingMessage ?? (type == 'top-selling' ? 'Loading top selling products...' : 'Loading new products...');
  }

  bool get _enablePagination {
    return enablePagination ?? (type == 'top-selling');
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        if (_productsType == ProductsType.topSelling)
          BlocProvider(
            create: (_) => di.sl<TopSellingBloc>()..add(const LoadTopSelling()),
          )
        else
          BlocProvider(
            create: (_) => di.sl<NewInBloc>()..add(const LoadNewIn(limit: 50)),
          ),
        BlocProvider(create: (_) => di.sl<CartBloc>()..add(const LoadCart())),
      ],
      child: ProductsGridView(
        type: _productsType,
        title: _title,
        emptyMessage: _emptyMessage,
        loadingMessage: _loadingMessage,
        enablePagination: _enablePagination,
      ),
    );
  }
}

class ProductsGridView extends StatefulWidget {
  final ProductsType type;
  final String title;
  final String emptyMessage;
  final String loadingMessage;
  final bool enablePagination;

  const ProductsGridView({
    super.key,
    required this.type,
    required this.title,
    required this.emptyMessage,
    required this.loadingMessage,
    required this.enablePagination,
  });

  @override
  State<ProductsGridView> createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends State<ProductsGridView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.enablePagination) {
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      if (widget.type == ProductsType.topSelling) {
        context.read<TopSellingBloc>().add(const LoadMoreTopSelling());
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (widget.type == ProductsType.topSelling) {
      return BlocBuilder<TopSellingBloc, TopSellingState>(
        builder: (context, state) => _buildContent(state),
      );
    } else {
      return BlocBuilder<NewInBloc, NewInState>(
        builder: (context, state) => _buildContent(state),
      );
    }
  }

  Widget _buildContent(dynamic state) {
    // Handle loading state
    if (state is TopSellingLoading || state is NewInLoading) {
      return LoadingWidget(message: widget.loadingMessage);
    }

    // Handle error state
    if (state is TopSellingError || state is NewInError) {
      final message = state is TopSellingError 
          ? state.message 
          : (state as NewInError).message;
      return ErrorDisplayWidget(message: message);
    }

    // Handle loaded state
    if (state is TopSellingLoaded || state is NewInLoaded) {
      final products = state is TopSellingLoaded 
          ? state.products 
          : (state as NewInLoaded).products;
      final isLoadingMore = state is TopSellingLoaded 
          ? state.isLoadingMore 
          : false;

      if (products.isEmpty) {
        return Center(
          child: Text(
            widget.emptyMessage,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          if (widget.type == ProductsType.topSelling) {
            context.read<TopSellingBloc>().add(const RefreshTopSelling());
          } else {
            context.read<NewInBloc>().add(const RefreshNewIn());
          }
        },
        child: GridView.builder(
          controller: widget.enablePagination ? _scrollController : null,
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length + (isLoadingMore ? 2 : 0),
          itemBuilder: (context, index) {
            if (index >= products.length) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final product = products[index];
            return ProductCard(
              product: product,
              width: double.infinity,
              onTap: () {
                context.router.push(ProductDetailPageRoute(product: product));
              },
              onAddToCart: () {
                context.read<CartBloc>().add(
                  AddProductToCart(product),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.title} added to cart'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              onFavoriteToggle: () {},
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
