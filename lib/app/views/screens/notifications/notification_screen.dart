import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:floor_bot_mobile/app/controllers/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xFF2C3E50),
            ),
          );
        }

        // Empty state
        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 80.sp,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16.h),
                Text(
                  'No notifications yet',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'You\'ll see notifications here',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        // Notification list
        return RefreshIndicator(
          onRefresh: () => controller.refreshNotifications(),
          color: Color(0xFF2C3E50),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            itemCount: controller.notifications.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[200],
            ),
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              final color = controller.getColorForType(notification.noteType);
              final icon = controller.getIconForType(notification.noteType);

              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            notification.content,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
