import 'package:floor_bot_mobile/app/core/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductImageCarousel extends StatelessWidget {
  final List<String?> images;
  final int currentIndex;
  final PageController pageController;
  final Function(int) onPageChanged;
  final bool isNetworkImage;

  const ProductImageCarousel({
    super.key,
    required this.images,
    required this.currentIndex,
    required this.pageController,
    required this.onPageChanged,
    this.isNetworkImage = false,
  });

  String? _getFullImageUrl(String? imageUrl) {
    if (imageUrl == null) return null;
    
    // If imageUrl starts with http, use it as is
    if (imageUrl.startsWith('http')) {
      return imageUrl;
    }
    // Otherwise, prepend base URL (remove /api/v1 from baseUrl and use the root)
    final baseUrlWithoutApi = Urls.baseUrl.replaceAll('/api/v1', '');
    return '$baseUrlWithoutApi$imageUrl';
  }

  @override
  Widget build(BuildContext context) {
    // Filter out null images
    final validImages = images.where((img) => img != null).toList();
    
    if (validImages.isEmpty) {
      return Container(
        height: 300.h,
        color: Colors.grey[100],
        child: Center(
          child: Icon(
            Icons.image_not_supported,
            size: 100.sp,
            color: Colors.grey[400],
          ),
        ),
      );
    }

    return Container(
      height: 300.h,
      color: Colors.white,
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            onPageChanged: onPageChanged,
            itemCount: validImages.length,
            itemBuilder: (context, index) {
              final image = validImages[index];
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: isNetworkImage
                      ? Image.network(
                          _getFullImageUrl(image)!,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint('ProductImageCarousel: Error loading image: $error');
                            return Icon(
                              Icons.image,
                              size: 100.sp,
                              color: Colors.grey[400],
                            );
                          },
                        )
                      : Image.asset(
                          image!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image,
                              size: 100.sp,
                              color: Colors.grey[400],
                            );
                          },
                        ),
                ),
              );
            },
          ),
          // Page indicator dots at the bottom center
          Positioned(
            bottom: 16.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                validImages.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: index == currentIndex ? 24.w : 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: index == currentIndex
                        ? Colors.orange[400]
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ),
          ),
          // Page number indicator at bottom right
          Positioned(
            bottom: 16.h,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '${currentIndex + 1}/${validImages.length}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
