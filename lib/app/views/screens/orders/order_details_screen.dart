import 'package:floor_bot_mobile/app/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:floor_bot_mobile/app/controllers/order_controller.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderController = Get.find<OrderController>();
    final order = orderController.getOrderById(orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Not Found')),
        body: const Center(child: Text('Order not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D3142),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Order ID: ${order.id}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // Product Card
                  _buildProductCard(theme, order),
                  SizedBox(height: 16.h),
                  // Payment Details Card
                  _buildPaymentDetailsCard(theme, order),
                ],
              ),
            ),
          ),
          // Mark as delivered button
          _buildBottomButton(context, order),
        ],
      ),
    );
  }

  Widget _buildProductCard(ThemeData theme, order) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!, width: 1.w),
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
             child: order.imageAsset.startsWith('http') || order.imageAsset.startsWith('/api')
  ? Image.network(
      order.imageAsset.startsWith('/api') 
        ? 'http://10.10.12.15:8089${order.imageAsset}' 
        : order.imageAsset,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Image load error: $error');
        return Icon(Icons.image, size: 40.w, color: Colors.grey[400]);
      },
    )
  : Image.asset(
      order.imageAsset,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.image, size: 40.w, color: Colors.grey[400]);
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
                  order.productName,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  order.size,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  order.pricePerUnit,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                // Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 4.h,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 6.r,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 12.r,
                        ),
                        activeTrackColor: Colors.black,
                        inactiveTrackColor: Colors.grey[300],
                        thumbColor: Colors.black,
                      ),
                      child: Slider(
                        value: order.statusProgress,
                        onChanged: null, // Disabled slider
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      order.statusText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailsCard(ThemeData theme, order) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!, width: 1.w),

        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment details',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 20.h),
          // Quantity
          _buildDetailRow('Qty', '${order.quantity}box', theme),
          SizedBox(height: 12.h),
          // Unit Price
          _buildDetailRow(
            'Unit price',
            '\$${order.unitPrice.toStringAsFixed(2)}',
            theme,
          ),
          SizedBox(height: 12.h),
          // Subtotal
          _buildDetailRow(
            'Subtotal',
            '\$${order.subtotal.toStringAsFixed(2)}',
            theme,
            isBold: true,
          ),
          SizedBox(height: 16.h),
          // Dotted line
          _buildDottedLine(),
          SizedBox(height: 16.h),
          // Delivery fee
          _buildDetailRow(
            'Delivery fee',
            '\$${order.deliveryFee.toStringAsFixed(2)}',
            theme,
          ),
          SizedBox(height: 12.h),
          // Tax
          _buildDetailRow('TAX', '\$${order.tax.toStringAsFixed(2)}', theme),
          SizedBox(height: 16.h),
          // Dotted line
          _buildDottedLine(),
          SizedBox(height: 16.h),
          // Total
          _buildDetailRow(
            'Total',
            '\$${order.total.toStringAsFixed(2)}',
            theme,
            isBold: true,
            isTotal: true,
          ),
          SizedBox(height: 24.h),
        
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    ThemeData theme, {
    bool isBold = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: isBold || isTotal ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: isBold || isTotal ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildDottedLine() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashWidth = 5.w;
        final dashSpace = 3.w;
        final dashCount = (constraints.maxWidth / (dashWidth + dashSpace))
            .floor();

        return Row(
          children: List.generate(dashCount, (index) {
            return Container(
              width: dashWidth,
              height: 1.h,
              color: Colors.grey[300],
              margin: EdgeInsets.only(right: dashSpace),
            );
          }),
        );
      },
    );
  }

  Widget _buildBottomButton(BuildContext context, order) {
    final orderController = Get.find<OrderController>();
     if (order.status != OrderStatus.inTransit) {
    return const SizedBox.shrink(); // Button hide
  }

    return Container(
      padding: EdgeInsets.all(16.w),

      child: SafeArea(
        top: false,
        child: ElevatedButton(
          onPressed: () {
            // Mark as delivered functionality
            _showDeliveredDialog(context, order.id, orderController);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,

            minimumSize: Size(double.infinity, 54.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.r),
            ),
            elevation: 0,
          ),
          child: Text(
            'Mark as delivered',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  void _showDeliveredDialog(
    BuildContext context,
    String orderId,
    OrderController orderController,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark as Delivered'),
        content: const Text('Are you sure this order has been delivered?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              orderController.markAsDelivered(orderId);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close order details screen

              // Show feedback bottom sheet after a short delay using Get
              Future.delayed(const Duration(milliseconds: 300), () {
                _showFeedbackBottomSheet();
              });
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackBottomSheet() {
    final TextEditingController feedbackController = TextEditingController();

    Get.bottomSheet(
      Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Thumbs up icon
              Icon(
                Icons.thumb_up_outlined,
                size: 48.sp,
                color: Colors.grey[700],
              ),
              SizedBox(height: 16.h),

              // Title
              Text(
                'Feedback',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 24.h),

              // Text field
              TextField(
                controller: feedbackController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Let us know how could we improve...',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14.sp,
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: Colors.grey[400]!,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Buttons row
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 54.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'cancel',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Submit button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle feedback submission
                        final feedback = feedbackController.text.trim();
                        if (feedback.isNotEmpty) {
                          // TODO: Send feedback to backend
                          Get.back();
                          Get.snackbar(
                            'Thank you!',
                            'Your feedback has been submitted',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else {
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D3142),
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 54.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
    );
  }
}
