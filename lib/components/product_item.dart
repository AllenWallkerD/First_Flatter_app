import 'package:flutter/material.dart';
import 'package:app/models/product_model.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onPressed;
  final VoidCallback? onFavoritePressed;
  final double? width;
  final double? imageHeight;
  final bool isFavorite;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? borderRadius;

  const ProductItem({
    super.key,
    required this.product,
    this.onPressed,
    this.onFavoritePressed,
    this.width,
    this.imageHeight,
    this.isFavorite = false,
    this.margin,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    final dynamicWidth = width ?? screenWidth * 0.45;
    final dynamicImageHeight = imageHeight ?? dynamicWidth * 1.2;
    final dynamicBorderRadius = borderRadius ?? dynamicWidth * 0.06;
    final dynamicPadding = padding ?? EdgeInsets.all(dynamicWidth * 0.08);
    final dynamicMargin = margin ?? EdgeInsets.only(
      right: dynamicWidth * 0.08,
      bottom: dynamicWidth * 0.08,
    );

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: dynamicWidth,
        margin: dynamicMargin,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(dynamicBorderRadius),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: dynamicWidth * 0.04,
              offset: Offset(0, dynamicWidth * 0.01),
            ),
          ],
        ),
        child: SizedBox(
          height: dynamicImageHeight + 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(dynamicWidth, dynamicImageHeight, dynamicBorderRadius, theme),
              _buildDetailsSection(dynamicPadding, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(
      double containerWidth,
      double containerHeight,
      double borderRadius,
      ThemeData theme,
      ) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadius),
            topRight: Radius.circular(borderRadius),
          ),
          child: _buildImage(containerWidth, containerHeight, theme),
        ),
        _buildFavoriteButton(containerWidth, theme),
      ],
    );
  }

  Widget _buildImage(double width, double height, ThemeData theme) {
    if (product.image.startsWith('http')) {
      return Image.network(
        product.image,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: height,
          width: width,
          color: theme.colorScheme.surfaceVariant,
          child: Icon(
            Icons.broken_image,
            color: theme.colorScheme.onSurfaceVariant,
            size: width * 0.2,
          ),
        ),
      );
    } else {
      return Image.asset(
        product.image,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: height,
          width: width,
          color: theme.colorScheme.surfaceVariant,
          child: Icon(
            Icons.broken_image,
            color: theme.colorScheme.onSurfaceVariant,
            size: width * 0.2,
          ),
        ),
      );
    }
  }

  Widget _buildFavoriteButton(double containerWidth, ThemeData theme) {
    final buttonSize = containerWidth * 0.12;
    final iconSize = containerWidth * 0.1;
    final offset = containerWidth * 0.06;

    return Positioned(
      top: offset,
      right: offset,
      child: GestureDetector(
        onTap: onFavoritePressed,
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: theme.cardColor.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite
                ? theme.colorScheme.error
                : theme.colorScheme.onSurfaceVariant,
            size: iconSize,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsSection(EdgeInsets padding, ThemeData theme) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            product.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              height: 1.3,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.primary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}