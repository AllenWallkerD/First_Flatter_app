import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../blocs/categories/categories_bloc.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../../router/app_router.dart';

@RoutePage()
class CategoryListPage extends StatelessWidget {
  const CategoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<CategoriesBloc>()..add(const LoadCategories()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Categories',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: BlocBuilder<CategoriesBloc, CategoriesState>(
          builder: (context, state) {
            if (state is CategoriesLoading) {
              return const LoadingWidget(message: 'Loading categories...');
            }
            
            if (state is CategoriesError) {
              return ErrorDisplayWidget(message: state.message);
            }
            
            if (state is CategoriesLoaded) {
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return CategoryCard(
                    category: category,
                    onTap: () {
                      context.router.push(CategoryProductsPageRoute(
                        categoryName: category.name,
                        categoryDisplayName: category.displayName,
                      ));
                    },
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

class CategoryCard extends StatelessWidget {
  final dynamic category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String imagePath = _getCategoryImage(category.name);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                  imagePath,
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
            const SizedBox(height: 12),
            Text(
              category.displayName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
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
