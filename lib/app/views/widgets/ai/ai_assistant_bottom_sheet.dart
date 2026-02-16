import 'package:floor_bot_mobile/app/controllers/ai_assistant_controller.dart';
import 'package:floor_bot_mobile/app/core/utils/themes/app_colors.dart';
import 'dart:convert';

import 'package:floor_bot_mobile/app/views/widgets/ai/ai_prompt_card.dart';
import 'package:floor_bot_mobile/app/views/widgets/explore/product_card.dart';
import 'package:floor_bot_mobile/app/views/screens/products/products_details.dart';
import 'package:floor_bot_mobile/app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AiAssistantBottomSheet extends StatelessWidget {
  const AiAssistantBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AiAssistantController());

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade400, Colors.blue.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'DMS AI Assistant',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => controller.closeSheet(),
                  icon: Icon(Icons.close, color: Colors.grey[600], size: 24.sp),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Content
          Flexible(
            child: Obx(
              () => controller.isChatMode.value
                  ? _buildChatView(controller)
                  : _buildPromptsView(controller),
            ),
          ),

          // Bottom input field
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: Offset(0, -2),
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
                        controller: controller.textController,
                        decoration: InputDecoration(
                          hintText: 'Tap here to write',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => controller.handleSend(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        color: controller.isListening.value 
                            ? Colors.red 
                            : AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => controller.hasText.value
                            ? controller.handleSend()
                            : controller.handleVoiceInput(),
                        icon: Icon(
                          controller.isListening.value
                              ? Icons.stop
                              : (controller.hasText.value ? Icons.send : Icons.mic),
                          color: Colors.white,
                          size: 22.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptsView(AiAssistantController controller) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prompt suggestions
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.prompts.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final prompt = controller.prompts[index];
              return AiPromptCard(
                title: prompt.title,
                description: prompt.description,
                onTap: () => controller.handlePromptTap(prompt),
              );
            },
          ),
          SizedBox(height: 80.h), // Space for input field
        ],
      ),
    );
  }

  Widget _buildChatView(AiAssistantController controller) {
    return Column(
      children: [
        // Back button
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: controller.backToPrompts,
              icon: Icon(Icons.arrow_back, size: 18.sp),
              label: Text('Back to prompts'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
              ),
            ),
          ),
        ),
        // Chat messages
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            itemCount: controller.messages.length,
            itemBuilder: (context, index) {
              final message = controller.messages[index];
              return _buildChatBubble(message);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    // If this is an AI message, try to parse embedded JSON with `products`
    if (!message.isUser) {
      try {
        dynamic decoded;
        try {
          decoded = json.decode(message.text);
        } catch (_) {
          final idx = message.text.indexOf('{');
          if (idx != -1) decoded = json.decode(message.text.substring(idx));
        }

        if (decoded is Map && decoded['products'] is List && (decoded['products'] as List).isNotEmpty) {
          final raw = decoded['products'] as List;
          final products = <Product>[];
          for (final it in raw) {
            if (it is Map<String, dynamic>) {
              try {
                products.add(Product.fromJson(it));
              } catch (_) {
                // ignore malformed entries
              }
            } else if (it is Map) {
              try {
                products.add(Product.fromJson(Map<String, dynamic>.from(it)));
              } catch (_) {}
            }
          }

          final visible = products.where((p) => (p.imageUrl != null && p.imageUrl!.isNotEmpty) || p.id.isNotEmpty).toList();
          if (visible.isNotEmpty) {
            String? normalize(String? img) {
              if (img == null || img.isEmpty) return null;
              // If it's already an absolute URL, keep as is
              if (img.startsWith('http')) return img;

              // Normalize duplicated api segments by taking substring from the last '/api/v1'
              final marker = '/api/v1';
              final idx = img.lastIndexOf(marker);
              if (idx != -1) {
                img = img.substring(idx); // keeps '/api/v1/....' from the last occurrence
              }

              // Ensure leading slash
              if (!img.startsWith('/')) img = '/$img';

              return img;
            }

            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                width: Get.width * 0.95,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: SizedBox(
                  height: 210.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: visible.length,
                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      final p = visible[index];
                      final img = normalize(p.imageUrl);
                      return ProductCard(
                        imageUrl: img,
                        title: p.name,
                        subtitle: p.description,
                        price: p.price > 0 ? '£${p.price.toStringAsFixed(2)}' : '',
                        width: p.width,
                        length: p.length,
                        onTap: () => Get.to(() => ProductsDetails(product: p)),
                        onAddTap: () {},
                        showAddButton: false,
                      );
                    },
                  ),
                ),
              ),
            );
          }
        }
      } catch (e) {
        // ignore parse errors and fall back to text bubble
      }
    }

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        constraints: BoxConstraints(maxWidth: Get.width * 0.75),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black87,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
