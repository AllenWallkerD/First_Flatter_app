import 'package:flutter/material.dart';
import 'package:app/models/category_model.dart';

class CategoriesCarousel extends StatelessWidget {
  final List<CategoryModel> categories;
  final void Function(CategoryModel) onCategoryTap;
  final VoidCallback onSeeAllTap;

  const CategoriesCarousel({
    Key? key,
    required this.categories,
    required this.onCategoryTap,
    required this.onSeeAllTap,
  }) : super(key: key);

  Widget _buildImage(String src) {
    if (src.startsWith('http')) {
      return Image.network(src, fit: BoxFit.cover);
    } else {
      return Image.asset(src, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: onSeeAllTap,
                child: Text(
                  'See All',
                  style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => SizedBox(width: 16),
            itemBuilder: (context, idx) {
              final c = categories[idx];
              return GestureDetector(
                onTap: () => onCategoryTap(c),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
                      child: ClipOval(child: _buildImage(c.image)),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: 64,
                      child: Text(
                        c.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
