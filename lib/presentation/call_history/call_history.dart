import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/call_detail_dialog.dart';
import './widgets/call_filter_bottom_sheet.dart';
import './widgets/call_history_item_widget.dart';

class CallHistory extends StatefulWidget {
  const CallHistory({Key? key}) : super(key: key);

  @override
  State<CallHistory> createState() => _CallHistoryState();
}

class _CallHistoryState extends State<CallHistory>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = false;
  bool _isSearching = false;
  bool _isMultiSelectMode = false;
  String _currentFilter = 'All Calls';
  List<String> _selectedCallIds = [];
  List<Map<String, dynamic>> _filteredCalls = [];

  // Mock call history data
  final List<Map<String, dynamic>> _callHistory = [
    {
      "id": "1",
      "contactName": "আহমেদ হাসান",
      "phoneNumber": "+8801712345678",
      "callType": "missed",
      "duration": "0:00",
      "timestamp": DateTime.now().subtract(Duration(minutes: 15)),
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
    {
      "id": "2",
      "contactName": "রহিমা খাতুন",
      "phoneNumber": "+8801987654321",
      "callType": "outgoing",
      "duration": "5:32",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
    {
      "id": "3",
      "contactName": "করিম উদ্দিন",
      "phoneNumber": "+8801555666777",
      "callType": "incoming",
      "duration": "12:45",
      "timestamp": DateTime.now().subtract(Duration(hours: 5)),
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
    {
      "id": "4",
      "contactName": "ফাতেমা বেগম",
      "phoneNumber": "+8801444555666",
      "callType": "missed",
      "duration": "0:00",
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
    {
      "id": "5",
      "contactName": "নাসির আহমেদ",
      "phoneNumber": "+8801333444555",
      "callType": "outgoing",
      "duration": "8:21",
      "timestamp": DateTime.now().subtract(Duration(days: 1, hours: 3)),
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
    {
      "id": "6",
      "contactName": "সালমা খান",
      "phoneNumber": "+8801222333444",
      "callType": "incoming",
      "duration": "3:15",
      "timestamp": DateTime.now().subtract(Duration(days: 2)),
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
    {
      "id": "7",
      "contactName": "রফিক মিয়া",
      "phoneNumber": "+8801111222333",
      "callType": "missed",
      "duration": "0:00",
      "timestamp": DateTime.now().subtract(Duration(days: 3)),
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
    {
      "id": "8",
      "contactName": "নার্গিস আক্তার",
      "phoneNumber": "+8801999888777",
      "callType": "outgoing",
      "duration": "15:30",
      "timestamp": DateTime.now().subtract(Duration(days: 4)),
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredCalls = List.from(_callHistory);
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreCalls();
    }
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
      _filterCalls();
    });
  }

  void _filterCalls() {
    List<Map<String, dynamic>> filtered = List.from(_callHistory);

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((call) {
        final name = (call["contactName"] as String).toLowerCase();
        final number = (call["phoneNumber"] as String).toLowerCase();
        final query = _searchController.text.toLowerCase();
        return name.contains(query) || number.contains(query);
      }).toList();
    }

    // Apply call type filter
    if (_currentFilter != 'All Calls') {
      filtered = filtered.where((call) {
        switch (_currentFilter) {
          case 'Missed':
            return call["callType"] == "missed";
          case 'Outgoing':
            return call["callType"] == "outgoing";
          case 'Incoming':
            return call["callType"] == "incoming";
          default:
            return true;
        }
      }).toList();
    }

    setState(() {
      _filteredCalls = filtered;
    });
  }

  void _loadMoreCalls() {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CallFilterBottomSheet(
        currentFilter: _currentFilter,
        onFilterChanged: (filter) {
          setState(() {
            _currentFilter = filter;
            _filterCalls();
          });
        },
      ),
    );
  }

  void _toggleMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedCallIds.clear();
      }
    });
  }

  void _toggleCallSelection(String callId) {
    setState(() {
      if (_selectedCallIds.contains(callId)) {
        _selectedCallIds.remove(callId);
      } else {
        _selectedCallIds.add(callId);
      }
    });
  }

  void _deleteSelectedCalls() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Calls'),
        content: Text(
            'Are you sure you want to delete ${_selectedCallIds.length} selected calls?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _callHistory.removeWhere(
                    (call) => _selectedCallIds.contains(call["id"]));
                _filterCalls();
                _selectedCallIds.clear();
                _isMultiSelectMode = false;
              });
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showCallDetail(Map<String, dynamic> call) {
    showDialog(
      context: context,
      builder: (context) => CallDetailDialog(call: call),
    );
  }

  void _makeCall(String phoneNumber) {
    // Navigate to main dialer with pre-filled number
    Navigator.pushNamed(context, '/main-dialer');
  }

  Future<void> _refreshCalls() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _filterCalls();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child:
                _filteredCalls.isEmpty ? _buildEmptyState() : _buildCallList(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        _isMultiSelectMode
            ? '${_selectedCallIds.length} Selected'
            : 'Call History',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      leading: _isMultiSelectMode
          ? IconButton(
              onPressed: _toggleMultiSelectMode,
              icon: CustomIconWidget(
                iconName: 'close',
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
            )
          : null,
      actions: [
        if (_isMultiSelectMode) ...[
          IconButton(
            onPressed:
                _selectedCallIds.isNotEmpty ? _deleteSelectedCalls : null,
            icon: CustomIconWidget(
              iconName: 'delete',
              color: _selectedCallIds.isNotEmpty
                  ? AppTheme.error
                  : Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
              size: 24,
            ),
          ),
        ] else ...[
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(4.w),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search calls...',
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
              size: 20,
            ),
          ),
          suffixIcon: _isSearching
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                  },
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                    size: 20,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildCallList() {
    return RefreshIndicator(
      onRefresh: _refreshCalls,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: _filteredCalls.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _filteredCalls.length) {
            return _buildLoadingIndicator();
          }

          final call = _filteredCalls[index];
          final isSelected = _selectedCallIds.contains(call["id"]);

          return CallHistoryItemWidget(
            call: call,
            isMultiSelectMode: _isMultiSelectMode,
            isSelected: isSelected,
            onTap: () {
              if (_isMultiSelectMode) {
                _toggleCallSelection(call["id"]);
              } else {
                _showCallDetail(call);
              }
            },
            onLongPress: () {
              if (!_isMultiSelectMode) {
                _toggleMultiSelectMode();
                _toggleCallSelection(call["id"]);
              }
            },
            onCallBack: () => _makeCall(call["phoneNumber"]),
            onDelete: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Call'),
                  content: Text('Are you sure you want to delete this call?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _callHistory
                              .removeWhere((c) => c["id"] == call["id"]);
                          _filterCalls();
                        });
                        Navigator.pop(context);
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Center(
        child: CircularProgressIndicator(
          color: AppTheme.primary,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'call',
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            size: 80,
          ),
          SizedBox(height: 3.h),
          Text(
            'No calls yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Your call history will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                ),
          ),
          SizedBox(height: 4.h),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/main-dialer'),
            child: Text('Make your first call'),
          ),
        ],
      ),
    );
  }
}
