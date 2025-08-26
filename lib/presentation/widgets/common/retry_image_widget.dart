import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class RetryImageWidget extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final int maxRetries;
  final Duration initialDelay;

  const RetryImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
  });

  @override
  State<RetryImageWidget> createState() => _RetryImageWidgetState();
}

class _RetryImageWidgetState extends State<RetryImageWidget> {
  int _retryCount = 0;
  bool _isLoading = true;
  bool _hasError = false;
  Timer? _retryTimer;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }

  void _loadImage() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
  }

  void _retryWithBackoff() {
    if (_retryCount >= widget.maxRetries) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      return;
    }

    final delay = Duration(
      milliseconds: (widget.initialDelay.inMilliseconds * pow(2, _retryCount)).toInt(),
    );

    _retryTimer = Timer(delay, () {
      setState(() {
        _retryCount++;
        _isLoading = true;
        _hasError = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {    
    if (_hasError) {
      return _buildErrorWidget();
    }

    Widget imageWidget = Image.network(
      widget.imageUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      headers: const {
        'User-Agent': 'Mozilla/5.0 (compatible; FlutterApp/1.0)',
      },
      errorBuilder: (context, error, stackTrace) {
        
        if (error.toString().contains('429')) {
          _retryWithBackoff();
          return _buildLoadingWidget();
        }
        
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        return _buildErrorWidget();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          setState(() {
            _isLoading = false;
          });
          return child;
        }
        return _buildLoadingWidget();
      },
    );

    if (widget.borderRadius != null) {
      return ClipRRect(
        borderRadius: widget.borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildErrorWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: widget.borderRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: (widget.height ?? 100) * 0.3,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'Image Unavailable',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          if (_retryCount < widget.maxRetries) ...[
            const SizedBox(height: 4),
            TextButton(
              onPressed: _retryWithBackoff,
              child: const Text(
                'Retry',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
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
