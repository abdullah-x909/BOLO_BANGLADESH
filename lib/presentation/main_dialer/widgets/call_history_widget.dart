import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CallHistoryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentCalls;
  final bool isDarkMode;
  final Function(String) onCallTap;
  final Function(Map<String, dynamic>) onCallLongPress;

  const CallHistoryWidget({
    Key? key,
    required this.recentCalls,
    required this.isDarkMode,
    required this.onCallTap,
    required this.onCallLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Text(
            'Recent Calls',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDarkMode
                  ? AppTheme.textHighEmphasisDark
                  : AppTheme.textHighEmphasisLight,
            ),
          ),
        ),
        SizedBox(height: 1.h),

        // Recent calls as chips
        Container(
          height: 12.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recentCalls.length > 5 ? 5 : recentCalls.length,
            itemBuilder: (context, index) {
              final call = recentCalls[index];
              return _buildRecentCallChip(call);
            },
          ),
        ),

        SizedBox(height: 2.h),

        // Recent calls list
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: recentCalls.length > 5 ? 5 : recentCalls.length,
          itemBuilder: (context, index) {
            final call = recentCalls[index];
            return _buildCallHistoryItem(call);
          },
        ),
      ],
    );
  }

  Widget _buildRecentCallChip(Map<String, dynamic> call) {
    return Container(
      margin: EdgeInsets.only(right: 2.w),
      child: GestureDetector(
        onTap: () => onCallTap(call["number"] as String),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: isDarkMode ? AppTheme.cardDark : AppTheme.cardLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDarkMode
                  ? AppTheme.borderColor.withValues(alpha: 0.3)
                  : AppTheme.borderColor,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                call["name"] as String,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? AppTheme.textHighEmphasisDark
                      : AppTheme.textHighEmphasisLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                (call["number"] as String).length > 12
                    ? '${(call["number"] as String).substring(0, 12)}...'
                    : call["number"] as String,
                style: AppTheme.getMonospaceStyle(
                  isLight: !isDarkMode,
                  fontSize: 10.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallHistoryItem(Map<String, dynamic> call) {
    IconData callIcon;
    Color iconColor;

    switch (call["type"] as String) {
      case "incoming":
        callIcon = Icons.call_received;
        iconColor = AppTheme.success;
        break;
      case "outgoing":
        callIcon = Icons.call_made;
        iconColor = isDarkMode ? AppTheme.primaryLight : AppTheme.primary;
        break;
      case "missed":
        callIcon = Icons.call_received;
        iconColor = AppTheme.error;
        break;
      default:
        callIcon = Icons.call;
        iconColor = isDarkMode
            ? AppTheme.textMediumEmphasisDark
            : AppTheme.textMediumEmphasisLight;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => onCallTap(call["number"] as String),
          onLongPress: () => onCallLongPress(call),
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: isDarkMode ? AppTheme.cardDark : AppTheme.cardLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDarkMode
                    ? AppTheme.borderColor.withValues(alpha: 0.3)
                    : AppTheme.borderColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    callIcon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        call["name"] as String,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode
                              ? AppTheme.textHighEmphasisDark
                              : AppTheme.textHighEmphasisLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        call["number"] as String,
                        style: AppTheme.getMonospaceStyle(
                          isLight: !isDarkMode,
                          fontSize: 12.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      call["duration"] as String,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode
                            ? AppTheme.textMediumEmphasisDark
                            : AppTheme.textMediumEmphasisLight,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      call["timestamp"] as String,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: isDarkMode
                            ? AppTheme.textDisabledDark
                            : AppTheme.textDisabledLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
