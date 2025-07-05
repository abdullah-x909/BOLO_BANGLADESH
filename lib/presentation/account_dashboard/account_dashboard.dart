import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/account_details_widget.dart';
import './widgets/account_settings_widget.dart';
import './widgets/theme_toggle_widget.dart';
import './widgets/top_up_plans_widget.dart';
import './widgets/user_info_card_widget.dart';

class AccountDashboard extends StatefulWidget {
  const AccountDashboard({Key? key}) : super(key: key);

  @override
  State<AccountDashboard> createState() => _AccountDashboardState();
}

class _AccountDashboardState extends State<AccountDashboard> {
  bool _isDarkMode = false;
  bool _isRefreshing = false;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "userId": "BD001",
    "callerID": "+8801712345678",
    "availableMinutes": 125,
    "currentPlan": "Popular",
    "planExpiry": "2024-02-15",
    "profileImage":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    "userName": "আহমেদ হাসান",
    "joinDate": "2023-08-15",
    "totalCalls": 89,
    "totalSpent": 850.0
  };

  final List<Map<String, dynamic>> _topUpPlans = [
    {
      "id": 1,
      "name": "Starter",
      "price": 30.0,
      "minutes": 45,
      "currency": "৳",
      "isPopular": false,
      "features": ["Local calls", "Basic support", "30 days validity"]
    },
    {
      "id": 2,
      "name": "Popular",
      "price": 100.0,
      "minutes": 180,
      "currency": "৳",
      "isPopular": true,
      "features": [
        "Local & International",
        "Priority support",
        "60 days validity",
        "Free SMS"
      ]
    },
    {
      "id": 3,
      "name": "VIP",
      "price": 299.0,
      "minutes": 600,
      "currency": "৳",
      "isPopular": false,
      "features": [
        "Unlimited local",
        "24/7 support",
        "90 days validity",
        "Free SMS & Data"
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? AppTheme.surfaceDark : AppTheme.secondary,
      appBar: AppBar(
        title: Text(
          'অ্যাকাউন্ট',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: _isDarkMode ? AppTheme.surface : AppTheme.surface,
          ),
        ),
        backgroundColor: _isDarkMode ? AppTheme.surfaceDark : AppTheme.primary,
        elevation: 2.0,
        actions: [
          IconButton(
            onPressed: () => _showProfileEditDialog(),
            icon: CustomIconWidget(
              iconName: 'edit',
              color: _isDarkMode ? AppTheme.surface : AppTheme.surface,
              size: 24,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: _isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info Card
              UserInfoCardWidget(
                userData: _userData,
                isDarkMode: _isDarkMode,
              ),

              SizedBox(height: 3.h),

              // Account Details
              AccountDetailsWidget(
                userData: _userData,
                isDarkMode: _isDarkMode,
              ),

              SizedBox(height: 3.h),

              // Theme Toggle
              ThemeToggleWidget(
                isDarkMode: _isDarkMode,
                onToggle: _toggleTheme,
              ),

              SizedBox(height: 3.h),

              // Top-up Plans Section
              Text(
                'টপ-আপ প্ল্যান',
                style: (_isDarkMode
                        ? AppTheme.darkTheme.textTheme.headlineSmall
                        : AppTheme.lightTheme.textTheme.headlineSmall)
                    ?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 2.h),

              TopUpPlansWidget(
                plans: _topUpPlans,
                isDarkMode: _isDarkMode,
                onBuyNow: _handleBuyNow,
              ),

              SizedBox(height: 3.h),

              // Account Settings
              AccountSettingsWidget(
                isDarkMode: _isDarkMode,
                onSettingTap: _handleSettingTap,
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      // Update mock data
      _userData["availableMinutes"] =
          (_userData["availableMinutes"] as int) + 5;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'অ্যাকাউন্ট তথ্য আপডেট হয়েছে',
          style: TextStyle(
            color: _isDarkMode ? AppTheme.textPrimary : AppTheme.surface,
          ),
        ),
        backgroundColor: _isDarkMode ? AppTheme.surface : AppTheme.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isDarkMode
              ? 'ডার্ক মোড চালু করা হয়েছে'
              : 'লাইট মোড চালু করা হয়েছে',
          style: TextStyle(
            color: _isDarkMode ? AppTheme.textPrimary : AppTheme.surface,
          ),
        ),
        backgroundColor: _isDarkMode ? AppTheme.surface : AppTheme.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleBuyNow(Map<String, dynamic> plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            _isDarkMode ? AppTheme.dialogDark : AppTheme.dialogLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: Text(
          'পেমেন্ট',
          style: (_isDarkMode
                  ? AppTheme.darkTheme.textTheme.titleLarge
                  : AppTheme.lightTheme.textTheme.titleLarge)
              ?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${plan["name"]} প্ল্যান',
              style: (_isDarkMode
                      ? AppTheme.darkTheme.textTheme.titleMedium
                      : AppTheme.lightTheme.textTheme.titleMedium)
                  ?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'মূল্য: ${plan["currency"]}${plan["price"].toStringAsFixed(0)}',
              style: _isDarkMode
                  ? AppTheme.darkTheme.textTheme.bodyLarge
                  : AppTheme.lightTheme.textTheme.bodyLarge,
            ),
            Text(
              'মিনিট: ${plan["minutes"]}',
              style: _isDarkMode
                  ? AppTheme.darkTheme.textTheme.bodyLarge
                  : AppTheme.lightTheme.textTheme.bodyLarge,
            ),
            SizedBox(height: 2.h),
            Text(
              'bKash পেমেন্ট শীঘ্রই আসছে!',
              style: (_isDarkMode
                      ? AppTheme.darkTheme.textTheme.bodyMedium
                      : AppTheme.lightTheme.textTheme.bodyMedium)
                  ?.copyWith(
                color: _isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'বন্ধ করুন',
              style: TextStyle(
                color: _isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSettingTap(String setting) {
    switch (setting) {
      case 'profile':
        _showProfileEditDialog();
        break;
      case 'payment_history':
        _showPaymentHistory();
        break;
      case 'help_support':
        _showHelpSupport();
        break;
      case 'privacy_policy':
        _showPrivacyPolicy();
        break;
      case 'logout':
        _showLogoutDialog();
        break;
    }
  }

  void _showProfileEditDialog() {
    final TextEditingController callerIdController =
        TextEditingController(text: _userData["callerID"]);
    final TextEditingController nameController =
        TextEditingController(text: _userData["userName"]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            _isDarkMode ? AppTheme.dialogDark : AppTheme.dialogLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: Text(
          'প্রোফাইল সম্পাদনা',
          style: (_isDarkMode
                  ? AppTheme.darkTheme.textTheme.titleLarge
                  : AppTheme.lightTheme.textTheme.titleLarge)
              ?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'নাম',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: callerIdController,
              decoration: InputDecoration(
                labelText: 'কলার আইডি',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'বাতিল',
              style: TextStyle(
                color: _isDarkMode
                    ? AppTheme.textMediumEmphasisDark
                    : AppTheme.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userData["userName"] = nameController.text;
                _userData["callerID"] = callerIdController.text;
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'প্রোফাইল আপডেট হয়েছে',
                    style: TextStyle(
                      color:
                          _isDarkMode ? AppTheme.textPrimary : AppTheme.surface,
                    ),
                  ),
                  backgroundColor:
                      _isDarkMode ? AppTheme.surface : AppTheme.textPrimary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
              foregroundColor:
                  _isDarkMode ? AppTheme.textPrimary : AppTheme.surface,
            ),
            child: const Text('সংরক্ষণ'),
          ),
        ],
      ),
    );
  }

  void _showPaymentHistory() {
    final List<Map<String, dynamic>> paymentHistory = [
      {
        "date": "2024-01-15",
        "amount": 100.0,
        "plan": "Popular",
        "method": "bKash",
        "status": "সফল"
      },
      {
        "date": "2023-12-20",
        "amount": 30.0,
        "plan": "Starter",
        "method": "bKash",
        "status": "সফল"
      },
      {
        "date": "2023-11-25",
        "amount": 299.0,
        "plan": "VIP",
        "method": "bKash",
        "status": "সফল"
      },
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            _isDarkMode ? AppTheme.dialogDark : AppTheme.dialogLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: Text(
          'পেমেন্ট ইতিহাস',
          style: (_isDarkMode
                  ? AppTheme.darkTheme.textTheme.titleLarge
                  : AppTheme.lightTheme.textTheme.titleLarge)
              ?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SizedBox(
          width: 80.w,
          height: 40.h,
          child: ListView.builder(
            itemCount: paymentHistory.length,
            itemBuilder: (context, index) {
              final payment = paymentHistory[index];
              return Card(
                color: _isDarkMode ? AppTheme.cardDark : AppTheme.cardLight,
                margin: EdgeInsets.only(bottom: 1.h),
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            payment["plan"] as String,
                            style: (_isDarkMode
                                    ? AppTheme.darkTheme.textTheme.titleMedium
                                    : AppTheme.lightTheme.textTheme.titleMedium)
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '৳${(payment["amount"] as double).toStringAsFixed(0)}',
                            style: (_isDarkMode
                                    ? AppTheme.darkTheme.textTheme.titleMedium
                                    : AppTheme.lightTheme.textTheme.titleMedium)
                                ?.copyWith(
                              color: _isDarkMode
                                  ? AppTheme.primaryLight
                                  : AppTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        payment["date"] as String,
                        style: _isDarkMode
                            ? AppTheme.darkTheme.textTheme.bodySmall
                            : AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      Text(
                        '${payment["method"]} - ${payment["status"]}',
                        style: (_isDarkMode
                                ? AppTheme.darkTheme.textTheme.bodySmall
                                : AppTheme.lightTheme.textTheme.bodySmall)
                            ?.copyWith(
                          color: AppTheme.success,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'বন্ধ করুন',
              style: TextStyle(
                color: _isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            _isDarkMode ? AppTheme.dialogDark : AppTheme.dialogLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: Text(
          'সাহায্য ও সহায়তা',
          style: (_isDarkMode
                  ? AppTheme.darkTheme.textTheme.titleLarge
                  : AppTheme.lightTheme.textTheme.titleLarge)
              ?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'যোগাযোগ করুন:',
              style: (_isDarkMode
                      ? AppTheme.darkTheme.textTheme.titleMedium
                      : AppTheme.lightTheme.textTheme.titleMedium)
                  ?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'ফোন: +880-1700-000000',
              style: _isDarkMode
                  ? AppTheme.darkTheme.textTheme.bodyLarge
                  : AppTheme.lightTheme.textTheme.bodyLarge,
            ),
            Text(
              'ইমেইল: support@freecallxbd.com',
              style: _isDarkMode
                  ? AppTheme.darkTheme.textTheme.bodyLarge
                  : AppTheme.lightTheme.textTheme.bodyLarge,
            ),
            SizedBox(height: 2.h),
            Text(
              'সেবার সময়: সকাল ৯টা - রাত ৯টা',
              style: _isDarkMode
                  ? AppTheme.darkTheme.textTheme.bodyMedium
                  : AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'বন্ধ করুন',
              style: TextStyle(
                color: _isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            _isDarkMode ? AppTheme.dialogDark : AppTheme.dialogLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: Text(
          'গোপনীয়তা নীতি',
          style: (_isDarkMode
                  ? AppTheme.darkTheme.textTheme.titleLarge
                  : AppTheme.lightTheme.textTheme.titleLarge)
              ?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SizedBox(
          width: 80.w,
          height: 40.h,
          child: SingleChildScrollView(
            child: Text(
              '''আমরা আপনার ব্যক্তিগত তথ্যের গোপনীয়তা রক্ষায় প্রতিশ্রুতিবদ্ধ।

১. তথ্য সংগ্রহ:
আমরা শুধুমাত্র প্রয়োজনীয় তথ্য সংগ্রহ করি।

২. তথ্য ব্যবহার:
আপনার তথ্য শুধুমাত্র সেবা প্রদানের জন্য ব্যবহৃত হয়।

৩. তথ্য সুরক্ষা:
আমরা আপনার তথ্য সুরক্ষিত রাখতে সর্বোচ্চ চেষ্টা করি।

৪. তৃতীয় পক্ষ:
আমরা আপনার অনুমতি ছাড়া তৃতীয় পক্ষের সাথে তথ্য শেয়ার করি না।''',
              style: _isDarkMode
                  ? AppTheme.darkTheme.textTheme.bodyMedium
                  : AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'বন্ধ করুন',
              style: TextStyle(
                color: _isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            _isDarkMode ? AppTheme.dialogDark : AppTheme.dialogLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: Text(
          'লগ আউট',
          style: (_isDarkMode
                  ? AppTheme.darkTheme.textTheme.titleLarge
                  : AppTheme.lightTheme.textTheme.titleLarge)
              ?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'আপনি কি নিশ্চিত যে আপনি লগ আউট করতে চান?',
          style: _isDarkMode
              ? AppTheme.darkTheme.textTheme.bodyLarge
              : AppTheme.lightTheme.textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'বাতিল',
              style: TextStyle(
                color: _isDarkMode
                    ? AppTheme.textMediumEmphasisDark
                    : AppTheme.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/splash-screen',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: AppTheme.surface,
            ),
            child: const Text('লগ আউট'),
          ),
        ],
      ),
    );
  }
}
