import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContactsWidget extends StatefulWidget {
  final bool isDarkMode;
  final Function(String) onContactTap;

  const ContactsWidget({
    Key? key,
    required this.isDarkMode,
    required this.onContactTap,
  }) : super(key: key);

  @override
  State<ContactsWidget> createState() => _ContactsWidgetState();
}

class _ContactsWidgetState extends State<ContactsWidget> {
  bool _hasPermission = false;
  bool _isLoading = true;
  bool _permissionRequested = false;

  // Mock contacts data
  final List<Map<String, dynamic>> _contacts = [
    {
      "id": 1,
      "name": "আহমেদ সাহেব",
      "phone": "+880 1712-345678",
      "initial": "আ",
      "isFavorite": true,
    },
    {
      "id": 2,
      "name": "রহিমা খাতুন",
      "phone": "+880 1987-654321",
      "initial": "র",
      "isFavorite": false,
    },
    {
      "id": 3,
      "name": "করিম ভাই",
      "phone": "+880 1555-123456",
      "initial": "ক",
      "isFavorite": true,
    },
    {
      "id": 4,
      "name": "John Smith",
      "phone": "+1-555-987-6543",
      "initial": "J",
      "isFavorite": false,
    },
    {
      "id": 5,
      "name": "সালমা আপা",
      "phone": "+880 1333-789012",
      "initial": "স",
      "isFavorite": false,
    },
    {
      "id": 6,
      "name": "রাফি ভাই",
      "phone": "+880 1444-567890",
      "initial": "রা",
      "isFavorite": true,
    },
    {
      "id": 7,
      "name": "নাসির উদ্দিন",
      "phone": "+880 1666-234567",
      "initial": "ন",
      "isFavorite": false,
    },
  ];

  List<Map<String, dynamic>> _filteredContacts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredContacts = _contacts;
    _requestContactsPermission();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _requestContactsPermission() async {
    if (_permissionRequested) return;

    setState(() {
      _isLoading = true;
      _permissionRequested = true;
    });

    // Simulate permission request
    await Future.delayed(const Duration(milliseconds: 2000));

    if (mounted) {
      setState(() {
        _hasPermission = true;
        _isLoading = false;
      });
    }
  }

