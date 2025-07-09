import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class StudentAssignmentsScreen extends StatefulWidget {
  const StudentAssignmentsScreen({Key? key}) : super(key: key);

  @override
  State<StudentAssignmentsScreen> createState() => _StudentAssignmentsScreenState();
}

class _StudentAssignmentsScreenState extends State<StudentAssignmentsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedFilter = 'All';
  String _selectedSort = 'Due Date';
  bool _showCompleted = true;

  final List<String> _filterOptions = ['All', 'Pending', 'In Progress', 'Submitted', 'Overdue'];
  final List<String> _sortOptions = ['Due Date', 'Subject', 'Priority', 'Progress'];

  final List<Map<String, dynamic>> _assignments = [
    {
      'id': '1',
      'title': 'Calculus Problem Set',
      'subject': 'Mathematics',
      'description': 'Complete problems 1-25 from Chapter 8',
      'dueDate': DateTime.now().add(const Duration(days: 2)),
      'submittedDate': null,
      'priority': 'High',
      'type': 'Problem Set',
      'status': 'In Progress',
      'progress': 0.6,
      'maxScore': 100,
      'estimatedTime': '2 hours',
      'instructions': 'Show all work and explain your reasoning for each problem.',
      'attachments': ['chapter8_problems.pdf'],
      'submissions': [],
      'feedback': null,
      'grade': null,
    },
    {
      'id': '2',
      'title': 'History Essay: World War II',
      'subject': 'History',
      'description': 'Write a 1500-word essay on the causes of World War II',
      'dueDate': DateTime.now().add(const Duration(days: 5)),
      'submittedDate': null,
      'priority': 'Medium',
      'type': 'Essay',
      'status': 'Pending',
      'progress': 0.2,
      'maxScore': 100,
      'estimatedTime': '4 hours',
      'instructions': 'Use at least 5 credible sources and follow MLA format.',
      'attachments': ['essay_guidelines.pdf', 'source_list.pdf'],
      'submissions': [],
      'feedback': null,
      'grade': null,
    },
    {
      'id': '3',
      'title': 'Physics Lab Report',
      'subject': 'Physics',
      'description': 'Lab report on pendulum motion experiment',
      'dueDate': DateTime.now().add(const Duration(days: 1)),
      'submittedDate': null,
      'priority': 'High',
      'type': 'Lab Report',
      'status': 'Pending',
      'progress': 0.0,
      'maxScore': 50,
      'estimatedTime': '3 hours',
      'instructions': 'Include data analysis and error calculations.',
      'attachments': ['lab_template.docx'],
      'submissions': [],
      'feedback': null,
      'grade': null,
    },
    {
      'id': '4',
      'title': 'Literature Analysis',
      'subject': 'English',
      'description': 'Character analysis of Hamlet',
      'dueDate': DateTime.now().subtract(const Duration(days: 1)),
      'submittedDate': DateTime.now().subtract(const Duration(days: 2)),
      'priority': 'Medium',
      'type': 'Analysis',
      'status': 'Submitted',
      'progress': 1.0,
      'maxScore': 100,
      'estimatedTime': '3 hours',
      'instructions': 'Focus on character development and themes.',
      'attachments': ['hamlet_text.pdf'],
      'submissions': ['hamlet_analysis.pdf'],
      'feedback': 'Excellent analysis! Consider expanding on the psychological aspects.',
      'grade': 92,
    },
    {
      'id': '5',
      'title': 'Chemistry Quiz',
      'subject': 'Chemistry',
      'description': 'Online quiz on molecular structures',
      'dueDate': DateTime.now().subtract(const Duration(days: 3)),
      'submittedDate': null,
      'priority': 'High',
      'type': 'Quiz',
      'status': 'Overdue',
      'progress': 0.0,
      'maxScore': 25,
      'estimatedTime': '30 minutes',
      'instructions': 'Multiple choice and short answer questions.',
      'attachments': [],
      'submissions': [],
      'feedback': null,
      'grade': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
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
              child: Column(
                children: [
                  _buildFiltersSection(),
                  _buildStatsCards(),
                  Expanded(child: _buildAssignmentsList()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: AppTheme.studentColor,
      title: const Text(
        'My Assignments',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: _showSearchDialog,
        ),
        IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: _showMoreOptions,
        ),
      ],
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown('Filter', _selectedFilter, _filterOptions, (value) {
                  setState(() => _selectedFilter = value);
                }),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFilterDropdown('Sort', _selectedSort, _sortOptions, (value) {
                  setState(() => _selectedSort = value);
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Show Completed'),
                  value: _showCompleted,
                  onChanged: (value) => setState(() => _showCompleted = value ?? true),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppTheme.studentColor,
                ),
              ),
              TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear_rounded),
                label: const Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> options, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(label),
          isExpanded: true,
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) onChanged(newValue);
          },
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    final stats = _calculateStats();
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildStatCard('Total', stats['total'].toString(), AppTheme.studentColor),
          const SizedBox(width: 12),
          _buildStatCard('Pending', stats['pending'].toString(), AppTheme.warningColor),
          const SizedBox(width: 12),
          _buildStatCard('Submitted', stats['submitted'].toString(), AppTheme.successColor),
          const SizedBox(width: 12),
          _buildStatCard('Overdue', stats['overdue'].toString(), AppTheme.errorColor),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentsList() {
    final filteredAssignments = _getFilteredAssignments();
    
    if (filteredAssignments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No assignments found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredAssignments.length,
      itemBuilder: (context, index) {
        final assignment = filteredAssignments[index];
        return _buildAssignmentCard(assignment, index);
      },
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> assignment, int index) {
    final isOverdue = assignment['status'] == 'Overdue';
    final isSubmitted = assignment['status'] == 'Submitted';
    final priority = assignment['priority'];
    
    Color priorityColor = AppTheme.primaryColor;
    if (priority == 'High') priorityColor = AppTheme.errorColor;
    if (priority == 'Medium') priorityColor = AppTheme.warningColor;
    if (priority == 'Low') priorityColor = AppTheme.successColor;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: isOverdue ? Border.all(color: AppTheme.errorColor, width: 2) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: InkWell(
              onTap: () => _viewAssignmentDetails(assignment),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: priorityColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            assignment['priority'],
                            style: TextStyle(
                              color: priorityColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(assignment['status']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            assignment['status'],
                            style: TextStyle(
                              color: _getStatusColor(assignment['status']),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      assignment['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      assignment['subject'],
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.studentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      assignment['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDueDate(assignment['dueDate']),
                          style: TextStyle(
                            fontSize: 12,
                            color: isOverdue ? AppTheme.errorColor : Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          assignment['estimatedTime'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    if (!isSubmitted) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Progress',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${(assignment['progress'] * 100).toInt()}%',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.studentColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: assignment['progress'],
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.studentColor),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () => _continueAssignment(assignment),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.studentColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              assignment['progress'] > 0 ? 'Continue' : 'Start',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (isSubmitted && assignment['grade'] != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.grade_rounded,
                              color: AppTheme.successColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Grade: ${assignment['grade']}/${assignment['maxScore']}',
                              style: TextStyle(
                                color: AppTheme.successColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Submitted':
        return AppTheme.successColor;
      case 'In Progress':
        return AppTheme.studentColor;
      case 'Overdue':
        return AppTheme.errorColor;
      default:
        return AppTheme.warningColor;
    }
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;
    
    if (difference < 0) {
      return 'Overdue by ${-difference} day${-difference == 1 ? '' : 's'}';
    } else if (difference == 0) {
      return 'Due today';
    } else if (difference == 1) {
      return 'Due tomorrow';
    } else {
      return 'Due in $difference days';
    }
  }

  List<Map<String, dynamic>> _getFilteredAssignments() {
    var filtered = _assignments.where((assignment) {
      if (_selectedFilter != 'All' && assignment['status'] != _selectedFilter) return false;
      if (!_showCompleted && assignment['status'] == 'Submitted') return false;
      return true;
    }).toList();

    // Sort assignments
    filtered.sort((a, b) {
      switch (_selectedSort) {
        case 'Due Date':
          return a['dueDate'].compareTo(b['dueDate']);
        case 'Subject':
          return a['subject'].compareTo(b['subject']);
        case 'Priority':
          final priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
          return priorityOrder[a['priority']]!.compareTo(priorityOrder[b['priority']]!);
        case 'Progress':
          return b['progress'].compareTo(a['progress']);
        default:
          return 0;
      }
    });

    return filtered;
  }

  Map<String, int> _calculateStats() {
    return {
      'total': _assignments.length,
      'pending': _assignments.where((a) => a['status'] == 'Pending').length,
      'submitted': _assignments.where((a) => a['status'] == 'Submitted').length,
      'overdue': _assignments.where((a) => a['status'] == 'Overdue').length,
    };
  }

  void _clearFilters() {
    setState(() {
      _selectedFilter = 'All';
      _selectedSort = 'Due Date';
      _showCompleted = true;
    });
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Assignments'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Search by title, subject, or description...',
            prefixIcon: Icon(Icons.search_rounded),
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
            ListTile(
              leading: const Icon(Icons.calendar_today_rounded),
              title: const Text('Calendar View'),
              onTap: () {
                Navigator.pop(context);
                _showCalendarView();
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics_rounded),
              title: const Text('Progress Analytics'),
              onTap: () {
                Navigator.pop(context);
                _showProgressAnalytics();
              },
            ),
            ListTile(
              leading: const Icon(Icons.download_rounded),
              title: const Text('Export Assignments'),
              onTap: () {
                Navigator.pop(context);
                _exportAssignments();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _viewAssignmentDetails(Map<String, dynamic> assignment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignmentDetailsScreen(assignment: assignment),
      ),
    );
  }

  void _continueAssignment(Map<String, dynamic> assignment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignmentWorkScreen(assignment: assignment),
      ),
    );
  }

  void _showCalendarView() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Calendar view coming soon!'),
        backgroundColor: AppTheme.studentColor,
      ),
    );
  }

  void _showProgressAnalytics() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Progress analytics coming soon!'),
        backgroundColor: AppTheme.studentColor,
      ),
    );
  }

  void _exportAssignments() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export functionality coming soon!'),
        backgroundColor: AppTheme.studentColor,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

// Assignment Details Screen
class AssignmentDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> assignment;

  const AssignmentDetailsScreen({Key? key, required this.assignment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(assignment['title']),
        backgroundColor: AppTheme.studentColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 16),
            _buildInstructionsCard(),
            const SizedBox(height: 16),
            _buildAttachmentsCard(),
            const SizedBox(height: 16),
            _buildSubmissionCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assignment Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.studentColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Subject', assignment['subject']),
            _buildInfoRow('Type', assignment['type']),
            _buildInfoRow('Priority', assignment['priority']),
            _buildInfoRow('Due Date', assignment['dueDate'].toString()),
            _buildInfoRow('Estimated Time', assignment['estimatedTime']),
            _buildInfoRow('Max Score', assignment['maxScore'].toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Instructions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.studentColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              assignment['instructions'],
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsCard() {
    final attachments = assignment['attachments'] as List<String>;
    if (attachments.isEmpty) return const SizedBox();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attachments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.studentColor,
              ),
            ),
            const SizedBox(height: 12),
            ...attachments.map((attachment) => ListTile(
              leading: const Icon(Icons.attachment_rounded),
              title: Text(attachment),
              trailing: IconButton(
                icon: const Icon(Icons.download_rounded),
                onPressed: () {},
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmissionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Submission',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.studentColor,
              ),
            ),
            const SizedBox(height: 16),
            if (assignment['status'] == 'Submitted') ...[
              Text('Submitted on: ${assignment['submittedDate']}'),
              if (assignment['grade'] != null) ...[
                const SizedBox(height: 8),
                Text('Grade: ${assignment['grade']}/${assignment['maxScore']}'),
              ],
              if (assignment['feedback'] != null) ...[
                const SizedBox(height: 8),
                Text('Feedback: ${assignment['feedback']}'),
              ],
            ] else ...[
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.studentColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Submit Assignment'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Assignment Work Screen
class AssignmentWorkScreen extends StatelessWidget {
  final Map<String, dynamic> assignment;

  const AssignmentWorkScreen({Key? key, required this.assignment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Working on ${assignment['title']}'),
        backgroundColor: AppTheme.studentColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Assignment work interface coming soon!'),
      ),
    );
  }
} 