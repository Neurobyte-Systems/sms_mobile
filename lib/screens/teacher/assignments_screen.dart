import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';
import 'assignment_details_screen.dart';
import 'assignment_submissions_screen.dart';
import 'assignment_edit_screen.dart';
import 'assignment_export_screen.dart';
import 'assignment_analytics_screen.dart';
import 'assignment_settings_screen.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({Key? key}) : super(key: key);

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Active', 'Overdue', 'Completed'];

  final List<Map<String, dynamic>> _assignments = [
    {
      'id': '1',
      'title': 'Algebra Quiz',
      'description': 'Practice problems on quadratic equations',
      'subject': 'Mathematics',
      'class': 'Class 10A',
      'dueDate': '2024-01-25',
      'dueTime': '11:59 PM',
      'status': 'active',
      'totalStudents': 28,
      'submitted': 15,
      'graded': 8,
      'points': 50,
      'type': 'Quiz',
      'priority': 'high',
      'attachments': 2,
      'createdDate': '2024-01-20',
    },
    {
      'id': '2',
      'title': 'Physics Lab Report',
      'description': 'Write a detailed report on the pendulum experiment',
      'subject': 'Physics',
      'class': 'Class 10B',
      'dueDate': '2024-01-28',
      'dueTime': '2:00 PM',
      'status': 'active',
      'totalStudents': 25,
      'submitted': 20,
      'graded': 12,
      'points': 100,
      'type': 'Report',
      'priority': 'medium',
      'attachments': 3,
      'createdDate': '2024-01-18',
    },
    {
      'id': '3',
      'title': 'Chemistry Homework',
      'description': 'Complete exercises 1-20 from chapter 5',
      'subject': 'Chemistry',
      'class': 'Class 11A',
      'dueDate': '2024-01-22',
      'dueTime': '9:00 AM',
      'status': 'overdue',
      'totalStudents': 30,
      'submitted': 25,
      'graded': 25,
      'points': 25,
      'type': 'Homework',
      'priority': 'low',
      'attachments': 1,
      'createdDate': '2024-01-15',
    },
    {
      'id': '4',
      'title': 'Math Project',
      'description': 'Statistical analysis of real-world data',
      'subject': 'Advanced Mathematics',
      'class': 'Class 12A',
      'dueDate': '2024-02-05',
      'dueTime': '3:00 PM',
      'status': 'active',
      'totalStudents': 20,
      'submitted': 5,
      'graded': 0,
      'points': 200,
      'type': 'Project',
      'priority': 'high',
      'attachments': 5,
      'createdDate': '2024-01-10',
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

  List<Map<String, dynamic>> get _filteredAssignments {
    if (_selectedFilter == 'All') return _assignments;
    return _assignments
        .where((a) => a['status'] == _selectedFilter.toLowerCase())
        .toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return AppTheme.primaryColor;
      case 'overdue':
        return AppTheme.errorColor;
      case 'completed':
        return AppTheme.successColor;
      default:
        return Colors.grey;
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
                  // Header Section
                  SliverToBoxAdapter(child: _buildHeader()),

                  // Filter Tabs and Stats
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildFilterTabs(),
                        const SizedBox(height: 16),
                        _buildStatsRow(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // Assignments List Header
                  SliverToBoxAdapter(child: _buildAssignmentsListHeader()),

                  // Assignments List
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final filteredAssignments = _filteredAssignments;
                        return TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 300 + (index * 50)),
                          tween: Tween(begin: 0.0, end: 1.0),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: Opacity(
                                opacity: value,
                                child: _buildAssignmentCard(
                                  filteredAssignments[index],
                                  index,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: _filteredAssignments.length,
                    ),
                  ),

                  // Bottom padding
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
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
        'Assignments',
        style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2D3748)),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: Color(0xFF2D3748),
        ),
        onPressed: () => Navigator.pop(context),
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
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
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
                  'Assignment Management',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Create and manage student assignments',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF4A5568),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.assignment_rounded,
              color: AppTheme.primaryColor,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _selectedFilter = filter;
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
                    color: isSelected
                        ? AppTheme.primaryColor
                        : Colors.grey.shade300,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    final activeCount = _assignments.where((a) => a['status'] == 'active').length;
    final overdueCount = _assignments.where((a) => a['status'] == 'overdue').length;
    final completedCount = _assignments.where((a) => a['status'] == 'completed').length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Active',
              activeCount.toString(),
              Icons.assignment_rounded,
              AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Overdue',
              overdueCount.toString(),
              Icons.assignment_late_rounded,
              AppTheme.errorColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Completed',
              completedCount.toString(),
              Icons.assignment_turned_in_rounded,
              AppTheme.successColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Total',
              _assignments.length.toString(),
              Icons.folder_rounded,
              AppTheme.teacherColor,
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
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentsListHeader() {
    final filteredAssignments = _filteredAssignments;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(
            '${filteredAssignments.length} Assignments',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _sortAssignments,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sort_rounded,
                  size: 16,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  'Sort',
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> assignment, int index) {
    final status = assignment['status'] as String;
    final statusColor = _getStatusColor(status);
    final priority = assignment['priority'] as String;
    final priorityColor = _getPriorityColor(priority);
    final submissionRate = (assignment['submitted'] as int) / (assignment['totalStudents'] as int);

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _openAssignmentDetails(assignment),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              border: Border.all(
                color: statusColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [statusColor, statusColor.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getTypeIcon(assignment['type']),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            assignment['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${assignment['subject']} • ${assignment['class']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: priorityColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            priority.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: priorityColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Description
                Text(
                  assignment['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 16),

                // Due Date and Points
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Due: ${assignment['dueDate']} at ${assignment['dueTime']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: AppTheme.warningColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${assignment['points']} points',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.warningColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Submissions: ${assignment['submitted']}/${assignment['totalStudents']}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${(submissionRate * 100).round()}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: submissionRate,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      minHeight: 6,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Additional Info
                Row(
                  children: [
                    _buildInfoChip(
                      Icons.attachment_rounded,
                      '${assignment['attachments']} files',
                    ),
                    const SizedBox(width: 12),
                    _buildInfoChip(
                      Icons.check_circle_rounded,
                      '${assignment['graded']} graded',
                    ),
                    const Spacer(),
                    Text(
                      'Created: ${assignment['createdDate']}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _viewSubmissions(assignment),
                        icon: const Icon(Icons.visibility_rounded, size: 16),
                        label: const Text('Submissions'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: statusColor,
                          side: BorderSide(color: statusColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _editAssignment(assignment),
                        icon: const Icon(Icons.edit_rounded, size: 16),
                        label: const Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: statusColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
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

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'quiz':
        return Icons.quiz_rounded;
      case 'homework':
        return Icons.home_work_rounded;
      case 'project':
        return Icons.folder_special_rounded;
      case 'report':
        return Icons.description_rounded;
      default:
        return Icons.assignment_rounded;
    }
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _createAssignment,
      backgroundColor: AppTheme.primaryColor,
      icon: const Icon(Icons.add_rounded, color: Colors.white),
      label: const Text(
        'New Assignment',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Action Methods
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Search Assignments'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter assignment title...',
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
      builder: (context) => Container(
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
            _buildOptionItem(
              Icons.download_rounded,
              'Export Assignments',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AssignmentExportScreen(),
                  ),
                );
              },
            ),
            _buildOptionItem(
              Icons.analytics_rounded,
              'View Analytics',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AssignmentAnalyticsScreen(),
                  ),
                );
              },
            ),
            _buildOptionItem(
              Icons.settings_rounded,
              'Assignment Settings',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AssignmentSettingsScreen(),
                  ),
                );
              },
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

  void _sortAssignments() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Sort Assignments'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('By Due Date'),
              onTap: () {
                setState(() {
                  _assignments.sort(
                    (a, b) => a['dueDate'].compareTo(b['dueDate']),
                  );
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('By Title'),
              onTap: () {
                setState(() {
                  _assignments.sort(
                    (a, b) => a['title'].compareTo(b['title']),
                  );
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('By Status'),
              onTap: () {
                setState(() {
                  _assignments.sort(
                    (a, b) => a['status'].compareTo(b['status']),
                  );
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openAssignmentDetails(Map<String, dynamic> assignment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignmentDetailsScreen(assignment: assignment),
      ),
    );
  }

  void _viewSubmissions(Map<String, dynamic> assignment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignmentSubmissionsScreen(assignment: assignment),
      ),
    );
  }

  void _editAssignment(Map<String, dynamic> assignment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignmentEditScreen(assignment: assignment),
      ),
    );
  }

  void _createAssignment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AssignmentEditScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
