import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';
import 'assignment_single_grading_screen.dart';
import 'assignment_bulk_grading_screen.dart';

class AssignmentSubmissionsScreen extends StatefulWidget {
  final Map<String, dynamic> assignment;

  const AssignmentSubmissionsScreen({Key? key, required this.assignment})
      : super(key: key);

  @override
  State<AssignmentSubmissionsScreen> createState() => _AssignmentSubmissionsScreenState();
}

class _AssignmentSubmissionsScreenState extends State<AssignmentSubmissionsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Submitted', 'Graded', 'Pending'];

  // Mock student submissions data
  final List<Map<String, dynamic>> _submissions = [
    {
      'id': '1',
      'studentName': 'John Doe',
      'studentId': 'ST001',
      'submissionDate': '2024-01-24',
      'submissionTime': '10:30 AM',
      'status': 'graded',
      'grade': 85,
      'maxGrade': 100,
      'feedback': 'Good work! Clear understanding of concepts.',
      'attachments': 2,
      'submissionText': 'This is the solution to the algebra problems...',
      'lateSubmission': false,
    },
    {
      'id': '2',
      'studentName': 'Jane Smith',
      'studentId': 'ST002',
      'submissionDate': '2024-01-23',
      'submissionTime': '2:15 PM',
      'status': 'submitted',
      'grade': null,
      'maxGrade': 100,
      'feedback': null,
      'attachments': 1,
      'submissionText': 'Here are my answers to the quiz questions...',
      'lateSubmission': false,
    },
    {
      'id': '3',
      'studentName': 'Mike Johnson',
      'studentId': 'ST003',
      'submissionDate': '2024-01-25',
      'submissionTime': '11:45 PM',
      'status': 'submitted',
      'grade': null,
      'maxGrade': 100,
      'feedback': null,
      'attachments': 3,
      'submissionText': 'Late submission but completed all problems.',
      'lateSubmission': true,
    },
    {
      'id': '4',
      'studentName': 'Sarah Wilson',
      'studentId': 'ST004',
      'submissionDate': null,
      'submissionTime': null,
      'status': 'pending',
      'grade': null,
      'maxGrade': 100,
      'feedback': null,
      'attachments': 0,
      'submissionText': null,
      'lateSubmission': false,
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

  List<Map<String, dynamic>> get _filteredSubmissions {
    if (_selectedFilter == 'All') return _submissions;
    return _submissions
        .where((s) => s['status'] == _selectedFilter.toLowerCase())
        .toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'graded':
        return AppTheme.successColor;
      case 'submitted':
        return AppTheme.warningColor;
      case 'pending':
        return AppTheme.errorColor;
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
                        _buildStatsSection(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // Submissions List Header
                  SliverToBoxAdapter(child: _buildSubmissionsListHeader()),

                  // Submissions List
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final filteredSubmissions = _filteredSubmissions;
                        return TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 300 + (index * 50)),
                          tween: Tween(begin: 0.0, end: 1.0),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: Opacity(
                                opacity: value,
                                child: _buildSubmissionCard(
                                  filteredSubmissions[index],
                                  index,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: _filteredSubmissions.length,
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
        'Submissions',
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
          icon: const Icon(Icons.download_rounded, color: Color(0xFF2D3748)),
          onPressed: _exportSubmissions,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.assignment['title'],
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.assignment['subject']} • ${widget.assignment['class']}',
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
                  Icons.assignment_turned_in_rounded,
                  color: AppTheme.primaryColor,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                color: Colors.grey.shade600,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Due: ${widget.assignment['dueDate']} at ${widget.assignment['dueTime']}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '${widget.assignment['points']} points',
                style: TextStyle(
                  color: AppTheme.warningColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
            final count = filter == 'All' 
                ? _submissions.length 
                : _submissions.where((s) => s['status'] == filter.toLowerCase()).length;
            
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? Colors.white.withOpacity(0.2) 
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    final submittedCount = _submissions.where((s) => s['status'] == 'submitted').length;
    final gradedCount = _submissions.where((s) => s['status'] == 'graded').length;
    final pendingCount = _submissions.where((s) => s['status'] == 'pending').length;
    final averageGrade = _submissions
        .where((s) => s['grade'] != null)
        .fold(0.0, (sum, s) => sum + s['grade']) / 
        _submissions.where((s) => s['grade'] != null).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Submitted',
              submittedCount.toString(),
              Icons.assignment_turned_in_rounded,
              AppTheme.warningColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Graded',
              gradedCount.toString(),
              Icons.grade_rounded,
              AppTheme.successColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Pending',
              pendingCount.toString(),
              Icons.pending_rounded,
              AppTheme.errorColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Average',
              averageGrade.isNaN ? 'N/A' : '${averageGrade.round()}%',
              Icons.trending_up_rounded,
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

  Widget _buildSubmissionsListHeader() {
    final filteredSubmissions = _filteredSubmissions;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(
            '${filteredSubmissions.length} Submissions',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _sortSubmissions,
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

  Widget _buildSubmissionCard(Map<String, dynamic> submission, int index) {
    final status = submission['status'] as String;
    final statusColor = _getStatusColor(status);
    final isLate = submission['lateSubmission'] as bool;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _viewSubmissionDetails(submission),
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
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          submission['studentName']
                              .split(' ')
                              .map((n) => n[0])
                              .join(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                            fontSize: 16,
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
                            submission['studentName'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ID: ${submission['studentId']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                        if (isLate) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.errorColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'LATE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.errorColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Submission Details
                if (submission['submissionDate'] != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Submitted: ${submission['submissionDate']} at ${submission['submissionTime']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                // Grade Display
                if (submission['grade'] != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.grade_rounded,
                        size: 16,
                        color: AppTheme.warningColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Grade: ${submission['grade']}/${submission['maxGrade']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.warningColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${((submission['grade'] / submission['maxGrade']) * 100).round()}%',
                        style: TextStyle(
                          fontSize: 14,
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                // Submission Text Preview
                if (submission['submissionText'] != null) ...[
                  Text(
                    submission['submissionText'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                ],

                // Attachments and Actions
                Row(
                  children: [
                    if (submission['attachments'] > 0) ...[
                      Icon(
                        Icons.attachment_rounded,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${submission['attachments']} files',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (status == 'submitted') ...[
                      TextButton(
                        onPressed: () => _gradeSubmission(submission),
                        child: const Text('Grade'),
                      ),
                    ] else if (status == 'graded') ...[
                      TextButton(
                        onPressed: () => _viewFeedback(submission),
                        child: const Text('View Feedback'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _gradeAllSubmissions,
      backgroundColor: AppTheme.primaryColor,
      icon: const Icon(Icons.grade_rounded, color: Colors.white),
      label: const Text(
        'Grade All',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Action Methods
  void _sortSubmissions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Sort Submissions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('By Student Name'),
              onTap: () {
                setState(() {
                  _submissions.sort(
                    (a, b) => a['studentName'].compareTo(b['studentName']),
                  );
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('By Submission Date'),
              onTap: () {
                setState(() {
                  _submissions.sort((a, b) {
                    if (a['submissionDate'] == null) return 1;
                    if (b['submissionDate'] == null) return -1;
                    return a['submissionDate'].compareTo(b['submissionDate']);
                  });
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('By Grade'),
              onTap: () {
                setState(() {
                  _submissions.sort((a, b) {
                    if (a['grade'] == null) return 1;
                    if (b['grade'] == null) return -1;
                    return b['grade'].compareTo(a['grade']);
                  });
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _viewSubmissionDetails(Map<String, dynamic> submission) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
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
                Text(
                  submission['studentName'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (submission['submissionText'] != null) ...[
                          const Text(
                            'Submission:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            submission['submissionText'],
                            style: const TextStyle(fontSize: 14, height: 1.5),
                          ),
                          const SizedBox(height: 20),
                        ],
                        if (submission['feedback'] != null) ...[
                          const Text(
                            'Feedback:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            submission['feedback'],
                            style: const TextStyle(fontSize: 14, height: 1.5),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _gradeSubmission(Map<String, dynamic> submission) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignmentSingleGradingScreen(
          assignment: widget.assignment,
          submission: submission,
        ),
      ),
    );
    
    if (result != null) {
      setState(() {
        submission['grade'] = result['grade'];
        submission['feedback'] = result['feedback'];
        submission['status'] = 'graded';
      });
    }
  }

  void _viewFeedback(Map<String, dynamic> submission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Feedback for ${submission['studentName']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Grade: ${submission['grade']}/${submission['maxGrade']}'),
            const SizedBox(height: 16),
            const Text(
              'Feedback:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(submission['feedback'] ?? 'No feedback provided'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _gradeAllSubmissions() async {
    final ungraded = _submissions.where((s) => s['status'] == 'submitted').toList();
    
    if (ungraded.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No submissions to grade'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignmentBulkGradingScreen(
          assignment: widget.assignment,
          submissions: _submissions,
        ),
      ),
    );
  }

  void _exportSubmissions() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting submissions...'),
        backgroundColor: AppTheme.primaryColor,
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
            _buildOptionItem(Icons.download_rounded, 'Export All Submissions', () {}),
            _buildOptionItem(Icons.email_rounded, 'Send Reminders', () {}),
            _buildOptionItem(Icons.analytics_rounded, 'View Analytics', () {}),
            _buildOptionItem(Icons.settings_rounded, 'Grading Settings', () {}),
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
} 