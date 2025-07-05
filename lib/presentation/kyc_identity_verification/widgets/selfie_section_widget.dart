import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SelfieSectionWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final File? capturedImage;
  final bool isCapturing;
  final VoidCallback onCapture;
  final VoidCallback onRetake;

  const SelfieSectionWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.capturedImage,
    required this.isCapturing,
    required this.onCapture,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          subtitle,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(height: 2.h),

        // Selfie Area
        Center(
          child: Column(
            children: [
              // Circular selfie preview/placeholder
              GestureDetector(
                onTap: capturedImage == null ? onCapture : null,
                onLongPress: capturedImage != null
                    ? () => _showSelfieOptions(context)
                    : null,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: capturedImage != null
                        ? AppTheme.lightTheme.colorScheme.surface
                        : AppTheme.lightTheme.colorScheme.surface,
                    border: Border.all(
                      color: capturedImage != null
                          ? AppTheme.primary.withValues(alpha: 0.3)
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: capturedImage != null ? 3 : 2,
                    ),
                  ),
                  child: capturedImage != null
                      ? _buildSelfiePreview()
                      : _buildSelfiePlaceholder(),
                ),
              ),

              SizedBox(height: 3.h),

              // Capture/Retake Button
              if (capturedImage == null)
                ElevatedButton.icon(
                  onPressed: isCapturing ? null : onCapture,
                  icon: isCapturing
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        )
                      : CustomIconWidget(
                          iconName: 'camera_alt',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 20,
                        ),
                  label: Text(
                    isCapturing ? 'Opening Camera...' : 'Take Selfie',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: onCapture,
                      icon: CustomIconWidget(
                        iconName: 'camera_alt',
                        color: AppTheme.primary,
                        size: 18,
                      ),
                      label: Text(
                        'Retake',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppTheme.primary),
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    TextButton.icon(
                      onPressed: onRetake,
                      icon: CustomIconWidget(
                        iconName: 'delete',
                        color: AppTheme.error,
                        size: 18,
                      ),
                      label: Text(
                        'Remove',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelfiePlaceholder() {
    return isCapturing
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppTheme.primary,
                  strokeWidth: 3,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Opening\nCamera',
                  textAlign: TextAlign.center,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: AppTheme.primary,
                  size: 28,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Tap to\ncapture',
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: 10.sp,
                ),
              ),
            ],
          );
  }

  Widget _buildSelfiePreview() {
    return ClipOval(
      child: Stack(
        children: [
          Image.file(
            capturedImage!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 1.w,
            right: 1.w,
            child: Container(
              padding: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                color: AppTheme.success.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSelfieOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.primary,
                size: 24,
              ),
              title: const Text('Retake Selfie'),
              onTap: () {
                Navigator.pop(context);
                onCapture();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.error,
                size: 24,
              ),
              title: const Text('Remove Selfie'),
              onTap: () {
                Navigator.pop(context);
                onRetake();
              },
            ),
          ],
        ),
      ),
    );
  }
}
