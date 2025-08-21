import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../blocs/new_in/new_in_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/product/product_card.dart';
import '../../../router/app_router.dart';

@RoutePage()
class NewInPage extends StatelessWidget {
  const NewInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<NewInBloc>()..add(const LoadNewIn(limit: 50)),
        ),
        BlocProvider(create: (_) => di.sl<CartBloc>()..add(const LoadCart())),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'New In',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: BlocBuilder<NewInBloc, NewInState>(
          builder: (context, state) {
            if (state is NewInLoading) {
              return const LoadingWidget(message: 'Loading new products...');
            }
            
            if (state is NewInError) {
              return ErrorDisplayWidget(message: state.message);
            }
            
            if (state is NewInLoaded) {
              if (state.products.isEmpty) {
                return const Center(
                  child: Text(
                    'No new products found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<NewInBloc>().add(const RefreshNewIn());
                },
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
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
                ),
              );
            }
            
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
