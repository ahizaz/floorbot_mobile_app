import 'package:floor_bot_mobile/app/core/utils/themes/app_colors.dart';
import 'package:floor_bot_mobile/app/models/product.dart';
import 'package:floor_bot_mobile/app/models/product_calculator_config.dart';
import 'package:floor_bot_mobile/app/views/screens/products/products_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CalculatorTestScreen extends StatelessWidget {
  const CalculatorTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create test products with different calculator configurations
    final boxProduct = Product(
      id: 'test-box',
      name: 'Test Box Product',
      description: '4x4 Sqr. m.',
      price: 25.99,
      imageAsset: 'assets/images/parquet.png',
      category: 'Wood',
      calculatorConfig: ProductCalculatorConfig.boxBased(coveragePerBox: 16.0),
    );

    final carpetProduct = Product(
      id: 'test-carpet',
      name: 'Test Carpet Product',
      description: 'Available in 4m/5m widths',
      price: 35.99,
      imageAsset: 'assets/images/carpets.png',
      category: 'Carpet',
      calculatorConfig: ProductCalculatorConfig.carpet(),
    );

    final vinylProduct = Product(
      id: 'test-vinyl',
      name: 'Test Vinyl Product',
      description: 'Available in 2m/3m/4m widths',
      price: 29.99,
      imageAsset: 'assets/images/venyl.png',
      category: 'Vinyl',
      calculatorConfig: ProductCalculatorConfig.vinyl(),
    );

    final disabledProduct = Product(
      id: 'test-disabled',
      name: 'Test Disabled Calculator',
      description: 'No calculator needed',
      price: 15.99,
      imageAsset: 'assets/images/solid_wood.png',
      category: 'Simple',
      calculatorConfig: ProductCalculatorConfig.disabled(),
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 18.sp),
        ),
        title: Text(
          'Calculator Test',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test Calculator on Different Product Types',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 20.h),

            // Box-based product test
            _buildTestCard(
              title: 'Box-Based Product',
              subtitle: 'Should show length & width inputs',
              product: boxProduct,
            ),

            SizedBox(height: 16.h),

            // Carpet product test
            _buildTestCard(
              title: 'Carpet Product',
              subtitle: 'Should show length input & width selector (4m/5m)',
              product: carpetProduct,
            ),

            SizedBox(height: 16.h),

            // Vinyl product test
            _buildTestCard(
              title: 'Vinyl Product',
              subtitle: 'Should show length input & width selector (2m/3m/4m)',
              product: vinylProduct,
            ),

            SizedBox(height: 16.h),

            // Disabled calculator test
            _buildTestCard(
              title: 'Disabled Calculator',
              subtitle: 'Should NOT show calculator section',
              product: disabledProduct,
            ),

            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTestCard({
    required String title,
    required String subtitle,
    required Product product,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Get.to(
            () => ProductsDetails(product: product),
            transition: Transition.cupertino,
          );
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.calculate,
                  color: Colors.blue[600],
                  size: 24.sp,
                ),
              ),

              SizedBox(width: 16.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            product.calculatorConfig.calculatorType ==
                                CalculatorType.enabled
                            ? Colors.green[100]
                            : Colors.red[100],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        product.calculatorConfig.calculatorType ==
                                CalculatorType.enabled
                            ? 'Calculator Enabled'
                            : 'Calculator Disabled',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color:
                              product.calculatorConfig.calculatorType ==
                                  CalculatorType.enabled
                              ? Colors.green[700]
                              : Colors.red[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
