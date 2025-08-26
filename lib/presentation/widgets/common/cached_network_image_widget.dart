import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CachedNetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {    
    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      httpHeaders: const {
        'User-Agent': 'Mozilla/5.0 (compatible; FlutterApp/1.0)',
      },
      placeholder: (context, url) {
        return _buildLoadingWidget();
      },
      errorWidget: (context, url, error) {
        return _buildFallbackImage();
      },
      memCacheWidth: 300,
      memCacheHeight: 300,
      maxWidthDiskCache: 300,
      maxHeightDiskCache: 300,
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildFallbackImage() {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      headers: const {
        'User-Agent': 'Mozilla/5.0 (compatible; FlutterApp/1.0)',
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorWidget();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return _buildLoadingWidget();
      },
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: (height ?? 100) * 0.3,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'Image Error',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[100],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
      ),
    );
  }
}