  void _filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = _contacts;
      } else {
        _filteredContacts = _contacts.where((contact) {
          final name = contact["name"] as String;
          final phone = contact["phone"] as String;
          return name.toLowerCase().contains(query.toLowerCase()) ||
              phone.contains(query);
        }).toList();
      }
    });
  }

  void _toggleFavorite(int contactId) {
    setState(() {
      final contactIndex =
          _contacts.indexWhere((contact) => contact["id"] == contactId);
      if (contactIndex != -1) {
        _contacts[contactIndex]["isFavorite"] =
            !_contacts[contactIndex]["isFavorite"];
        _filterContacts(_searchController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (!_hasPermission) {
      return _buildPermissionDeniedState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Contacts',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: widget.isDarkMode
                      ? AppTheme.textHighEmphasisDark
                      : AppTheme.textHighEmphasisLight,
                ),
              ),
              Text(
                'যোগাযোগ',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: widget.isDarkMode
                      ? AppTheme.textMediumEmphasisDark
                      : AppTheme.textMediumEmphasisLight,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 2.h),

        // Search bar
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: TextField(
            controller: _searchController,
            onChanged: _filterContacts,
            decoration: InputDecoration(
              hintText: 'Search contacts...',
              hintStyle: TextStyle(
                color: widget.isDarkMode
                    ? AppTheme.textMediumEmphasisDark
                    : AppTheme.textMediumEmphasisLight,
              ),
              prefixIcon: CustomIconWidget(
                iconName: 'search',
                color: widget.isDarkMode
                    ? AppTheme.textMediumEmphasisDark
                    : AppTheme.textMediumEmphasisLight,
                size: 20,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: widget.isDarkMode
                            ? AppTheme.textMediumEmphasisDark
                            : AppTheme.textMediumEmphasisLight,
                        size: 20,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _filterContacts('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: widget.isDarkMode
                      ? AppTheme.borderColor.withValues(alpha: 0.3)
                      : AppTheme.borderColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: widget.isDarkMode
                      ? AppTheme.primaryLight
                      : AppTheme.primary,
                ),
              ),
              filled: true,
              fillColor:
                  widget.isDarkMode ? AppTheme.cardDark : AppTheme.cardLight,
            ),
            style: TextStyle(
              color: widget.isDarkMode
                  ? AppTheme.textHighEmphasisDark
                  : AppTheme.textHighEmphasisLight,
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Favorites quick access
        if (_contacts
            .where((contact) => contact["isFavorite"] == true)
            .isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              'Favorites',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: widget.isDarkMode
                    ? AppTheme.textMediumEmphasisDark
                    : AppTheme.textMediumEmphasisLight,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            height: 8.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              itemCount: _contacts
                  .where((contact) => contact["isFavorite"] == true)
                  .length,
              itemBuilder: (context, index) {
                final favoriteContacts = _contacts
                    .where((contact) => contact["isFavorite"] == true)
                    .toList();
                final contact = favoriteContacts[index];
                return _buildFavoriteContactChip(contact);
              },
            ),
          ),
          SizedBox(height: 2.h),
        ],

        // Contacts list
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Text(
            'All Contacts (${_filteredContacts.length})',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: widget.isDarkMode
                  ? AppTheme.textMediumEmphasisDark
                  : AppTheme.textMediumEmphasisLight,
            ),
          ),
        ),

        SizedBox(height: 1.h),

        // Contacts list view
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount:
              _filteredContacts.length > 8 ? 8 : _filteredContacts.length,
          itemBuilder: (context, index) {
            final contact = _filteredContacts[index];
            return _buildContactItem(contact);
          },
        ),

        if (_filteredContacts.length > 8) ...[
          SizedBox(height: 1.h),
          Center(
            child: Text(
              'Showing 8 of ${_filteredContacts.length} contacts',
              style: TextStyle(
                fontSize: 12.sp,
                color: widget.isDarkMode
                    ? AppTheme.textMediumEmphasisDark
                    : AppTheme.textMediumEmphasisLight,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFavoriteContactChip(Map<String, dynamic> contact) {
    return Container(
      margin: EdgeInsets.only(right: 2.w),
      child: GestureDetector(
        onTap: () => widget.onContactTap(contact["phone"] as String),
        child: Container(
          width: 16.w,
          decoration: BoxDecoration(
            color: widget.isDarkMode ? AppTheme.cardDark : AppTheme.cardLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.isDarkMode
                  ? AppTheme.borderColor.withValues(alpha: 0.3)
                  : AppTheme.borderColor,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: widget.isDarkMode
                      ? AppTheme.primaryLight
                      : AppTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    contact["initial"] as String,
                    style: TextStyle(
                      color: AppTheme.surface,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                (contact["name"] as String).length > 8
                    ? '${(contact["name"] as String).substring(0, 8)}...'
                    : contact["name"] as String,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: widget.isDarkMode
                      ? AppTheme.textHighEmphasisDark
                      : AppTheme.textHighEmphasisLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(Map<String, dynamic> contact) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => widget.onContactTap(contact["phone"] as String),
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: widget.isDarkMode ? AppTheme.cardDark : AppTheme.cardLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: widget.isDarkMode
                    ? AppTheme.borderColor.withValues(alpha: 0.3)
                    : AppTheme.borderColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Contact avatar
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: widget.isDarkMode
                        ? AppTheme.primaryLight
                        : AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      contact["initial"] as String,
                      style: TextStyle(
                        color: AppTheme.surface,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                // Contact info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact["name"] as String,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: widget.isDarkMode
                              ? AppTheme.textHighEmphasisDark
                              : AppTheme.textHighEmphasisLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        contact["phone"] as String,
                        style: AppTheme.getMonospaceStyle(
                          isLight: !widget.isDarkMode,
                          fontSize: 12.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Favorite and call buttons
                Row(
                  children: [
                    IconButton(
                      icon: CustomIconWidget(
                        iconName: contact["isFavorite"] == true
                            ? 'star'
                            : 'star_border',
                        color: contact["isFavorite"] == true
                            ? AppTheme.warning
                            : (widget.isDarkMode
                                ? AppTheme.textMediumEmphasisDark
                                : AppTheme.textMediumEmphasisLight),
                        size: 20,
                      ),
                      onPressed: () => _toggleFavorite(contact["id"] as int),
                    ),
                    IconButton(
                      icon: CustomIconWidget(
                        iconName: 'call',
                        color: AppTheme.success,
                        size: 20,
                      ),
                      onPressed: () =>
                          widget.onContactTap(contact["phone"] as String),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: widget.isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading contacts...',
            style: TextStyle(
              fontSize: 14.sp,
              color: widget.isDarkMode
                  ? AppTheme.textMediumEmphasisDark
                  : AppTheme.textMediumEmphasisLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDeniedState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'contacts',
            color: widget.isDarkMode
                ? AppTheme.textMediumEmphasisDark
                : AppTheme.textMediumEmphasisLight,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Contacts Permission Required',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: widget.isDarkMode
                  ? AppTheme.textHighEmphasisDark
                  : AppTheme.textHighEmphasisLight,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Allow access to contacts to display your contact list here.',
            style: TextStyle(
              fontSize: 14.sp,
              color: widget.isDarkMode
                  ? AppTheme.textMediumEmphasisDark
                  : AppTheme.textMediumEmphasisLight,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: _requestContactsPermission,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  widget.isDarkMode ? AppTheme.primaryLight : AppTheme.primary,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
            ),
            child: Text(
              'Grant Permission',
              style: TextStyle(
                color: AppTheme.surface,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
