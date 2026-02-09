import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:floor_bot_mobile/app/core/utils/urls.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String? imageAsset;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.title,
    this.imageUrl,
    this.imageAsset,
    this.onTap,
  }) : assert(
         imageUrl != null || imageAsset != null,
         'Either imageUrl or imageAsset must be provided',
       );

  String? get _fullImageUrl {
    if (imageUrl != null) {
      // If imageUrl starts with http, use it as is
      if (imageUrl!.startsWith('http')) {
        return imageUrl;
      }
      // Otherwise, prepend base URL (remove /api/v1 from baseUrl and use the root)
      final baseUrlWithoutApi = Urls.baseUrl.replaceAll('/api/v1', '');
      return '$baseUrlWithoutApi$imageUrl';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .08),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: _fullImageUrl != null
                    ? Image.network(
                        _fullImageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('CategoryCard: Error loading image: $error');
                          return Icon(
                            Icons.category,
                            size: 40.sp,
                            color: Colors.grey,
                          );
                        },
                      )
                    : imageAsset != null
                        ? Image.asset(
                            imageAsset!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.category,
                                size: 40.sp,
                                color: Colors.grey,
                              );
                            },
                          )
                        : Icon(
                            Icons.category,
                            size: 40.sp,
                            color: Colors.grey,
                          ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
