import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CallHistoryItemWidget extends StatelessWidget {
  final Map<String, dynamic> call;
  final bool isMultiSelectMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onCallBack;
  final VoidCallback onDelete;

  const CallHistoryItemWidget({
    Key? key,
    required this.call,
    required this.isMultiSelectMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.onCallBack,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(call["id"]),
      background: _buildSwipeBackground(context, isLeft: false),
      secondaryBackground: _buildSwipeBackground(context, isLeft: true),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        } else {
          onCallBack();
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 1.h),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                if (isMultiSelectMode) ...[
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) => onTap(),
                  ),
                  SizedBox(width: 3.w),
                ],
                _buildAvatar(),
                SizedBox(width: 4.w),
                Expanded(
                  child: _buildCallInfo(context),
                ),
                _buildCallTypeIcon(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(BuildContext context, {required bool isLeft}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeft ? AppTheme.error : AppTheme.success,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: isLeft ? 'delete' : 'call',
            color: Colors.white,
            size: 24,
          ),
          SizedBox(height: 0.5.h),
          Text(
            isLeft ? 'Delete' : 'Call',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.borderColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: ClipOval(
        child: call["avatar"] != null
            ? CustomImageWidget(
                imageUrl: call["avatar"],
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover,
              )
            : Container(
                color: AppTheme.primary.withValues(alpha: 0.1),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'person',
                    color: AppTheme.primary,
                    size: 20,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildCallInfo(BuildContext context) {
    final timestamp = call["timestamp"] as DateTime;
    final timeAgo = _getTimeAgo(timestamp);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          call["contactName"] ?? call["phoneNumber"],
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 0.5.h),
        Row(
          children: [
            Text(
              call["phoneNumber"],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
            ),
            if (call["duration"] != "0:00") ...[
              Text(
                ' • ${call["duration"]}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              ),
            ],
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          timeAgo,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
              ),
        ),
      ],
    );
  }

  Widget _buildCallTypeIcon(BuildContext context) {
    Color iconColor;
    String iconName;

    switch (call["callType"]) {
      case "missed":
        iconColor = AppTheme.error;
        iconName = 'call_received';
        break;
      case "outgoing":
        iconColor = AppTheme.success;
        iconName = 'call_made';
        break;
      case "incoming":
        iconColor = Colors.blue;
        iconName = 'call_received';
        break;
      default:
        iconColor =
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
        iconName = 'call';
    }

    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: CustomIconWidget(
        iconName: iconName,
        color: iconColor,
        size: 18,
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
