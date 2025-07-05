import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CallFilterBottomSheet extends StatelessWidget {
  final String currentFilter;
  final Function(String) onFilterChanged;

  const CallFilterBottomSheet({
    Key? key,
    required this.currentFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filters = [
      {
        'name': 'All Calls',
        'icon': 'call',
        'description': 'Show all call types'
      },
      {
        'name': 'Missed',
        'icon': 'call_received',
        'description': 'Missed calls only'
      },
      {
        'name': 'Outgoing',
        'icon': 'call_made',
        'description': 'Outgoing calls only'
      },
      {
        'name': 'Incoming',
        'icon': 'call_received',
        'description': 'Incoming calls only'
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(6.w),
            child: Row(
              children: [
                Text(
                  'Filter Calls',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Filter options
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filters.length,
            itemBuilder: (context, index) {
              final filter = filters[index];
              final isSelected = currentFilter == filter['name'];

              return ListTile(
                leading: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primary.withValues(alpha: 0.1)
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: filter['icon'] as String,
                    color: isSelected
                        ? AppTheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                    size: 20,
                  ),
                ),
                title: Text(
                  filter['name'] as String,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isSelected
                            ? AppTheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                ),
                subtitle: Text(
                  filter['description'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                ),
                trailing: isSelected
                    ? CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.primary,
                        size: 24,
                      )
                    : null,
                onTap: () {
                  onFilterChanged(filter['name'] as String);
                  Navigator.pop(context);
                },
              );
            },
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
