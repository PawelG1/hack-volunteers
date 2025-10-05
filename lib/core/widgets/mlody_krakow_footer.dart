import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Widget stopki z logo i informacją o wsparciu od Młody Kraków
class MlodyKrakowFooter extends StatelessWidget {
  final double imageHeight;
  final double spacing;
  final EdgeInsets padding;

  const MlodyKrakowFooter({
    Key? key,
    this.imageHeight = 35,
    this.spacing = 8,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Wsparcie dzięki',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: spacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/mlody_krakow_horizontal.png',
                height: imageHeight,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'Młody Kraków',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryMagenta,
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: spacing),
          Text(
            'Program wspierany przez Młody Kraków',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
