import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UploadSectionWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final File? uploadedImage;
  final bool isUploading;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const UploadSectionWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.uploadedImage,
    required this.isUploading,
    required this.onTap,
    required this.onRemove,
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

        // Upload Area
        GestureDetector(
          onTap: uploadedImage == null ? onTap : null,
          onLongPress:
              uploadedImage != null ? () => _showImageOptions(context) : null,
          child: Container(
            width: double.infinity,
            height: uploadedImage != null ? 25.h : 20.h,
            decoration: BoxDecoration(
              color: uploadedImage != null
                  ? AppTheme.lightTheme.colorScheme.surface
                  : AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: uploadedImage != null
                    ? AppTheme.primary.withValues(alpha: 0.3)
                    : AppTheme.lightTheme.colorScheme.outline,
                width: uploadedImage != null ? 2 : 1,
                style: uploadedImage == null
                    ? BorderStyle.solid
                    : BorderStyle.solid,
              ),
            ),
            child: uploadedImage != null
                ? _buildImagePreview()
                : _buildUploadPlaceholder(),
          ),
        ),

        if (uploadedImage != null) ...[
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: onTap,
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.primary,
                  size: 16,
                ),
                label: Text(
                  'Replace',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              TextButton.icon(
                onPressed: onRemove,
                icon: CustomIconWidget(
                  iconName: 'delete',
                  color: AppTheme.error,
                  size: 16,
                ),
                label: Text(
                  'Remove',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildUploadPlaceholder() {
    return isUploading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppTheme.primary,
                  strokeWidth: 3,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Uploading...',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'upload_file',
                  color: AppTheme.primary,
                  size: 32,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Tap to upload NID',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Select from gallery',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          );
  }

  Widget _buildImagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Image.file(
            uploadedImage!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 2.w,
            right: 2.w,
            child: Container(
              padding: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                color: AppTheme.success.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageOptions(BuildContext context) {
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
                iconName: 'edit',
                color: AppTheme.primary,
                size: 24,
              ),
              title: const Text('Replace Image'),
              onTap: () {
                Navigator.pop(context);
                onTap();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.error,
                size: 24,
              ),
              title: const Text('Remove Image'),
              onTap: () {
                Navigator.pop(context);
                onRemove();
              },
            ),
          ],
        ),
      ),
    );
  }
}
