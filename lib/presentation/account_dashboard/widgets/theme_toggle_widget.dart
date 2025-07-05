import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ThemeToggleWidget extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggle;

  const ThemeToggleWidget({
    Key? key,
    required this.isDarkMode,
    required this.onToggle,
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: (isDarkMode ? AppTheme.primaryLight : AppTheme.primary)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: CustomIconWidget(
              iconName: isDarkMode ? 'dark_mode' : 'light_mode',
              color: isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
              size: 24,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'থিম',
                  style: (isDarkMode
                          ? AppTheme.darkTheme.textTheme.titleMedium
                          : AppTheme.lightTheme.textTheme.titleMedium)
                      ?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  isDarkMode ? 'ডার্ক মোড চালু' : 'লাইট মোড চালু',
                  style: (isDarkMode
                          ? AppTheme.darkTheme.textTheme.bodyMedium
                          : AppTheme.lightTheme.textTheme.bodyMedium)
                      ?.copyWith(
                    color: isDarkMode
                        ? AppTheme.textMediumEmphasisDark
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Switch(
              value: isDarkMode,
              onChanged: (value) => onToggle(),
              activeColor:
                  isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
              activeTrackColor:
                  (isDarkMode ? AppTheme.primaryLight : AppTheme.primary)
                      .withValues(alpha: 0.5),
              inactiveThumbColor: isDarkMode
                  ? AppTheme.textMediumEmphasisDark
                  : AppTheme.textSecondary,
              inactiveTrackColor: (isDarkMode
                      ? AppTheme.textMediumEmphasisDark
                      : AppTheme.textSecondary)
                  .withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}
