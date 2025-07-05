import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/payment_methods_widget.dart';
import './widgets/plan_card_widget.dart';

class TopUpPlans extends StatefulWidget {
  const TopUpPlans({super.key});

  @override
  State<TopUpPlans> createState() => _TopUpPlansState();
}

class _TopUpPlansState extends State<TopUpPlans> {
  bool _isLoading = false;

  // Mock data for top-up plans
  final List<Map<String, dynamic>> _plans = [
    {
      "id": 1,
      "name": "Starter",
      "price": "৳30",
      "minutes": 45,
      "validity": "7 days",
      "costPerMinute": "৳0.67",
      "features": [
        "45 minutes talk time",
        "7 days validity",
        "Local & International calls",
        "24/7 customer support"
      ],
      "isBestValue": false,
      "color": Colors.blue,
      "savings": null
    },
    {
      "id": 2,
      "name": "Popular",
      "price": "৳100",
      "minutes": 180,
      "validity": "30 days",
      "costPerMinute": "৳0.56",
      "features": [
        "180 minutes talk time",
        "30 days validity",
        "Local & International calls",
        "Priority customer support",
        "Free SMS notifications",
        "Call recording feature"
      ],
      "isBestValue": true,
      "color": Colors.orange,
      "savings": "Save ৳20"
    },
    {
      "id": 3,
      "name": "VIP",
      "price": "৳299",
      "minutes": 600,
      "validity": "90 days",
      "costPerMinute": "৳0.50",
      "features": [
        "600 minutes talk time",
        "90 days validity",
        "Local & International calls",
        "VIP customer support",
        "Free SMS notifications",
        "Call recording feature",
        "Conference calling",
        "Voicemail service"
      ],
      "isBestValue": false,
      "color": Colors.purple,
      "savings": "Save ৳80"
    }
  ];

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      "name": "bKash",
      "logo":
          "https://logos-world.net/wp-content/uploads/2022/01/bKash-Logo.png",
      "isAvailable": true
    },
    {
      "name": "Nagad",
      "logo":
          "https://seeklogo.com/images/N/nagad-logo-7A70CCFEE0-seeklogo.com.png",
      "isAvailable": false
    },
    {
      "name": "Rocket",
      "logo":
          "https://seeklogo.com/images/D/dutch-bangla-rocket-logo-B4D1CC458D-seeklogo.com.png",
      "isAvailable": false
    }
  ];

  String _currentBalance = "৳45.50";

  void _handleBuyNow(Map<String, dynamic> plan) {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading for bKash redirect
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Redirecting to bKash for ${plan["name"]} plan (${plan["price"]})...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
            backgroundColor: AppTheme.primary,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        );
      }
    });
  }

  void _showTermsAndConditions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Terms & Conditions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
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
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTermsSection('Plan Validity', [
                      'All plans are valid from the date of purchase',
                      'Unused minutes expire after validity period',
                      'No refund for unused minutes after expiry'
                    ]),
                    SizedBox(height: 2.h),
                    _buildTermsSection('Auto-Renewal', [
                      'Plans do not auto-renew by default',
                      'Users can enable auto-renewal in settings',
                      'Auto-renewal charges apply 24 hours before expiry'
                    ]),
                    SizedBox(height: 2.h),
                    _buildTermsSection('Payment Terms', [
                      'All payments are processed through bKash',
                      'Payment confirmation required for activation',
                      'Failed payments will not activate the plan'
                    ]),
                    SizedBox(height: 2.h),
                    _buildTermsSection('Fair Usage Policy', [
                      'Plans are for personal use only',
                      'Commercial usage is prohibited',
                      'Excessive usage may result in account suspension'
                    ]),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSection(String title, List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        ...points
            .map((point) => Padding(
                  padding: EdgeInsets.only(bottom: 0.5.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.only(top: 8, right: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          point,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 2,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color:
                Theme.of(context).appBarTheme.foregroundColor ?? Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          'Choose Your Plan',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'account_balance_wallet',
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  _currentBalance,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Redirecting to bKash...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plans section
                  Text(
                    'Available Plans',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Choose the perfect plan for your calling needs',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  SizedBox(height: 3.h),

                  // Plan cards
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _plans.length,
                    separatorBuilder: (context, index) => SizedBox(height: 2.h),
                    itemBuilder: (context, index) {
                      final plan = _plans[index];
                      return PlanCardWidget(
                        plan: plan,
                        onBuyNow: () => _handleBuyNow(plan),
                      );
                    },
                  ),

                  SizedBox(height: 4.h),

                  // Payment methods section
                  PaymentMethodsWidget(
                    paymentMethods: _paymentMethods,
                  ),

                  SizedBox(height: 4.h),

                  // Terms and conditions
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'info_outline',
                              color: AppTheme.primary,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Important Information',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'All plans include local and international calling. Minutes are calculated per call duration. Unused minutes expire after validity period.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 2.h),
                        GestureDetector(
                          onTap: _showTermsAndConditions,
                          child: Row(
                            children: [
                              Text(
                                'View Terms & Conditions',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                              SizedBox(width: 1.w),
                              CustomIconWidget(
                                iconName: 'arrow_forward_ios',
                                color: AppTheme.primary,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
    );
  }
}
