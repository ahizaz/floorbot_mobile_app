import 'package:floor_bot_mobile/app/controllers/explore_controller.dart';
import 'package:floor_bot_mobile/app/controllers/nav_controller.dart';
import 'package:floor_bot_mobile/app/controllers/profile_controller.dart';
import 'package:floor_bot_mobile/app/core/utils/themes/app_colors.dart';
import 'package:floor_bot_mobile/app/views/screens/calculator_test_screen.dart';
import 'package:floor_bot_mobile/app/views/screens/notifications/notification_screen.dart';
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
    final profileController = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          // Header
          Obx(() {
            final profileData = profileController.profileData.value;
            String location = 'Los Angeles, USA';

            if (profileData != null) {
              final addressLine = profileData.addressLineI ?? '';
              final city = profileData.city ?? '';
              final state = profileData.state ?? '';

              // Build location string from API data
              if (addressLine.isNotEmpty ||
                  city.isNotEmpty ||
                  state.isNotEmpty) {
                final parts = <String>[];
                if (addressLine.isNotEmpty) parts.add(addressLine);
                if (city.isNotEmpty) parts.add(city);
                if (state.isNotEmpty) parts.add(state);
                location = parts.join(', ');
                debugPrint('Explore: Location from API: $location');
              }
            }

            return ExploreHeader(
              userName:
                  profileController.profileData.value?.fullName ?? 'Guest',
              location: location,
              onSearchTap: () {
                // Navigate to search tab
                navController.changeTab(1);
              },
              onNotificationTap: () {
                // Navigate to notification screen
                Get.to(() => NotificationScreen());
              },
              onProfileTap: () {
                profileController.showImagePickerOptions();
              },
            );
          }),
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

                    // SizedBox(
                    //   height: 220.h,
                    //   child: ListView.separated(
                    //     scrollDirection: Axis.horizontal,
                    //     padding: EdgeInsets.symmetric(horizontal: 20.w),
                    //     itemCount: controller.newArrivals.length,
                    //     separatorBuilder: (context, index) =>
                    //         SizedBox(width: 16.w),
                    //     itemBuilder: (context, index) {
                    //       final product = controller.newArrivals[index];
                    //       return ProductCard(
                    //         imageAsset: product.imageAsset,
                    //         imageUrl: product.imageUrl,
                    //         title: product.name,
                    //         subtitle: product.description,
                    //         price: controller.formatProductPrice(product),
                    //         width: product.width,
                    //         length: product.length,
                    //         onTap: () => controller.onProductTap(product.id),
                    //         onAddTap: () => controller.onAddToCart(product),
                    //       );
                    //     },
                    //   ),
                    // ),
                    // New arrival section এর ListView এ NotificationListener যোগ করুন:
SizedBox(
  height: 220.h,
  child: NotificationListener<ScrollNotification>(
    onNotification: (ScrollNotification scrollInfo) {
      // যখন user শেষের কাছে scroll করবে, তখন আরো products load করবে
      if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200 &&
          !controller.isLoadingMoreNewArrivals.value &&
          controller.hasMoreNewArrivals.value) {
        controller.loadMoreNewArrivals();
      }
      return false;
    },
    child: Obx(() => ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: controller.newArrivals.length + 
                 (controller.hasMoreNewArrivals.value ? 1 : 0),
      separatorBuilder: (context, index) => SizedBox(width: 16.w),
      itemBuilder: (context, index) {
        // Loading indicator শেষে দেখানোর জন্য
        if (index == controller.newArrivals.length) {
          return Container(
            width: 180.w,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }
        
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
    )),
  ),
),

                    SizedBox(height: 16.h),

                    // Best deals section
                    SectionHeader(
                      title: 'Best deals',
                      onShowAllTap: () => controller.onShowAllBestDeals(),
                    ),

                    // SizedBox(
                    //   height: 220.h,
                    //   child: ListView.separated(
                    //     scrollDirection: Axis.horizontal,
                    //     padding: EdgeInsets.symmetric(horizontal: 20.w),
                    //     itemCount: controller.bestDeals.length,
                    //     separatorBuilder: (context, index) =>
                    //         SizedBox(width: 16.w),
                    //     itemBuilder: (context, index) {
                    //       final product = controller.bestDeals[index];
                    //       return ProductCard(
                    //         imageAsset: product.imageAsset,
                    //         imageUrl: product.imageUrl,
                    //         title: product.name,
                    //         subtitle: product.description,
                    //         price: controller.formatProductPrice(product),
                    //         width: product.width,
                    //         length: product.length,
                    //         onTap: () => controller.onProductTap(
                    //           product.id,
                    //           isBestDeal: true,
                    //         ),
                    //         onAddTap: () => controller.onAddToCart(product),
                    //       );
                    //     },
                    //   ),
                    // ),
                   SizedBox(
  height: 220.h,
  child: NotificationListener<ScrollNotification>(
    onNotification: (ScrollNotification scrollInfo) {
      if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200 &&
          !controller.isLoadingMoreBestDeals.value &&
          controller.hasMoreBestDeals.value) {
        controller.loadMoreBestDeals();
      }
      return false;
    },
    child: Obx(() => ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: controller.bestDeals.length + 
                 (controller.hasMoreBestDeals.value ? 1 : 0),
      separatorBuilder: (context, index) => SizedBox(width: 16.w),
      itemBuilder: (context, index) {
        if (index == controller.bestDeals.length) {
          return Container(
            width: 180.w,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }
        
        final product = controller.bestDeals[index];
        return ProductCard(
          imageAsset: product.imageAsset,
          imageUrl: product.imageUrl,
          title: product.name,
          subtitle: product.description,
          price: controller.formatProductPrice(product),
          width: product.width,
          length: product.length,
          onTap: () => controller.onProductTap(
            product.id,
            isBestDeal: true,
          ),
          onAddTap: () => controller.onAddToCart(product),
        );
      },
    )),
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
