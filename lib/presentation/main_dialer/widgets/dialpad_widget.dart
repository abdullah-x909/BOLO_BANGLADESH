import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DialpadWidget extends StatelessWidget {
  final Function(String) onDigitPressed;
  final bool isDarkMode;

  const DialpadWidget({
    Key? key,
    required this.onDigitPressed,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 80.w,
      ),
      child: Column(
        children: [
          // Row 1: 1, 2, 3
          _buildDialpadRow(['1', '2', '3'], ['', 'ABC', 'DEF']),
          SizedBox(height: 2.h),

          // Row 2: 4, 5, 6
          _buildDialpadRow(['4', '5', '6'], ['GHI', 'JKL', 'MNO']),
          SizedBox(height: 2.h),

          // Row 3: 7, 8, 9
          _buildDialpadRow(['7', '8', '9'], ['PQRS', 'TUV', 'WXYZ']),
          SizedBox(height: 2.h),

          // Row 4: *, 0, #
          _buildDialpadRow(['*', '0', '#'], ['', '+', '']),
        ],
      ),
    );
  }

  Widget _buildDialpadRow(List<String> digits, List<String> letters) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.asMap().entries.map((entry) {
        int index = entry.key;
        String digit = entry.value;
        String letter = letters[index];

        return _buildDialpadButton(digit, letter);
      }).toList(),
    );
  }

  Widget _buildDialpadButton(String digit, String letters) {
    return Container(
      width: 18.w,
      height: 18.w,
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.cardDark : AppTheme.cardLight,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDarkMode
              ? AppTheme.borderColor.withValues(alpha: 0.3)
              : AppTheme.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? AppTheme.shadowColorDark : AppTheme.shadowColor,
            offset: Offset(0, 2),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18.w),
          onTap: () => onDigitPressed(digit),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  digit,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode
                        ? AppTheme.textHighEmphasisDark
                        : AppTheme.textHighEmphasisLight,
                  ),
                ),
                if (letters.isNotEmpty)
                  Text(
                    letters,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: isDarkMode
                          ? AppTheme.textMediumEmphasisDark
                          : AppTheme.textMediumEmphasisLight,
                      letterSpacing: 0.5,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
