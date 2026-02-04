import 'package:floor_bot_mobile/app/controllers/product_details_controller.dart';
import 'package:floor_bot_mobile/app/core/utils/themes/app_colors.dart';
import 'package:floor_bot_mobile/app/models/product.dart';
import 'package:floor_bot_mobile/app/models/product_calculator_config.dart';
import 'package:floor_bot_mobile/app/views/widgets/product_details/expandable_section.dart';
import 'package:floor_bot_mobile/app/views/widgets/product_details/enhanced_floor_calculator_widget.dart';
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

    final lengthController = TextEditingController();
    final widthController = TextEditingController();

    lengthController.addListener(() {
      controller.updateLength(lengthController.text);
    });

    widthController.addListener(() {
      controller.updateWidth(widthController.text);
    });

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
          'Item Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => controller.share(),
            child: Row(
              children: [
                Text(
                  'Share',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(Icons.share_outlined, color: Colors.white, size: 18.sp),
              ],
            ),
          ),
          SizedBox(width: 8.w),
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
                    () {
                      // Determine if we should use network images or asset images
                      final hasImageUrl = product.imageUrl != null;
                      final images = hasImageUrl 
                          ? [product.imageUrl, product.imageUrl, product.imageUrl] 
                          : [product.imageAsset, product.imageAsset, product.imageAsset];
                      
                      return ProductImageCarousel(
                        images: images,
                        currentIndex: controller.currentImageIndex.value,
                        pageController: controller.pageController,
                        onPageChanged: controller.onPageChanged,
                        isNetworkImage: hasImageUrl,
                      );
                    },
                  ),

                  SizedBox(height: 20.h),

                  // Product info section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                            Obx(
                              () => Text(
                                '${controller.formattedPrice}/box',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
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

                        SizedBox(height: 16.h),

                        // Expandable sections
                        Obx(
                          () => ExpandableSection(
                            title: 'Details',
                            isExpanded: controller.isDetailsExpanded.value,
                            onTap: controller.toggleDetails,
                            expandedContent: Text(
                              product.description,
                              style: TextStyle(
                                fontSize: 13.sp,
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
                                fontSize: 13.sp,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),

                        // Floor calculator section - only show if calculator is enabled
                        if (product.calculatorConfig.calculatorType ==
                            CalculatorType.enabled)
                          Obx(
                            () => ExpandableSection(
                              title: 'Floor calculator',
                              isExpanded: controller.isCalculatorExpanded.value,
                              onTap: controller.toggleCalculator,
                              expandedContent: Obx(
                                () => EnhancedFloorCalculatorWidget(
                                  lengthController: lengthController,
                                  widthController: widthController,
                                  selectedUnit: controller.selectedUnit.value,
                                  onUnitChanged: (value) {
                                    if (value != null) {
                                      controller.updateUnit(value);
                                    }
                                  },
                                  config: product.calculatorConfig,
                                  selectedWidth: controller.selectedWidth.value,
                                  onWidthChanged:
                                      controller.updateSelectedWidth,
                                  calculatedArea:
                                      controller.calculatedArea.value,
                                  calculatedBoxes:
                                      controller.calculatedBoxes.value,
                                  calculationResult:
                                      controller.calculationResult.value,
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
                                controller.formattedEstimatedCost,
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
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
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
                        backgroundColor: const Color(0xFF2C3E50),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
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
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
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
