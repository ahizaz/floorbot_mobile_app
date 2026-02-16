import 'package:floor_bot_mobile/app/core/utils/themes/app_colors.dart';
import 'package:floor_bot_mobile/app/core/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCard extends StatelessWidget {
  final String? imageUrl;
  final String? imageAsset;
  final String title;
  final String subtitle;
  final String price;
  final VoidCallback? onTap;
  final VoidCallback? onAddTap;
  final bool showAddButton;
  final String? width;
  final String? length;

  const ProductCard({
    super.key,
    this.imageUrl,
    this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.price,
    this.onTap,
    this.onAddTap,
    this.showAddButton = true,
    this.width,
    this.length,
  });

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
      child: Container(
        width: 160.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .06),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container
            Container(
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              ),
              child: Center(
                child: _fullImageUrl != null
                    ? Image.network(
                        _fullImageUrl!,
                        width: double.infinity,
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
                          debugPrint('ProductCard: Error loading image: $error');
                          // Fallback to asset image if network fails
                          if (imageAsset != null) {
                            return Image.asset(
                              imageAsset!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) {
                                return Icon(
                                  Icons.image,
                                  size: 48.sp,
                                  color: Colors.grey,
                                );
                              },
                            );
                          }
                          return Icon(
                            Icons.image,
                            size: 48.sp,
                            color: Colors.grey,
                          );
                        },
                      )
                    : imageAsset != null
                        ? Image.asset(
                            imageAsset!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.image,
                                size: 48.sp,
                                color: Colors.grey,
                              );
                            },
                          )
                        : Icon(
                            Icons.image,
                            size: 48.sp,
                            color: Colors.grey,
                          ),
              ),
            ),

            // Content section - use Expanded to prevent overflow
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top section - product info
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 1.h),
                          // Show width x length if available, otherwise show subtitle
                          Text(
                            (width != null && length != null) 
                                ? '$width x $length cm'
                                : subtitle,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey[600],
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Bottom section - price and add button
                    SizedBox(
                      height: 26.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              price,
                              style: TextStyle(
                                fontSize: 12.sp, // Reduced font size
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                height: 1.2, // Reduced line height
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (showAddButton)
                            GestureDetector(
                              onTap: onAddTap,
                              child: Container(
                                width: 24.w, // Reduced size
                                height: 24.w,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 14.sp, // Reduced icon size
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
