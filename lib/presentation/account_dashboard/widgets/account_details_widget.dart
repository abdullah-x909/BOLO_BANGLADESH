import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AccountDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final bool isDarkMode;

  const AccountDetailsWidget({
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'অ্যাকাউন্ট বিবরণ',
            style: (isDarkMode
                    ? AppTheme.darkTheme.textTheme.titleLarge
                    : AppTheme.lightTheme.textTheme.titleLarge)
                ?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 2.h),

          _buildDetailRow(
            'বর্তমান প্ল্যান',
            userData["currentPlan"] as String? ?? "N/A",
            'card_membership',
          ),

          SizedBox(height: 1.5.h),

          _buildDetailRow(
            'প্ল্যান মেয়াদ',
            _formatDate(userData["planExpiry"] as String? ?? ""),
            'event',
          ),

          SizedBox(height: 1.5.h),

          _buildDetailRow(
            'যোগদানের তারিখ',
            _formatDate(userData["joinDate"] as String? ?? ""),
            'person_add',
          ),

          SizedBox(height: 2.h),

          // Upgrade Prompt
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (isDarkMode ? AppTheme.primaryLight : AppTheme.primary)
                      .withValues(alpha: 0.1),
                  (isDarkMode ? AppTheme.primaryLight : AppTheme.primary)
                      .withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: (isDarkMode ? AppTheme.primaryLight : AppTheme.primary)
                    .withValues(alpha: 0.3),
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'upgrade',
                  color: isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'আপগ্রেড করুন',
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
                      SizedBox(height: 0.5.h),
                      Text(
                        'আরও মিনিট এবং সুবিধার জন্য উচ্চতর প্ল্যানে আপগ্রেড করুন',
                        style: (isDarkMode
                                ? AppTheme.darkTheme.textTheme.bodySmall
                                : AppTheme.lightTheme.textTheme.bodySmall)
                            ?.copyWith(
                          color: isDarkMode
                              ? AppTheme.textMediumEmphasisDark
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'arrow_forward_ios',
                  color: isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, String iconName) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
          size: 20,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: (isDarkMode
                        ? AppTheme.darkTheme.textTheme.bodyLarge
                        : AppTheme.lightTheme.textTheme.bodyLarge)
                    ?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return "N/A";

    try {
      final DateTime date = DateTime.parse(dateString);
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    } catch (e) {
      return dateString;
    }
  }
}
