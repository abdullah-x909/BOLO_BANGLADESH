import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AccountSettingsWidget extends StatefulWidget {
  final bool isDarkMode;
  final Function(String) onSettingTap;

  const AccountSettingsWidget({
    Key? key,
    required this.isDarkMode,
    required this.onSettingTap,
  }) : super(key: key);

  @override
  State<AccountSettingsWidget> createState() => _AccountSettingsWidgetState();
}

class _AccountSettingsWidgetState extends State<AccountSettingsWidget> {
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _settingsItems = [
    {
      "id": "profile",
      "title": "প্রোফাইল সেটিংস",
      "subtitle": "আপনার ব্যক্তিগত তথ্য সম্পাদনা করুন",
      "icon": "person",
      "color": null,
    },
    {
      "id": "payment_history",
      "title": "পেমেন্ট ইতিহাস",
      "subtitle": "আপনার সকল লেনদেনের বিবরণ দেখুন",
      "icon": "payment",
      "color": null,
    },
    {
      "id": "help_support",
      "title": "সাহায্য ও সহায়তা",
      "subtitle": "যোগাযোগ এবং সহায়তা পান",
      "icon": "help",
      "color": null,
    },
    {
      "id": "privacy_policy",
      "title": "গোপনীয়তা নীতি",
      "subtitle": "আমাদের গোপনীয়তা নীতি পড়ুন",
      "icon": "privacy_tip",
      "color": null,
    },
    {
      "id": "logout",
      "title": "লগ আউট",
      "subtitle": "আপনার অ্যাকাউন্ট থেকে বের হন",
      "icon": "logout",
      "color": "error",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.isDarkMode ? AppTheme.cardDark : AppTheme.cardLight,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: widget.isDarkMode
                ? AppTheme.shadowColorDark
                : AppTheme.shadowColor,
            offset: const Offset(0, 2),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: (widget.isDarkMode
                              ? AppTheme.primaryLight
                              : AppTheme.primary)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: CustomIconWidget(
                      iconName: 'settings',
                      color: widget.isDarkMode
                          ? AppTheme.primaryLight
                          : AppTheme.primary,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'অ্যাকাউন্ট সেটিংস',
                          style: (widget.isDarkMode
                                  ? AppTheme.darkTheme.textTheme.titleMedium
                                  : AppTheme.lightTheme.textTheme.titleMedium)
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'আপনার অ্যাকাউন্ট পরিচালনা করুন',
                          style: (widget.isDarkMode
                                  ? AppTheme.darkTheme.textTheme.bodyMedium
                                  : AppTheme.lightTheme.textTheme.bodyMedium)
                              ?.copyWith(
                            color: widget.isDarkMode
                                ? AppTheme.textMediumEmphasisDark
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: CustomIconWidget(
                      iconName: 'expand_more',
                      color: widget.isDarkMode
                          ? AppTheme.primaryLight
                          : AppTheme.primary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable Content
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isExpanded ? null : 0,
            child: _isExpanded
                ? Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: widget.isDarkMode
                            ? AppTheme.borderColor.withValues(alpha: 0.3)
                            : AppTheme.borderColor,
                      ),
                      ..._settingsItems.map((item) => _buildSettingItem(item)),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(Map<String, dynamic> item) {
    final bool isError = item["color"] == "error";

    return InkWell(
      onTap: () => widget.onSettingTap(item["id"] as String),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: widget.isDarkMode
                  ? AppTheme.borderColor.withValues(alpha: 0.3)
                  : AppTheme.borderColor,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isError
                    ? AppTheme.error.withValues(alpha: 0.1)
                    : (widget.isDarkMode
                            ? AppTheme.primaryLight
                            : AppTheme.primary)
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: CustomIconWidget(
                iconName: item["icon"] as String,
                color: isError
                    ? AppTheme.error
                    : widget.isDarkMode
                        ? AppTheme.primaryLight
                        : AppTheme.primary,
                size: 20,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["title"] as String,
                    style: (widget.isDarkMode
                            ? AppTheme.darkTheme.textTheme.titleSmall
                            : AppTheme.lightTheme.textTheme.titleSmall)
                        ?.copyWith(
                      color: isError ? AppTheme.error : null,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    item["subtitle"] as String,
                    style: (widget.isDarkMode
                            ? AppTheme.darkTheme.textTheme.bodySmall
                            : AppTheme.lightTheme.textTheme.bodySmall)
                        ?.copyWith(
                      color: widget.isDarkMode
                          ? AppTheme.textMediumEmphasisDark
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: widget.isDarkMode
                  ? AppTheme.textMediumEmphasisDark
                  : AppTheme.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
