import 'package:floor_bot_mobile/app/controllers/search_controller.dart';
import 'package:floor_bot_mobile/app/views/widgets/explore/product_card.dart';
import 'package:floor_bot_mobile/app/views/widgets/search/search_bar_widget.dart';
import 'package:floor_bot_mobile/app/views/widgets/search/search_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductSearchController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Search bar
          SearchBarWidget(
            controller: controller.searchTextController,
            onCancel: () {
              controller.clearSearch();
            },
            onChanged: (value) {
              // Search is handled by listener in controller
            },
            onSubmitted: (value) {
              // Search is handled by listener in controller
            },
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Suggested section
                    if (!controller.isSearching.value) ...[
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
                        child: Text(
                          'Suggested',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: controller.suggestedChips
                              .map(
                                (chip) => SearchChip(
                                  label: chip,
                                  onTap: () => controller.onChipTap(chip),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],

                    // Best deals section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        controller.isSearching.value
                            ? 'Search Results'
                            : 'Best deals',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Products grid
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: const CircularProgressIndicator(),
                            ),
                          );
                        }

                        final products = controller.isSearching.value
                            ? controller.searchResults
                            : controller.bestDeals;

                        if (controller.isSearching.value && products.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 48.sp,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'No products found',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Try searching with different keywords',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio:
                                    0.85, // Increased aspect ratio
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 12.h,
                              ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];

                            return ProductCard(
                              imageAsset: product.imageAsset,
                              title: product.name,
                              subtitle: product.description,
                              price: controller.formatProductPrice(product),
                              onTap: () => controller.onProductTap(product.id),
                              onAddTap: () => controller.onAddToCart(product),
                            );
                          },
                        );
                      }),
                    ),

                    SizedBox(height: 100.h), // Bottom padding for nav bar
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
