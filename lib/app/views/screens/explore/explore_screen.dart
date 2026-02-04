import 'package:floor_bot_mobile/app/controllers/explore_controller.dart';
import 'package:floor_bot_mobile/app/controllers/nav_controller.dart';
import 'package:floor_bot_mobile/app/views/screens/calculator_test_screen.dart';
import 'package:floor_bot_mobile/app/views/widgets/explore/explore_header.dart';
import 'package:floor_bot_mobile/app/views/widgets/explore/category_card.dart';
import 'package:floor_bot_mobile/app/views/widgets/explore/product_card.dart';
import 'package:floor_bot_mobile/app/views/widgets/explore/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ExploreTab extends StatelessWidget {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExploreController());
    final navController = Get.find<NavController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          ExploreHeader(
            userName: 'Sebastian',
            location: 'Los Angeles, USA',
            onSearchTap: () {
              // Navigate to search tab
              navController.changeTab(1);
            },
            onNotificationTap: () {
              // TODO: Implement notifications
            },
            onProfileTap: () {
              // TODO: Implement profile
            },
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),

                    // Categories
                    SizedBox(
                      height: 120.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        itemCount: controller.categories.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 16.w),
                        itemBuilder: (context, index) {
                          final category = controller.categories[index];
                          return CategoryCard(
                            title: category.name,
                            imageAsset: category.imageAsset,
                            imageUrl: category.imageUrl,
                            onTap: () => controller.onCategoryTap(category.id),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // New arrival section
                    SectionHeader(
                      title: 'New arrival',
                      onShowAllTap: () => controller.onShowAllNewArrivals(),
                    ),

                    SizedBox(
                      height: 220.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        itemCount: controller.newArrivals.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 16.w),
                        itemBuilder: (context, index) {
                          final product = controller.newArrivals[index];
                          return ProductCard(
                            imageAsset: product.imageAsset,
                            imageUrl: product.imageUrl,
                            title: product.name,
                            subtitle: product.description,
                            price: controller.formatProductPrice(product),
                            width: product.width,
                            length: product.length,
                            onTap: () => controller.onProductTap(product.id),
                            onAddTap: () => controller.onAddToCart(product),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Best deals section
                    SectionHeader(
                      title: 'Best deals',
                      onShowAllTap: () => controller.onShowAllBestDeals(),
                    ),

                    SizedBox(
                      height: 220.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        itemCount: controller.bestDeals.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 16.w),
                        itemBuilder: (context, index) {
                          final product = controller.bestDeals[index];
                          return ProductCard(
                            imageAsset: product.imageAsset,
                            imageUrl: product.imageUrl,
                            title: product.name,
                            subtitle: product.description,
                            price: controller.formatProductPrice(product),
                            width: product.width,
                            length: product.length,
                            onTap: () => controller.onProductTap(product.id),
                            onAddTap: () => controller.onAddToCart(product),
                          );
                        },
                      ),
                    ),

                    SizedBox(
                      height: 100.h,
                    ), // Extra padding for floating bottom nav
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "calculator_test_fab",
        onPressed: () {
          Get.to(() => const CalculatorTestScreen());
        },
        backgroundColor: Colors.blue[600],
        child: const Icon(Icons.calculate, color: Colors.white),
      ),
    );
  }
}
