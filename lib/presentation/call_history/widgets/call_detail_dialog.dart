import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CallDetailDialog extends StatelessWidget {
  final Map<String, dynamic> call;

  const CallDetailDialog({
    Key? key,
    required this.call,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with avatar and name
            _buildHeader(context),

            SizedBox(height: 4.h),

            // Call details
            _buildCallDetails(context),

            SizedBox(height: 4.h),

            // Action buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.borderColor.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: call["avatar"] != null
                ? CustomImageWidget(
                    imageUrl: call["avatar"],
                    width: 20.w,
                    height: 20.w,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'person',
                        color: AppTheme.primary,
                        size: 32,
                      ),
                    ),
                  ),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          call["contactName"] ?? 'Unknown',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 0.5.h),
        Text(
          call["phoneNumber"],
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCallDetails(BuildContext context) {
    final timestamp = call["timestamp"] as DateTime;
    final formattedDate =
        '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    final formattedTime =
        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            context,
            'Call Type',
            _getCallTypeText(),
            _getCallTypeIcon(),
          ),
          Divider(height: 3.h),
          _buildDetailRow(
            context,
            'Duration',
            call["duration"] == "0:00" ? 'Not answered' : call["duration"],
            'timer',
          ),
          Divider(height: 3.h),
          _buildDetailRow(
            context,
            'Date',
            formattedDate,
            'calendar_today',
          ),
          Divider(height: 3.h),
          _buildDetailRow(
            context,
            'Time',
            formattedTime,
            'access_time',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, String label, String value, String iconName) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          size: 20,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
              size: 18,
            ),
            label: Text('Close'),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/main-dialer');
            },
            icon: CustomIconWidget(
              iconName: 'call',
              color: Colors.white,
              size: 18,
            ),
            label: Text('Call Back'),
          ),
        ),
      ],
    );
  }

  String _getCallTypeText() {
    switch (call["callType"]) {
      case "missed":
        return 'Missed Call';
      case "outgoing":
        return 'Outgoing Call';
      case "incoming":
        return 'Incoming Call';
      default:
        return 'Unknown';
    }
  }

  String _getCallTypeIcon() {
    switch (call["callType"]) {
      case "missed":
        return 'call_received';
      case "outgoing":
        return 'call_made';
      case "incoming":
        return 'call_received';
      default:
        return 'call';
    }
  }
}
