import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedTab = 'All';
  final List<String> _tabs = ['All', 'Parents', 'Students', 'Teachers'];

  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'senderName': 'Mrs. Johnson',
      'senderRole': 'parent',
      'senderAvatar': null,
      'subject': 'Question about homework',
      'preview':
          'Hi, I wanted to ask about the math homework assigned yesterday...',
      'message':
          'Hi, I wanted to ask about the math homework assigned yesterday. My son John is having trouble with problem #5. Could you please provide some additional guidance?',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': false,
      'isStarred': true,
      'hasAttachment': false,
      'studentName': 'John Doe',
      'priority': 'medium',
      'category': 'academic',
    },
    {
      'id': '2',
      'senderName': 'Mike Davis',
      'senderRole': 'student',
      'senderAvatar': null,
      'subject': 'Assignment submission',
      'preview':
          'I submitted my physics lab report but I\'m not sure if it went through...',
      'message':
          'Hello, I submitted my physics lab report earlier today but I\'m not sure if it went through properly. Could you please confirm if you received it?',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'isRead': true,
      'isStarred': false,
      'hasAttachment': true,
      'studentName': 'Mike Davis',
      'priority': 'low',
      'category': 'submission',
    },
    {
      'id': '3',
      'senderName': 'Dr. Smith',
      'senderRole': 'teacher',
      'senderAvatar': null,
      'subject': 'Department meeting',
      'preview': 'Reminder about tomorrow\'s department meeting at 3 PM...',
      'message':
          'Reminder about tomorrow\'s department meeting at 3 PM in the conference room. We\'ll be discussing the new curriculum changes.',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': true,
      'isStarred': false,
      'hasAttachment': false,
      'studentName': null,
      'priority': 'high',
      'category': 'meeting',
    },
    {
      'id': '4',
      'senderName': 'Sarah Wilson',
      'senderRole': 'parent',
      'senderAvatar': null,
      'subject': 'Thank you for extra help',
      'preview':
          'I wanted to thank you for staying after class to help Emma...',
      'message':
          'I wanted to thank you for staying after class to help Emma with her chemistry problems. She came home much more confident about the upcoming test.',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'isRead': true,
      'isStarred': true,
      'hasAttachment': false,
      'studentName': 'Emma Wilson',
      'priority': 'low',
      'category': 'appreciation',
    },
    {
      'id': '5',
      'senderName': 'Alex Martinez',
      'senderRole': 'student',
      'senderAvatar': null,
      'subject': 'Class absence',
      'preview':
          'I will be absent from tomorrow\'s class due to a doctor\'s appointment...',
      'message':
          'I will be absent from tomorrow\'s class due to a doctor\'s appointment. Will there be any important announcements or assignments I should know about?',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'isRead': false,
      'isStarred': false,
      'hasAttachment': false,
      'studentName': 'Alex Martinez',
      'priority': 'medium',
      'category': 'absence',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  List<Map<String, dynamic>> get _filteredMessages {
    if (_selectedTab == 'All') return _messages;
    return _messages
        .where(
          (m) =>
              m['senderRole'] == _selectedTab.toLowerCase() ||
              (_selectedTab == 'Teachers' && m['senderRole'] == 'teacher'),
        )
        .toList();
  }

  int get _unreadCount => _messages.where((m) => !m['isRead']).length;

  Color _getRoleColor(String role) {
    switch (role) {
      case 'parent':
        return AppTheme.parentColor;
      case 'student':
        return AppTheme.studentColor;
      case 'teacher':
        return AppTheme.teacherColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return AppTheme.errorColor;
      case 'medium':
        return AppTheme.warningColor;
      case 'low':
        return AppTheme.successColor;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'academic':
        return Icons.school_rounded;
      case 'submission':
        return Icons.assignment_turned_in_rounded;
      case 'meeting':
        return Icons.meeting_room_rounded;
      case 'appreciation':
        return Icons.favorite_rounded;
      case 'absence':
        return Icons.event_busy_rounded;
      default:
        return Icons.message_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader()),
                  SliverToBoxAdapter(child: _buildTabBar()),
                  SliverToBoxAdapter(child: _buildStatsRow()),
                  SliverToBoxAdapter(child: const SizedBox(height: 16)),
                  _buildMessagesSliver(),
                  SliverToBoxAdapter(child: const SizedBox(height: 100)),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text(
        'Messages',
        style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2D3748)),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: Color(0xFF2D3748),
        ),
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: Color(0xFF2D3748)),
          onPressed: _showSearchDialog,
        ),
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF2D3748)),
          onPressed: _showMoreOptions,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor.withOpacity(0.1), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Message Center',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Communicate with parents and students',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF4A5568),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Icon(
                  Icons.message_rounded,
                  color: AppTheme.primaryColor,
                  size: 32,
                ),
                if (_unreadCount > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              _tabs.map((tab) {
                final isSelected = _selectedTab == tab;
                final count =
                    tab == 'All'
                        ? _messages.length
                        : _messages
                            .where(
                              (m) =>
                                  m['senderRole'] == tab.toLowerCase() ||
                                  (tab == 'Teachers' &&
                                      m['senderRole'] == 'teacher'),
                            )
                            .length;

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _selectedTab = tab;
                    });
                  },
                  child: AnimatedContainer(
                    duration: AppConstants.shortAnimation,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color:
                            isSelected
                                ? AppTheme.primaryColor
                                : Colors.grey.shade300,
                      ),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                              : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tab,
                          style: TextStyle(
                            color:
                                isSelected
                                    ? Colors.white
                                    : Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (count > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Colors.white.withOpacity(0.2)
                                      : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              count.toString(),
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    final unreadCount = _filteredMessages.where((m) => !m['isRead']).length;
    final starredCount = _filteredMessages.where((m) => m['isStarred']).length;
    final todayCount =
        _filteredMessages
            .where((m) => DateTime.now().difference(m['timestamp']).inDays == 0)
            .length;

    return Container(
      margin: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Unread',
              unreadCount.toString(),
              Icons.mark_email_unread_rounded,
              AppTheme.errorColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Starred',
              starredCount.toString(),
              Icons.star_rounded,
              AppTheme.warningColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Today',
              todayCount.toString(),
              Icons.today_rounded,
              AppTheme.successColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Total',
              _filteredMessages.length.toString(),
              Icons.mail_rounded,
              AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.1),
                  color.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesSliver() {
    final filteredMessages = _filteredMessages;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            // Header row
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text(
                    '${filteredMessages.length} Messages',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _markAllAsRead,
                    child: Text(
                      'Mark All Read',
                      style: TextStyle(color: AppTheme.primaryColor),
                    ),
                  ),
                ],
              ),
            );
          }

          final messageIndex = index - 1;
          if (messageIndex >= filteredMessages.length) return null;

          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (messageIndex * 50)),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                    child: _buildMessageCard(
                      filteredMessages[messageIndex],
                      messageIndex,
                    ),
                  ),
                ),
              );
            },
          );
        },
        childCount: filteredMessages.length + 1, // +1 for header
      ),
    );
  }

  Widget _buildMessagesList() {
    final filteredMessages = _filteredMessages;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${filteredMessages.length} Messages',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _markAllAsRead,
                child: Text(
                  'Mark All Read',
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMessages.length,
              itemBuilder: (context, index) {
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 300 + (index * 50)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: _buildMessageCard(
                          filteredMessages[index],
                          index,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(Map<String, dynamic> message, int index) {
    final isRead = message['isRead'] as bool;
    final isStarred = message['isStarred'] as bool;
    final hasAttachment = message['hasAttachment'] as bool;
    final roleColor = _getRoleColor(message['senderRole']);
    final priorityColor = _getPriorityColor(message['priority']);
    final categoryIcon = _getCategoryIcon(message['category']);
    final timestamp = message['timestamp'] as DateTime;
    final timeAgo = _getTimeAgo(timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        elevation: isRead ? 1 : 4,
        borderRadius: BorderRadius.circular(20),
        shadowColor: roleColor.withOpacity(0.2),
        child: InkWell(
          onTap: () => _openMessage(message),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isRead ? Colors.white : roleColor.withOpacity(0.03),
              border: Border.all(
                color: isRead ? Colors.grey.shade200 : roleColor.withOpacity(0.2),
                width: isRead ? 1 : 2,
              ),
              gradient: !isRead ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  roleColor.withOpacity(0.02),
                  Colors.white,
                ],
              ) : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Sender Avatar
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [roleColor, roleColor.withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: roleColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          message['senderName']
                              .split(' ')
                              .map((n) => n[0])
                              .join(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Message Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  message['senderName'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        isRead
                                            ? FontWeight.w600
                                            : FontWeight.w800,
                                    color: const Color(0xFF2D3748),
                                  ),
                                ),
                              ),
                              if (hasAttachment)
                                Icon(
                                  Icons.attachment_rounded,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                              const SizedBox(width: 8),
                              Icon(
                                categoryIcon,
                                size: 16,
                                color: priorityColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: roleColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  message['senderRole'].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: roleColor,
                                  ),
                                ),
                              ),
                              if (message['studentName'] != null) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '• ${message['studentName']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Time and Actions
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          timeAgo,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _toggleStar(message),
                              child: Icon(
                                isStarred
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                size: 20,
                                color:
                                    isStarred
                                        ? AppTheme.warningColor
                                        : Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Subject
                Text(
                  message['subject'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isRead ? FontWeight.w600 : FontWeight.w800,
                    color: const Color(0xFF2D3748),
                  ),
                ),

                const SizedBox(height: 8),

                // Preview
                Text(
                  message['preview'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _replyToMessage(message),
                        icon: const Icon(Icons.reply_rounded, size: 16),
                        label: const Text('Reply'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: roleColor,
                          side: BorderSide(color: roleColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _openMessage(message),
                        icon: const Icon(Icons.open_in_new_rounded, size: 16),
                        label: const Text('Open'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: roleColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
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

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      heroTag: "messages_compose_fab",
      onPressed: _composeMessage,
      backgroundColor: AppTheme.primaryColor,
      icon: const Icon(Icons.edit_rounded, color: Colors.white),
      label: const Text(
        'Compose',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Action Methods
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Search Messages'),
            content: TextField(
              decoration: InputDecoration(
                hintText: 'Search by sender, subject, or content...',
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Search'),
              ),
            ],
          ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                _buildOptionItem(Icons.select_all_rounded, 'Select All', () {}),
                _buildOptionItem(
                  Icons.archive_rounded,
                  'Archive Messages',
                  () {},
                ),
                _buildOptionItem(
                  Icons.delete_outline_rounded,
                  'Delete Messages',
                  () {},
                ),
                _buildOptionItem(
                  Icons.settings_rounded,
                  'Message Settings',
                  () {},
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
    );
  }

  Widget _buildOptionItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var message in _messages) {
        message['isRead'] = true;
      }
    });
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All messages marked as read'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _toggleStar(Map<String, dynamic> message) {
    setState(() {
      message['isStarred'] = !message['isStarred'];
    });
    HapticFeedback.lightImpact();
  }

  void _openMessage(Map<String, dynamic> message) {
    setState(() {
      message['isRead'] = true;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageDetailsScreen(message: message),
      ),
    );
  }

  void _replyToMessage(Map<String, dynamic> message) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComposeMessageScreen(replyTo: message),
      ),
    );
  }

  void _composeMessage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ComposeMessageScreen()),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

// Message Details Screen
class MessageDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> message;

  const MessageDetailsScreen({Key? key, required this.message})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roleColor = _getRoleColor(message['senderRole']);
    final timestamp = message['timestamp'] as DateTime;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          message['senderName'],
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF2D3748),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFF2D3748),
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.reply_rounded, color: Color(0xFF2D3748)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComposeMessageScreen(replyTo: message),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF2D3748)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [roleColor.withOpacity(0.1), Colors.white],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: roleColor.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [roleColor, roleColor.withOpacity(0.8)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            message['senderName']
                                .split(' ')
                                .map((n) => n[0])
                                .join(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['senderName'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: roleColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                message['senderRole'].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: roleColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message['subject'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${timestamp.day}/${timestamp.month}/${timestamp.year} at ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  if (message['studentName'] != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.person_rounded,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Regarding: ${message['studentName']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Message Content
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                message['message'],
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Color(0xFF2D3748),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  ComposeMessageScreen(replyTo: message),
                        ),
                      );
                    },
                    icon: const Icon(Icons.reply_rounded),
                    label: const Text('Reply'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: roleColor,
                      side: BorderSide(color: roleColor),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Forward message
                    },
                    icon: const Icon(Icons.forward_rounded),
                    label: const Text('Forward'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: roleColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'parent':
        return AppTheme.parentColor;
      case 'student':
        return AppTheme.studentColor;
      case 'teacher':
        return AppTheme.teacherColor;
      default:
        return AppTheme.primaryColor;
    }
  }
}

// Compose Message Screen
class ComposeMessageScreen extends StatefulWidget {
  final Map<String, dynamic>? replyTo;

  const ComposeMessageScreen({Key? key, this.replyTo}) : super(key: key);

  @override
  State<ComposeMessageScreen> createState() => _ComposeMessageScreenState();
}

class _ComposeMessageScreenState extends State<ComposeMessageScreen> {
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String _selectedRecipientType = 'Parent';
  final List<String> _recipientTypes = ['Parent', 'Student', 'Teacher'];

  @override
  void initState() {
    super.initState();
    if (widget.replyTo != null) {
      _toController.text = widget.replyTo!['senderName'];
      _subjectController.text = 'Re: ${widget.replyTo!['subject']}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.replyTo != null ? 'Reply Message' : 'Compose Message',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF2D3748),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Color(0xFF2D3748)),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: _sendMessage,
            child: Text(
              'Send',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipient Type Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedRecipientType,
                decoration: const InputDecoration(
                  labelText: 'Recipient Type',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.person_rounded),
                ),
                items:
                    _recipientTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRecipientType = value!;
                  });
                },
              ),
            ),

            const SizedBox(height: 16),

            // To Field
            TextField(
              controller: _toController,
              decoration: InputDecoration(
                labelText: 'To',
                hintText: 'Enter recipient name or email',
                prefixIcon: const Icon(Icons.email_rounded),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Subject Field
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
                hintText: 'Enter message subject',
                prefixIcon: const Icon(Icons.subject_rounded),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Message Field
            TextField(
              controller: _messageController,
              maxLines: 8,
              decoration: InputDecoration(
                labelText: 'Message',
                hintText: 'Type your message here...',
                alignLabelWithHint: true,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Save as draft
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Message saved as draft'),
                          backgroundColor: AppTheme.primaryColor,
                        ),
                      );
                    },
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('Save Draft'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: BorderSide(color: AppTheme.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send_rounded),
                    label: const Text('Send Message'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_toController.text.isEmpty ||
        _subjectController.text.isEmpty ||
        _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message sent successfully!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  @override
  void dispose() {
    _toController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
