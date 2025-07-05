import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UserInfoCardWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final bool isDarkMode;

  const UserInfoCardWidget({
    Key? key,
    required this.userData,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.cardDark : AppTheme.cardLight,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? AppTheme.shadowColorDark : AppTheme.shadowColor,
            offset: const Offset(0, 2),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Profile Avatar
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
                    width: 2.0,
                  ),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: userData["profileImage"] as String? ?? "",
                    width: 20.w,
                    height: 20.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(width: 4.w),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData["userName"] as String? ?? "ব্যবহারকারী",
                      style: (isDarkMode
                              ? AppTheme.darkTheme.textTheme.titleLarge
                              : AppTheme.lightTheme.textTheme.titleLarge)
                          ?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 0.5.h),

                    Text(
                      'কলার আইডি: ${userData["callerID"] as String? ?? "N/A"}',
                      style: (isDarkMode
                              ? AppTheme.darkTheme.textTheme.bodyMedium
                              : AppTheme.lightTheme.textTheme.bodyMedium)
                          ?.copyWith(
                        color: isDarkMode
                            ? AppTheme.textMediumEmphasisDark
                            : AppTheme.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 1.h),

                    // Available Minutes
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: (isDarkMode
                                ? AppTheme.primaryLight
                                : AppTheme.primary)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'access_time',
                            color: isDarkMode
                                ? AppTheme.primaryLight
                                : AppTheme.primary,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '${userData["availableMinutes"] as int? ?? 0} মিনিট',
                            style: (isDarkMode
                                    ? AppTheme.darkTheme.textTheme.titleMedium
                                    : AppTheme.lightTheme.textTheme.titleMedium)
                                ?.copyWith(
                              color: isDarkMode
                                  ? AppTheme.primaryLight
                                  : AppTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  'মোট কল',
                  '${userData["totalCalls"] as int? ?? 0}',
                  'call',
                ),
              ),
              Container(
                width: 1,
                height: 6.h,
                color: isDarkMode
                    ? AppTheme.borderColor.withValues(alpha: 0.3)
                    : AppTheme.borderColor,
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  'মোট খরচ',
                  '৳${(userData["totalSpent"] as double? ?? 0.0).toStringAsFixed(0)}',
                  'account_balance_wallet',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, String label, String value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
          size: 24,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: (isDarkMode
                  ? AppTheme.darkTheme.textTheme.titleLarge
                  : AppTheme.lightTheme.textTheme.titleLarge)
              ?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: (isDarkMode
                  ? AppTheme.darkTheme.textTheme.bodySmall
                  : AppTheme.lightTheme.textTheme.bodySmall)
              ?.copyWith(
            color: isDarkMode
                ? AppTheme.textMediumEmphasisDark
                : AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
