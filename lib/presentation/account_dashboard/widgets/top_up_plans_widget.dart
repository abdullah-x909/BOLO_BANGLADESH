import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TopUpPlansWidget extends StatelessWidget {
  final List<Map<String, dynamic>> plans;
  final bool isDarkMode;
  final Function(Map<String, dynamic>) onBuyNow;

  const TopUpPlansWidget({
    Key? key,
    required this.plans,
    required this.isDarkMode,
    required this.onBuyNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: plans.map((plan) => _buildPlanCard(context, plan)).toList(),
    );
  }

  Widget _buildPlanCard(BuildContext context, Map<String, dynamic> plan) {
    final bool isPopular = plan["isPopular"] as bool? ?? false;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.cardDark : AppTheme.cardLight,
        borderRadius: BorderRadius.circular(12.0),
        border: isPopular
            ? Border.all(
                color: isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
                width: 2.0,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? AppTheme.shadowColorDark : AppTheme.shadowColor,
            offset: const Offset(0, 2),
            blurRadius: isPopular ? 12.0 : 8.0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      plan["name"] as String? ?? "",
                      style: (isDarkMode
                              ? AppTheme.darkTheme.textTheme.titleLarge
                              : AppTheme.lightTheme.textTheme.titleLarge)
                          ?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan["currency"] as String? ?? "৳",
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
                        Text(
                          (plan["price"] as double? ?? 0.0).toStringAsFixed(0),
                          style: (isDarkMode
                                  ? AppTheme.darkTheme.textTheme.headlineMedium
                                  : AppTheme
                                      .lightTheme.textTheme.headlineMedium)
                              ?.copyWith(
                            color: isDarkMode
                                ? AppTheme.primaryLight
                                : AppTheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 1.h),

                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: isDarkMode
                          ? AppTheme.textMediumEmphasisDark
                          : AppTheme.textSecondary,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '${plan["minutes"] as int? ?? 0} মিনিট',
                      style: (isDarkMode
                              ? AppTheme.darkTheme.textTheme.titleMedium
                              : AppTheme.lightTheme.textTheme.titleMedium)
                          ?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Features
                if (plan["features"] != null) ...[
                  ...(plan["features"] as List).map((feature) => Padding(
                        padding: EdgeInsets.only(bottom: 0.5.h),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'check_circle',
                              color: AppTheme.success,
                              size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                feature as String,
                                style: (isDarkMode
                                        ? AppTheme
                                            .darkTheme.textTheme.bodyMedium
                                        : AppTheme
                                            .lightTheme.textTheme.bodyMedium)
                                    ?.copyWith(
                                  color: isDarkMode
                                      ? AppTheme.textMediumEmphasisDark
                                      : AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],

                SizedBox(height: 2.h),

                // Buy Now Button
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: () => onBuyNow(plan),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
                      foregroundColor:
                          isDarkMode ? AppTheme.textPrimary : AppTheme.surface,
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'shopping_cart',
                          color: isDarkMode
                              ? AppTheme.textPrimary
                              : AppTheme.surface,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'এখনই কিনুন',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Popular Badge
          if (isPopular)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0),
                  ),
                ),
                child: Text(
                  'জনপ্রিয়',
                  style: TextStyle(
                    color: isDarkMode ? AppTheme.textPrimary : AppTheme.surface,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
