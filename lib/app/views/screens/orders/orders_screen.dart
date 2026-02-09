import 'package:floor_bot_mobile/app/core/utils/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:floor_bot_mobile/app/controllers/order_controller.dart';
import 'package:floor_bot_mobile/app/views/screens/orders/order_details_screen.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final orderController = Get.put(OrderController());
  late ScrollController _inProgressScrollController;
  late ScrollController _completedScrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _inProgressScrollController = ScrollController();
    _completedScrollController = ScrollController();

    // Add scroll listeners for pagination
    _inProgressScrollController.addListener(_onInProgressScroll);
    _completedScrollController.addListener(_onCompletedScroll);
  }

  void _onInProgressScroll() {
    if (_inProgressScrollController.position.pixels >=
        _inProgressScrollController.position.maxScrollExtent - 200) {
      orderController.loadMoreOrders();
    }
  }

  void _onCompletedScroll() {
    if (_completedScrollController.position.pixels >=
        _completedScrollController.position.maxScrollExtent - 200) {
      orderController.loadMoreOrders();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _inProgressScrollController.dispose();
    _completedScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: Text(
          'Orders',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0xFFB8D932), // Yellow-green color
                  borderRadius: BorderRadius.circular(12.r),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[600],
                labelStyle: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
                unselectedLabelStyle: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                ),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'In progress'),
                  Tab(text: 'Completed'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildInProgressOrders(), _buildCompletedOrders()],
      ),
    );
  }

  Widget _buildInProgressOrders() {
    return Obx(() {
      final inProgressOrders = orderController.inProgressOrders;

      if (inProgressOrders.isEmpty && !orderController.isLoadingMore.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 80.w,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16.h),
              Text(
                'No orders in progress',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        controller: _inProgressScrollController,
        padding: EdgeInsets.all(16.w),
        itemCount:
            inProgressOrders.length +
            (orderController.hasMoreData.value ? 1 : 0),
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          // Show loading indicator at bottom
          if (index == inProgressOrders.length) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            );
          }

          final order = inProgressOrders[index];
          return _buildOrderCard(
            orderId: order.id,
            productName: order.productName,
            size: order.size,
            price: order.pricePerUnit,
            status: order.statusText,
            statusProgress: order.statusProgress,
            imageAsset: order.imageAsset,
          );
        },
      );
    });
  }

  Widget _buildCompletedOrders() {
    return Obx(() {
      final completedOrders = orderController.completedOrders;

      if (completedOrders.isEmpty && !orderController.isLoadingMore.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 80.w,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16.h),
              Text(
                'No completed orders yet',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        controller: _completedScrollController,
        padding: EdgeInsets.all(16.w),
        itemCount:
            completedOrders.length +
            (orderController.hasMoreData.value ? 1 : 0),
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          // Show loading indicator at bottom
          if (index == completedOrders.length) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            );
          }

          final order = completedOrders[index];
          return _buildOrderCard(
            orderId: order.id,
            productName: order.productName,
            size: order.size,
            price: order.pricePerUnit,
            status: order.statusText,
            statusProgress: order.statusProgress,
            imageAsset: order.imageAsset,
          );
        },
      );
    });
  }

  Widget _buildOrderCard({
    required String orderId,
    required String productName,
    required String size,
    required String price,
    required String status,
    required double statusProgress,
    required String imageAsset,
  }) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Product Image
              Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child:
                      imageAsset.startsWith('http') ||
                          imageAsset.startsWith('/api')
                      ? Image.network(
                          imageAsset.startsWith('/api')
                              ? 'http://10.10.12.15:8089$imageAsset'
                              : imageAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image,
                              size: 40.w,
                              color: Colors.grey[400],
                            );
                          },
                        )
                      : Image.asset(
                          imageAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image,
                              size: 40.w,
                              color: Colors.grey[400],
                            );
                          },
                        ),
                ),
              ),
              SizedBox(width: 12.w),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: $orderId',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      productName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      size,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      price,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 4.h,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 12.r),
                  activeTrackColor: Colors.black,
                  inactiveTrackColor: Colors.grey[300],
                  thumbColor: Colors.black,
                ),
                child: Slider(
                  value: statusProgress,
                  onChanged: null, // Disabled slider
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                status,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Order Details Button
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                // Navigate to order details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsScreen(orderId: orderId),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Order details',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.arrow_forward, size: 16.sp),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
