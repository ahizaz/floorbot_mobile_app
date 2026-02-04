import 'package:floor_bot_mobile/app/controllers/cart_controller.dart';
import 'package:floor_bot_mobile/app/models/cart_item.dart';
import 'package:floor_bot_mobile/app/core/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  String? get _fullImageUrl {
    if (item.imageUrl != null) {
      if (item.imageUrl!.startsWith('http')) {
        return item.imageUrl;
      }
      final baseUrlWithoutApi = Urls.baseUrl.replaceAll('/api/v1', '');
      return '$baseUrlWithoutApi${item.imageUrl}';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[200]!, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image and remove button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
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
                            return Icon(
                              Icons.image,
                              size: 40.sp,
                              color: Colors.grey,
                            );
                          },
                        )
                      : item.imageAsset != null
                          ? Image.asset(
                              item.imageAsset!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image,
                                  size: 40.sp,
                                  color: Colors.grey,
                                );
                              },
                            )
                          : Icon(
                              Icons.image,
                              size: 40.sp,
                              color: Colors.grey,
                            ),
                ),
              ),

              Spacer(),

              // Remove button
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red[400]!, width: 2),
                  ),
                  child: Icon(
                    Icons.remove,
                    color: Colors.red[400],
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Product name
          Text(
            item.name,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 8.h),

          // Product size
          Text(
            item.size,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),

          SizedBox(height: 16.h),

          // Quantity controls and price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Quantity controls
              Row(
                children: [
                  Text(
                    'Qty: ${item.quantity}x',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  ),
                  SizedBox(width: 16.w),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: onDecrement,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            child: Icon(
                              Icons.remove,
                              size: 18.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 24.h,
                          color: Colors.grey[300],
                        ),
                        GestureDetector(
                          onTap: onIncrement,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            child: Icon(
                              Icons.add,
                              size: 18.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Price
              Text(
                '\$${item.price.toStringAsFixed(2)}/box',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Proceed to checkout button
          GestureDetector(
            onTap: () {
              // Get cart controller and navigate to checkout
              final cartController = Get.find<CartController>();
              cartController.proceedToCheckout();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Proceed to checkout',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.arrow_forward, size: 16.sp, color: Colors.black87),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
