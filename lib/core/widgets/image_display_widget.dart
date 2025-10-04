import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Widget to display images from various sources (local file, network URL, or placeholder)
class ImageDisplayWidget extends StatelessWidget {
  final String? imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const ImageDisplayWidget({
    super.key,
    this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    // No image path provided - show placeholder
    if (imagePath == null || imagePath!.isEmpty) {
      return placeholder ?? _buildDefaultPlaceholder();
    }

    // Check if it's a local file path
    if (_isLocalPath(imagePath!)) {
      return _buildLocalImage();
    }

    // Otherwise treat as network URL
    return _buildNetworkImage();
  }

  bool _isLocalPath(String path) {
    // Check if path starts with common file path patterns
    return path.startsWith('/') || 
           path.startsWith('file://') ||
           path.contains('/data/user/') ||
           path.contains('/storage/emulated/');
  }

  Widget _buildLocalImage() {
    try {
      final file = File(imagePath!);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return errorWidget ?? _buildDefaultPlaceholder();
          },
        );
      }
    } catch (e) {
      print('❌ Error loading local image: $e');
    }
    return errorWidget ?? _buildDefaultPlaceholder();
  }

  Widget _buildNetworkImage() {
    return Image.network(
      imagePath!,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
            color: AppColors.primaryMagenta,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _buildDefaultPlaceholder();
      },
    );
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Center(
        child: Icon(
          Icons.volunteer_activism,
          size: 60,
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }
}
