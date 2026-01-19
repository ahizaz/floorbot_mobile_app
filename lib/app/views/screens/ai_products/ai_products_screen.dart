import 'package:floor_bot_mobile/app/controllers/ai_products_controller.dart';
import 'package:floor_bot_mobile/app/core/utils/themes/app_colors.dart';
import 'package:floor_bot_mobile/app/core/utils/utils.dart';
import 'package:floor_bot_mobile/app/views/screens/products/products_details.dart';
import 'package:floor_bot_mobile/app/views/widgets/explore/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AiProductsScreen extends StatefulWidget {
  final String category;

  const AiProductsScreen({super.key, required this.category});

  @override
  State<AiProductsScreen> createState() => _AiProductsScreenState();
}

class _AiProductsScreenState extends State<AiProductsScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    // Stagger animation controller for products
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      AiProductsController(category: widget.category),
      tag: widget.category,
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
              // AI Icon - Centered with smooth rotation animation
              RotationTransition(
                turns: _rotationController,
                child: Container(
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

          // Calculate stagger delay for each item
          final staggerDelay = index * 0.1; // 100ms delay between each item
          final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _staggerController,
              curve: Interval(
                staggerDelay,
                staggerDelay + 0.3,
                curve: Curves.easeOut,
              ),
            ),
          );

          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _staggerController,
                          curve: Interval(
                            staggerDelay,
                            staggerDelay + 0.3,
                            curve: Curves.easeOut,
                          ),
                        ),
                      ),
                  child: ProductCard(
                    imageAsset: product.imageAsset,
                    title: product.name,
                    subtitle: product.description,
                    price: controller.formatProductPrice(product),
                    onTap: () {
                      // TODO: Navigate to product details
                      Get.to(ProductsDetails(product: product));
                    },
                    onAddTap: () => controller.addToCart(product),
                  ),
                ),
              );
            },
          );
        },
      );
    });
  }
}
