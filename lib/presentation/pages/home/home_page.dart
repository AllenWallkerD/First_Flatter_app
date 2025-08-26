import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../blocs/categories/categories_bloc.dart';
import '../../blocs/top_selling/top_selling_bloc.dart';
import '../../blocs/new_in/new_in_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/product/product_card.dart';
import '../../../features/home/widgets/home_header.dart';
import '../../../features/home/widgets/home_search.dart';
import '../../../router/app_router.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<CategoriesBloc>()..add(const LoadCategories())),
        BlocProvider(create: (_) => di.sl<TopSellingBloc>()..add(const LoadTopSelling())),
        BlocProvider(create: (_) => di.sl<NewInBloc>()..add(const LoadNewIn())),
        BlocProvider(create: (_) => di.sl<CartBloc>()..add(const LoadCart())),
      ],
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<CategoriesBloc>().add(const RefreshCategories());
            context.read<TopSellingBloc>().add(const RefreshTopSelling());
            context.read<NewInBloc>().add(const RefreshNewIn());
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              const SliverToBoxAdapter(
                child: Column(
                  children: [
                    HomeHeader(),
                    HomeSearch(),
                  ],
                ),
              ),
              
              SliverToBoxAdapter(
                child: BlocBuilder<CategoriesBloc, CategoriesState>(
                  builder: (context, state) {
                    if (state is CategoriesLoading) {
                      return const SizedBox(
                        height: 120,
                        child: LoadingWidget(message: 'Loading categories...'),
                      );
                    }
                    
                    if (state is CategoriesError) {
                      return SizedBox(
                        height: 120,
                        child: ErrorDisplayWidget(
                          message: state.message,
                        ),
                      );
                    }
                    
                    if (state is CategoriesLoaded) {
                      return CategoriesSection(categories: state.categories);
                    }
                    
                    return const SizedBox.shrink();
                  },
                ),
              ),
              
              SliverToBoxAdapter(
                child: _SectionTitle(
                  title: 'Top Selling',
                  onSeeAllTap: () {
                    context.router.push(ProductsGridPageRoute(type: 'top-selling'));
                  },
                ),
              ),
              
              SliverToBoxAdapter(
                child: BlocBuilder<TopSellingBloc, TopSellingState>(
                  builder: (context, state) {
                    if (state is TopSellingLoading) {
                      return const SizedBox(
                        height: 280,
                        child: LoadingWidget(message: 'Loading top selling products...'),
                      );
                    }
                    
                    if (state is TopSellingError) {
                      return SizedBox(
                        height: 280,
                        child: ErrorDisplayWidget(message: state.message),
                      );
                    }
                    
                    if (state is TopSellingLoaded) {
                      return SizedBox(
                        height: 280,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.products.take(10).length,
                          itemBuilder: (context, index) {
                            final product = state.products[index];
                            return ProductCard(
                              product: product,
                              width: 180,
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
              
              SliverToBoxAdapter(
                child: _SectionTitle(
                  title: 'New In',
                  onSeeAllTap: () {
                    context.router.push(ProductsGridPageRoute(type: 'new-in'));
                  },
                ),
              ),
              
              SliverToBoxAdapter(
                child: BlocBuilder<NewInBloc, NewInState>(
                  builder: (context, state) {
                    if (state is NewInLoading) {
                      return const SizedBox(
                        height: 280,
                        child: LoadingWidget(message: 'Loading new products...'),
                      );
                    }
                    
                    if (state is NewInError) {
                      return SizedBox(
                        height: 280,
                        child: ErrorDisplayWidget(message: state.message),
                      );
                    }
                    
                    if (state is NewInLoaded) {
                      return SizedBox(
                        height: 280,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            final product = state.products[index];
                            return ProductCard(
                              product: product,
                              width: 180,
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
              
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesSection extends StatelessWidget {
  final List categories;

  const CategoriesSection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextButton(
                onPressed: () => context.router.push(const CategoriesListRoute()),
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.take(6).length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  context.router.push(CategoryProductsPageRoute(
                    categoryName: category.name,
                    categoryDisplayName: category.displayName,
                  ));
                },
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.purple[50],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            _getCategoryImage(category.name),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.category,
                                size: 30,
                                color: Colors.purple[400],
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.displayName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getCategoryImage(String categoryName) {
    const categoryImages = {
      'mobile': 'assets/images/categories/Accessories.png',
      'laptop': 'assets/images/categories/Bag.png',
      'tv': 'assets/images/categories/Hoodies.png',
      'audio': 'assets/images/categories/Shoes.png',
      'gaming': 'assets/images/categories/Shorts.png',
      'appliances': 'assets/images/categories/Accessories.png',
    };
    
    return categoryImages[categoryName.toLowerCase()] ?? 'assets/images/categories/Accessories.png';
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAllTap;

  const _SectionTitle({
    required this.title,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          TextButton(
            onPressed: onSeeAllTap,
            child: const Text(
              'See All',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}