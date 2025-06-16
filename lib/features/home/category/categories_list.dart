import 'dart:convert';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/models/category_model.dart';

@RoutePage()
class CategoriesList extends StatelessWidget {
  const CategoriesList({Key? key}) : super(key: key);

  Future<List<CategoryModel>> _loadCategories() async {
    final jsonString = await rootBundle.loadString('assets/api/categories.json');
    final List data = json.decode(jsonString) as List;
    return data
        .map((e) => CategoryModel(name: e['name'], image: e['image']))
        .toList();
  }

  Widget _buildImage(String src) {
    if (src.startsWith('http')) {
      return Image.network(src, width: 40, height: 40, fit: BoxFit.cover);
    } else {
      return Image.asset(src, width: 40, height: 40, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<CategoryModel>>(
        future: _loadCategories(),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final categories = snap.data ?? [];
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
                          leading: ClipOval(child: _buildImage(c.image)),
                          title: Text(c.name),
                          onTap: () {},
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}