import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/api/category.dart';
import 'package:app/api/product.dart';
import 'package:app/api/api_client.dart';
import 'package:app/models/category_model.dart';
import 'package:app/models/product_model.dart';
import 'package:app/router/app_router.dart';
import 'widgets/categories_carousel.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search.dart';
import 'package:app/components/product_item.dart';
import 'bloc/top_selling_bloc.dart';
import 'bloc/new_in_bloc.dart';

abstract class CategoriesEvent {}
class LoadCategories extends CategoriesEvent {}

abstract class CategoriesState {}
class CategoriesLoadInProgress extends CategoriesState {}
class CategoriesLoadSuccess extends CategoriesState {
  final List<CategoryModel> categories;
  CategoriesLoadSuccess(this.categories);
}
class CategoriesLoadFailure extends CategoriesState {}

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final Category category;

  CategoriesBloc(this.category) : super(CategoriesLoadInProgress()) {
    on<LoadCategories>((event, emit) async {
      emit(CategoriesLoadInProgress());
      try {
        final categories = await category.getCategories();
        emit(CategoriesLoadSuccess(categories));
      } catch (_) {
        emit(CategoriesLoadFailure());
      }
    });
  }
}

class ProductsCarousel extends StatelessWidget {
  final List<ProductModel> items;
  final double itemWidth;
  final double imageHeight;
  final bool showAddButton;

  const ProductsCarousel({
    super.key,
    required this.items,
    this.itemWidth = 180,
    this.imageHeight = 200,
    this.showAddButton = false,
  });

  @override
  Widget build(BuildContext context) {
    double carouselHeight = imageHeight + 100;
    if (showAddButton) carouselHeight += 50;

    return Container(
      height: carouselHeight,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ProductItem(
            product: items[index],
            width: itemWidth,
            imageHeight: imageHeight,
            onPressed: () => debugPrint('Added ${items[index].name} to cart'),
            onFavoritePressed: () => debugPrint('Toggled favorite for ${items[index].name}'),
          );
        },
      ),
    );
  }
}

@RoutePage()
class Home extends StatelessWidget {
  const Home({super.key});

  static void _handleTopSellingTap(BuildContext context) {
    context.pushRoute(SeeAllPageRoute(type: 'top'));
  }

  static void _handleNewInTap(BuildContext context) {
    context.pushRoute(SeeAllPageRoute(type: 'new'));
  }

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    final category = Category(apiClient: apiClient);
    final product = Product(apiClient: apiClient);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CategoriesBloc(category)..add(LoadCategories())),
        BlocProvider(create: (_) => TopSellingBloc(product)..add(LoadTopSelling())),
        BlocProvider(create: (_) => NewInBloc(product)..add(LoadNewIn())),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeHeader(),
                const HomeSearch(),

                BlocBuilder<CategoriesBloc, CategoriesState>(
                  builder: (context, catState) {
                    if (catState is CategoriesLoadSuccess) {
                      return CategoriesCarousel(
                        categories: catState.categories,
                        onSeeAllTap: () => context.router.push(CategoriesListRoute()),
                        onCategoryTap: (category) {
                          debugPrint('Selected category: ${category.name}');
                        },
                      );
                    }
                    if (catState is CategoriesLoadInProgress) {
                      return const SizedBox(
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return const SizedBox(
                      height: 100,
                      child: Center(child: Text('Failed to load categories')),
                    );
                  },
                ),

                _SectionTitle(
                  title: 'Top Selling',
                  onSeeAllTap: () => _handleTopSellingTap(context),
                ),
                BlocBuilder<TopSellingBloc, TopSellingState>(
                  builder: (context, topState) {
                    if (topState is TopSellingLoaded) {
                      return ProductsCarousel(
                        items: topState.items,
                        showAddButton: true,
                        itemWidth: 180,
                        imageHeight: 220,
                      );
                    }
                    if (topState is TopSellingLoading) {
                      return const SizedBox(
                        height: 300,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (topState is TopSellingError) {
                      return SizedBox(
                        height: 300,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Failed to load products',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  context.read<TopSellingBloc>().add(LoadTopSelling());
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox(
                      height: 300,
                      child: Center(child: Text('Unknown state')),
                    );
                  },
                ),

                _SectionTitle(
                  title: 'New In',
                  onSeeAllTap: () => _handleNewInTap(context),
                ),
                BlocBuilder<NewInBloc, NewInState>(
                  builder: (context, newState) {
                    if (newState is NewInLoaded) {
                      return ProductsCarousel(
                        items: newState.items,
                        showAddButton: false,
                        itemWidth: 180,
                        imageHeight: 220,
                      );
                    }
                    if (newState is NewInLoading) {
                      return const SizedBox(
                        height: 280,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (newState is NewInError) {
                      return SizedBox(
                        height: 280,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Failed to load products',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  context.read<NewInBloc>().add(LoadNewIn());
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox(
                      height: 280,
                      child: Center(child: Text('Unknown state')),
                    );
                  },
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
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