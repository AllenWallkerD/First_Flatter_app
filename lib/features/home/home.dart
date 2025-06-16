import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/models/category_model.dart';
import 'package:app/router/app_router.dart';
import 'widgets/categories_carousel.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search.dart';

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
  CategoriesBloc() : super(CategoriesLoadInProgress()) {
    on<LoadCategories>((event, emit) async {
      try {
        final jsonString = await rootBundle.loadString('assets/api/categories.json');
        final List data = json.decode(jsonString) as List;
        final categories = data.map((e) => CategoryModel(name: e['name'], image: e['image'])).toList();
        emit(CategoriesLoadSuccess(categories));
      } catch (_) {
        emit(CategoriesLoadFailure());
      }
    });
  }
}

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoriesBloc()..add(LoadCategories()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<CategoriesBloc, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesLoadInProgress) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CategoriesLoadSuccess) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const HomeHeader(),
                      const HomeSearch(),
                      CategoriesCarousel(
                        categories: state.categories,
                        onSeeAllTap: () {
                          context.router.push(CategoriesListRoute());
                        },
                        onCategoryTap: (category) {},
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Top Selling',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                              },
                              child: const Text('See All'),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 250,
                        color: Colors.grey[200],
                        alignment: Alignment.center,
                        child: const Text('Top Selling Items Placeholder'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'New In',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                              },
                              child: const Text('See All'),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 150,
                        color: Colors.grey[200],
                        alignment: Alignment.center,
                        child: const Text('New In Items Placeholder'),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('Failed to load categories'));
              }
            },
          ),
        ),
      ),
    );
  }
}