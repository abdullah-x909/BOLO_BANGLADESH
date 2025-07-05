import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/contacts_widget.dart';
import './widgets/dialpad_widget.dart';
import './widgets/phone_input_widget.dart';

class MainDialer extends StatefulWidget {
  const MainDialer({Key? key}) : super(key: key);

  @override
  State<MainDialer> createState() => _MainDialerState();
}

class _MainDialerState extends State<MainDialer> with TickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  int _currentIndex = 0;
  late TabController _tabController;
  bool _isDarkMode = false;

  // Mock data for available minutes
  final String _availableMinutes = "45";
  final String _callerID = "+880 1712-345678";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onDialpadPressed(String digit) {
    HapticFeedback.lightImpact();
    setState(() {
      _phoneController.text += digit;
    });
  }

  void _onBackspacePressed() {
    HapticFeedback.lightImpact();
    if (_phoneController.text.isNotEmpty) {
      setState(() {
        _phoneController.text = _phoneController.text
            .substring(0, _phoneController.text.length - 1);
      });
    }
  }

  void _onCallPressed() {
    if (_phoneController.text.isNotEmpty) {
      HapticFeedback.mediumImpact();
      _showCallDialog();
    }
  }

  void _showCallDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Calling...',
            style: _isDarkMode
                ? AppTheme.darkTheme.textTheme.titleLarge
                : AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: _isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
              ),
              SizedBox(height: 2.h),
              Text(
                _phoneController.text,
                style: AppTheme.getMonospaceStyle(
                  isLight: !_isDarkMode,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Connecting via VoIP...',
                style: _isDarkMode
                    ? AppTheme.darkTheme.textTheme.bodySmall
                    : AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: _isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onContactTap(String number) {
    setState(() {
      _phoneController.text = number;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Header with branding and available minutes
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: _isDarkMode ? AppTheme.cardDark : AppTheme.cardLight,
                  boxShadow: [
                    BoxShadow(
                      color: _isDarkMode
                          ? AppTheme.shadowColorDark
                          : AppTheme.shadowColor,
                      offset: Offset(0, 2),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FreeCallX BD',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: _isDarkMode
                                ? AppTheme.primaryLight
                                : AppTheme.primary,
                          ),
                        ),
                        Text(
                          'Caller ID: $_callerID',
                          style: AppTheme.getMonospaceStyle(
                            isLight: !_isDarkMode,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$_availableMinutes min',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.success,
                          ),
                        ),
                        GestureDetector(
                          onTap: _toggleTheme,
                          child: Container(
                            padding: EdgeInsets.all(1.w),
                            decoration: BoxDecoration(
                              color: _isDarkMode
                                  ? AppTheme.primaryLight
                                  : AppTheme.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: CustomIconWidget(
                              iconName:
                                  _isDarkMode ? 'light_mode' : 'dark_mode',
                              color: _isDarkMode
                                  ? AppTheme.textPrimary
                                  : AppTheme.surface,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      children: [
                        // Phone input field
                        PhoneInputWidget(
                          controller: _phoneController,
                          isDarkMode: _isDarkMode,
                          onBackspacePressed: _onBackspacePressed,
                        ),

                        SizedBox(height: 3.h),

                        // Dialpad
                        DialpadWidget(
                          onDigitPressed: _onDialpadPressed,
                          isDarkMode: _isDarkMode,
                        ),

                        SizedBox(height: 3.h),

                        // Call button
                        Container(
                          width: 15.w,
                          height: 15.w,
                          decoration: BoxDecoration(
                            color: _phoneController.text.isNotEmpty
                                ? AppTheme.success
                                : AppTheme.success.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                            boxShadow: _phoneController.text.isNotEmpty
                                ? [
                                    BoxShadow(
                                      color: AppTheme.success
                                          .withValues(alpha: 0.3),
                                      offset: Offset(0, 4),
                                      blurRadius: 8.0,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15.w),
                              onTap: _phoneController.text.isNotEmpty
                                  ? _onCallPressed
                                  : null,
                              child: Center(
                                child: CustomIconWidget(
                                  iconName: 'call',
                                  color: AppTheme.surface,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // Contacts section
                        ContactsWidget(
                          isDarkMode: _isDarkMode,
                          onContactTap: _onContactTap,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bottom navigation
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            switch (index) {
              case 0:
                // Already on Dialer
                break;
              case 1:
                Navigator.pushNamed(context, '/call-history');
                break;
              case 2:
                Navigator.pushNamed(context, '/account-dashboard');
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'dialpad',
                color: _currentIndex == 0
                    ? (_isDarkMode ? AppTheme.primaryLight : AppTheme.primary)
                    : (_isDarkMode
                        ? AppTheme.textMediumEmphasisDark
                        : AppTheme.textSecondary),
                size: 24,
              ),
              label: 'Dialer',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'history',
                color: _currentIndex == 1
                    ? (_isDarkMode ? AppTheme.primaryLight : AppTheme.primary)
                    : (_isDarkMode
                        ? AppTheme.textMediumEmphasisDark
                        : AppTheme.textSecondary),
                size: 24,
              ),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'account_circle',
                color: _currentIndex == 2
                    ? (_isDarkMode ? AppTheme.primaryLight : AppTheme.primary)
                    : (_isDarkMode
                        ? AppTheme.textMediumEmphasisDark
                        : AppTheme.textSecondary),
                size: 24,
              ),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
