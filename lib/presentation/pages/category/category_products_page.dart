import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../blocs/products/products_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/product/product_card.dart';
import '../../../router/app_router.dart';

@RoutePage()
class CategoryProductsPage extends StatelessWidget {
  final String categoryName;
  final String categoryDisplayName;

  const CategoryProductsPage({
    super.key,
    required this.categoryName,
    required this.categoryDisplayName,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<ProductsBloc>()..add(LoadProductsByCategory(categoryName)),
        ),
        BlocProvider(create: (_) => di.sl<CartBloc>()..add(const LoadCart())),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            categoryDisplayName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const LoadingWidget(message: 'Loading products...');
            }
            
            if (state is ProductsError) {
              return ErrorDisplayWidget(message: state.message);
            }
            
            if (state is ProductsByCategoryLoaded) {
              if (state.products.isEmpty) {
                return const Center(
                  child: Text(
                    'No products found in this category',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
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
              );
            }
            
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
