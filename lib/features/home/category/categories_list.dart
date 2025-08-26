import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/api/api_client.dart';
import 'package:app/api/category.dart';
import '../../../data/models/category_model.dart';

abstract class CategoriesListEvent {}
class LoadCategoriesList extends CategoriesListEvent {}

abstract class CategoriesListState {}
class CategoriesListLoading extends CategoriesListState {}
class CategoriesListLoaded extends CategoriesListState {
  final List<CategoryModel> categories;
  CategoriesListLoaded(this.categories);
}
class CategoriesListError extends CategoriesListState {
  final String message;
  CategoriesListError(this.message);
}

class CategoriesListBloc extends Bloc<CategoriesListEvent, CategoriesListState> {
  final Category categoryService;

  CategoriesListBloc(this.categoryService) : super(CategoriesListLoading()) {
    on<LoadCategoriesList>((event, emit) async {
      try {
        emit(CategoriesListLoading());
        final categories = await categoryService.getCategories();
        emit(CategoriesListLoaded(categories));
      } catch (e) {
        emit(CategoriesListError(e.toString()));
      }
    });
  }
}

@RoutePage()
class CategoriesList extends StatelessWidget {
  const CategoriesList({Key? key}) : super(key: key);

  Widget _buildImage(String src) {
    return Image.network(
      src,
      width: 40,
      height: 40,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.category,
            color: Colors.grey[600],
            size: 20,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    final categoryService = Category(apiClient: apiClient);

    return BlocProvider(
      create: (_) => CategoriesListBloc(categoryService)..add(LoadCategoriesList()),
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(''),
        ),
        backgroundColor: Colors.white,
        body: BlocBuilder<CategoriesListBloc, CategoriesListState>(
          builder: (context, state) {
            if (state is CategoriesListLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CategoriesListError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                    SizedBox(height: 16),
                    Text('Failed to load categories'),
                    SizedBox(height: 8),
                    Text(state.message, textAlign: TextAlign.center),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CategoriesListBloc>().add(LoadCategoriesList());
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is CategoriesListLoaded) {
              final categories = state.categories;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Text(
                      'Shop by Categories',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<CategoriesListBloc>().add(LoadCategoriesList());
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final c = categories[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                leading: ClipOval(child: _buildImage(c.imageUrl ?? '')),
                                title: Text(c.name),
                                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                                onTap: () {
                                  // Navigate to category products
                                  // TODO: Add navigation to category products page
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }

            return Center(child: Text('Unknown state'));
          },
        ),
      ),
    );
  }
}
