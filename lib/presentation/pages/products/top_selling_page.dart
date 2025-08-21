import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../blocs/top_selling/top_selling_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/product/product_card.dart';
import '../../../router/app_router.dart';

@RoutePage()
class TopSellingPage extends StatelessWidget {
  const TopSellingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<TopSellingBloc>()..add(const LoadTopSelling()),
        ),
        BlocProvider(create: (_) => di.sl<CartBloc>()..add(const LoadCart())),
      ],
      child: const TopSellingView(),
    );
  }
}

class TopSellingView extends StatefulWidget {
  const TopSellingView({super.key});

  @override
  State<TopSellingView> createState() => _TopSellingViewState();
}

class _TopSellingViewState extends State<TopSellingView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<TopSellingBloc>().add(const LoadMoreTopSelling());
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
        title: const Text(
          'Top Selling',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<TopSellingBloc, TopSellingState>(
        builder: (context, state) {
          if (state is TopSellingLoading) {
            return const LoadingWidget(message: 'Loading top selling products...');
          }
          
          if (state is TopSellingError) {
            return ErrorDisplayWidget(message: state.message);
          }
          
          if (state is TopSellingLoaded) {
            if (state.products.isEmpty) {
              return const Center(
                child: Text(
                  'No products found',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              );
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TopSellingBloc>().add(const RefreshTopSelling());
              },
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: state.products.length + (state.isLoadingMore ? 2 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.products.length) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  final product = state.products[index];
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
        },
      ),
    );
  }
}
