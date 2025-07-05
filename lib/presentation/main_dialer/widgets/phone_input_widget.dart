import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhoneInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool isDarkMode;
  final VoidCallback onBackspacePressed;

  const PhoneInputWidget({
    Key? key,
    required this.controller,
    required this.isDarkMode,
    required this.onBackspacePressed,
  }) : super(key: key);

  String _formatPhoneNumber(String input) {
    if (input.isEmpty) return input;

    // Remove all non-digit characters
    String digits = input.replaceAll(RegExp(r'[^\d]'), '');

    // Format based on length
    if (digits.length <= 3) {
      return digits;
    } else if (digits.length <= 7) {
      return '${digits.substring(0, 3)}-${digits.substring(3)}';
    } else if (digits.length <= 11) {
      return '${digits.substring(0, 3)}-${digits.substring(3, 6)}-${digits.substring(6)}';
    } else {
      return '${digits.substring(0, 3)}-${digits.substring(3, 6)}-${digits.substring(6, 10)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.cardDark : AppTheme.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? AppTheme.borderColor.withValues(alpha: 0.3)
              : AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTheme.getMonospaceStyle(
                isLight: !isDarkMode,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Enter phone number',
                hintStyle: TextStyle(
                  color: isDarkMode
                      ? AppTheme.textDisabledDark
                      : AppTheme.textDisabledLight,
                  fontSize: 16.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              keyboardType: TextInputType.phone,
              textAlign: TextAlign.center,
              readOnly: true, // Prevent keyboard from showing
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: onBackspacePressed,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppTheme.textMediumEmphasisDark.withValues(alpha: 0.1)
                      : AppTheme.textMediumEmphasisLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'backspace',
                  color: isDarkMode
                      ? AppTheme.textMediumEmphasisDark
                      : AppTheme.textMediumEmphasisLight,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
