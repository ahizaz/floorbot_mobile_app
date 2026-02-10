import 'package:floor_bot_mobile/app/controllers/support_chat_controller.dart';
import 'package:floor_bot_mobile/app/core/utils/urls.dart';
import 'package:floor_bot_mobile/app/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SupportChatScreen extends StatelessWidget {
  const SupportChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SupportChatController());
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[600],
              radius: 18.r,
              child: Icon(
                Icons.support_agent,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Support DMS',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.messages.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.messages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 80.sp,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No messages yet',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Start a conversation with our support team',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: controller.refreshMessages,
                child: ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return _buildMessageBubble(message, controller);
                  },
                ),
              );
            }),
          ),
          _buildMessageInput(controller),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    ChatMessage message,
    SupportChatController controller,
  ) {
    // Check if message is from current user (right side) or others (left side)
    final isMyMessage = controller.isMyMessage(message.sender.id);
    final time = DateFormat('hh:mm a').format(message.createdAt);
    final senderName = message.sender.fullName;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: isMyMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMyMessage) ...[
            _buildProfileAvatar(message.sender.image, isMyMessage: false),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isMyMessage ? Colors.blue[600] : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMyMessage ? 16.r : 4.r),
                  topRight: Radius.circular(isMyMessage ? 4.r : 16.r),
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMyMessage && senderName.isNotEmpty) ...[
                    Text(
                      senderName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[700],
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isMyMessage ? Colors.white : Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: isMyMessage ? Colors.white70 : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMyMessage) ...[
            SizedBox(width: 8.w),
            _buildProfileAvatar(message.sender.image, isMyMessage: true),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput(SupportChatController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: TextField(
                  controller: controller.messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Obx(
              () => controller.isSending.value
                  ? SizedBox(
                      width: 48.w,
                      height: 48.w,
                      child: Center(
                        child: SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: controller.sendMessage,
                      child: Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(String? imageUrl, {required bool isMyMessage}) {
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    final fullImageUrl = hasImage && !imageUrl.startsWith('http')
        ? '${Urls.serverBase}$imageUrl'
        : imageUrl;

    return CircleAvatar(
      backgroundColor: isMyMessage ? Colors.grey[300] : Colors.blue[600],
      radius: 16.r,
      backgroundImage: hasImage ? NetworkImage(fullImageUrl!) : null,
      child: hasImage
          ? null
          : Icon(
              isMyMessage ? Icons.person : Icons.support_agent,
              color: isMyMessage ? Colors.grey[600] : Colors.white,
              size: 16.sp,
            ),
    );
  }
}
