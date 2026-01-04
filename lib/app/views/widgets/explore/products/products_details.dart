import 'package:floor_bot_mobile/app/controllers/product_details_controller.dart';
import 'package:floor_bot_mobile/app/core/utils/themes/app_colors.dart';
import 'package:floor_bot_mobile/app/models/product.dart';
import 'package:floor_bot_mobile/app/views/widgets/product_details/expandable_section.dart';
import 'package:floor_bot_mobile/app/views/widgets/product_details/product_image_carousel.dart';
import 'package:floor_bot_mobile/app/views/widgets/product_details/quantity_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductsDetails extends StatelessWidget {
  final Product product;

  const ProductsDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductDetailsController());
    controller.initProduct(product);

    final quantityController = TextEditingController(
      text: controller.quantity.value.toString(),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
        ),
        title: Text(
          'Item Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => controller.share(),
            icon: Icon(Icons.share_outlined, color: Colors.white, size: 22.sp),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image carousel
                  Obx(
                    () => ProductImageCarousel(
                      images: [
                        product.imageAsset,
                        product.imageAsset,
                        product.imageAsset,
                        product.imageAsset,
                        product.imageAsset,
                      ],
                      currentIndex: controller.currentImageIndex.value,
                      pageController: controller.pageController,
                      onPageChanged: controller.onPageChanged,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Product info section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product name
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // Price and stock
                        Row(
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}/box',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              width: 4.w,
                              height: 4.w,
                              decoration: BoxDecoration(
                                color: Colors.yellow[700],
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              '19 in stock',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.yellow[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Text(
                              product.description,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        // Expandable sections
                        Obx(
                          () => ExpandableSection(
                            title: 'Details',
                            isExpanded: controller.isDetailsExpanded.value,
                            onTap: controller.toggleDetails,
                            expandedContent: Text(
                              'High-quality ${product.name.toLowerCase()} flooring. Perfect for residential and commercial spaces. Durable and easy to maintain.',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),

                        Obx(
                          () => ExpandableSection(
                            title: 'Return policy',
                            isExpanded: controller.isReturnPolicyExpanded.value,
                            onTap: controller.toggleReturnPolicy,
                            expandedContent: Text(
                              '30-day return policy. Items must be in original condition with packaging. Return shipping costs may apply.',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),

                        Obx(
                          () => ExpandableSection(
                            title: 'Calculator',
                            isExpanded: controller.isCalculatorExpanded.value,
                            onTap: controller.toggleCalculator,
                            expandedContent: Text(
                              'Calculate the number of boxes needed for your space. Enter room dimensions to get an estimate.',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // Quantity selector
                        Obx(() {
                          quantityController.text = controller.quantity.value
                              .toString();
                          return QuantitySelector(
                            controller: quantityController,
                            onIncrement: controller.incrementQuantity,
                            onDecrement: controller.decrementQuantity,
                            onChanged: controller.updateQuantity,
                          );
                        }),

                        SizedBox(height: 20.h),

                        // Estimated cost
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Estimated cost',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                '\$${controller.estimatedCost.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 100.h), // Space for buttons
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom buttons
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.addToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      icon: Icon(Icons.shopping_cart_outlined, size: 20.sp),
                      label: Text(
                        'Add to cart',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.buyNow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Buy now',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
