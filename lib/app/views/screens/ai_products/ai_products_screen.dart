import 'package:floor_bot_mobile/app/controllers/ai_products_controller.dart';
import 'package:floor_bot_mobile/app/core/utils/themes/app_colors.dart';
import 'package:floor_bot_mobile/app/core/utils/utils.dart';
import 'package:floor_bot_mobile/app/views/screens/products/products_details.dart';
import 'package:floor_bot_mobile/app/views/widgets/explore/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AiProductsScreen extends StatelessWidget {
  final String category;

  const AiProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      AiProductsController(category: category),
      tag: category,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildGradientHeader(context, controller),
          Expanded(child: _buildProductGrid(controller)),
        ],
      ),
    );
  }

  Widget _buildGradientHeader(
    BuildContext context,
    AiProductsController controller,
  ) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF7D54F9), // Light purple/pink
            Colors.white,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              // AI Icon
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7D54F9).withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Image.asset(Utils.aiImage, width: 80.w, height: 80.h),
              ),
              SizedBox(height: 20.h),
              // Title
              Obx(
                () => Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Found ${controller.totalProductsFound} items',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(AiProductsController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.filteredProducts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64.sp, color: Colors.grey[400]),
              SizedBox(height: 16.h),
              Text(
                'No products found',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }

      return GridView.builder(
        padding: EdgeInsets.all(20.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.65,
        ),
        itemCount: controller.filteredProducts.length,
        itemBuilder: (context, index) {
          final product = controller.filteredProducts[index];

          return ProductCard(
            imageAsset: product.imageAsset,
            title: product.name,
            subtitle: product.description,
            price: controller.formatProductPrice(product),
            onTap: () {
              Get.to(ProductsDetails(product: product));
            },
            onAddTap: () => controller.addToCart(product),
          );
        },
      );
    });
  }
}
