import 'package:floor_bot_mobile/app/core/utils/themes/app_colors.dart';
import 'package:floor_bot_mobile/app/core/utils/urls.dart';
import 'package:floor_bot_mobile/app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AllProductsScreen extends StatelessWidget {
  final String title;
  final List<Product> products;
  final Function(String productId, {bool isBestDeal}) onProductTap;
  final Function(Product product) onAddToCart;
  final String Function(Product product) formatPrice;
  final bool isBestDeal;

  const AllProductsScreen({
    super.key,
    required this.title,
    required this.products,
    required this.onProductTap,
    required this.onAddToCart,
    required this.formatPrice,
    this.isBestDeal = false,
  });

  String? _getFullImageUrl(String? imageUrl) {
    if (imageUrl != null) {
      if (imageUrl.startsWith('http')) {
        return imageUrl;
      }
      final baseUrlWithoutApi = Urls.baseUrl.replaceAll('/api/v1', '');
      return '$baseUrlWithoutApi$imageUrl';
    }
    return null;
  }

  Widget _buildProductCard(Product product) {
    final fullImageUrl = _getFullImageUrl(product.imageUrl);
    
    return GestureDetector(
      onTap: () => onProductTap(product.id, isBestDeal: isBestDeal),
      child: Container(
        height: 120.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image section
            Container(
              width: 120.w,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.horizontal(left: Radius.circular(12.r)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(12.r)),
                child: fullImageUrl != null
                    ? Image.network(
                        fullImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          if (product.imageAsset != null) {
                            return Image.asset(
                              product.imageAsset!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) {
                                return Icon(Icons.image, size: 40.sp, color: Colors.grey);
                              },
                            );
                          }
                          return Icon(Icons.image, size: 40.sp, color: Colors.grey);
                        },
                      )
                    : product.imageAsset != null
                        ? Image.asset(
                            product.imageAsset!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) {
                              return Icon(Icons.image, size: 40.sp, color: Colors.grey);
                            },
                          )
                        : Icon(Icons.image, size: 40.sp, color: Colors.grey),
              ),
            ),

            // Content section
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Product info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          (product.width != null && product.length != null)
                              ? '${product.width} x ${product.length} cm'
                              : product.description,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    // Price and add button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatPrice(product),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => onAddToCart(product),
                          child: Container(
                            width: 32.w,
                            height: 32.w,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18.sp,
                            ),
                          ),
                        ),
                      ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: Row(
          children: [
            SizedBox(width: 4.w),
            IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 18.sp,
              ),
              padding: EdgeInsets.zero,
            ),
            Text(
              'Back',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        leadingWidth: 100.w,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No products available',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Product count header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Text(
                    '${products.length} ${products.length == 1 ? 'Product' : 'Products'}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                
                // Scrollable list of products
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    itemCount: products.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _buildProductCard(product);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
