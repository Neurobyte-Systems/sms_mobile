import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class AssignmentBulkGradingScreen extends StatefulWidget {
  final Map<String, dynamic> assignment;
  final List<Map<String, dynamic>> submissions;

  const AssignmentBulkGradingScreen({
    Key? key,
    required this.assignment,
    required this.submissions,
  }) : super(key: key);

  @override
  State<AssignmentBulkGradingScreen> createState() => _AssignmentBulkGradingScreenState();
}

class _AssignmentBulkGradingScreenState extends State<AssignmentBulkGradingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late List<Map<String, dynamic>> _submittedAssignments;
  final Map<String, TextEditingController> _gradeControllers = {};
  final Map<String, TextEditingController> _feedbackControllers = {};
  final Map<String, bool> _gradingComplete = {};

  @override
  void initState() {
    super.initState();
    _initializeSubmissions();
    _initializeAnimations();
  }

  void _initializeSubmissions() {
    // Filter only submitted assignments (not graded yet)
    _submittedAssignments = widget.submissions
        .where((s) => s['status'] == 'submitted')
        .toList();

    // Initialize controllers for each submission
    for (var submission in _submittedAssignments) {
      final id = submission['id'];
      _gradeControllers[id] = TextEditingController();
      _feedbackControllers[id] = TextEditingController();
      _gradingComplete[id] = false;
    }
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

  int get _completedCount => _gradingComplete.values.where((v) => v).length;
  int get _totalCount => _submittedAssignments.length;
  double get _progress => _totalCount > 0 ? _completedCount / _totalCount : 0.0;

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

                  // Progress Section
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildProgressSection(),
                        const SizedBox(height: 16),
                        _buildQuickActionsSection(),
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
                        return TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 300 + (index * 50)),
                          tween: Tween(begin: 0.0, end: 1.0),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: Opacity(
                                opacity: value,
                                child: _buildSubmissionGradingCard(
                                  _submittedAssignments[index],
                                  index,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: _submittedAssignments.length,
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
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text(
        'Bulk Grading',
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
        TextButton(
          onPressed: _saveAllGrades,
          child: Text(
            'Save All',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
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
                      'Grade ${_totalCount} submissions',
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
                  Icons.grade_rounded,
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
                Icons.assignment_rounded,
                color: Colors.grey.shade600,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                '${widget.assignment['subject']} • ${widget.assignment['class']}',
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

  Widget _buildProgressSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grading Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              Text(
                '$_completedCount / $_totalCount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            '${(_progress * 100).round()}% Complete',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _applyGradeToAll,
              icon: const Icon(Icons.copy_rounded, size: 16),
              label: const Text('Apply Grade to All'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: BorderSide(color: AppTheme.primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _clearAllGrades,
              icon: const Icon(Icons.clear_rounded, size: 16),
              label: const Text('Clear All'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.errorColor,
                side: BorderSide(color: AppTheme.errorColor),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionsListHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: const Text(
        'Submissions to Grade',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Color(0xFF2D3748),
        ),
      ),
    );
  }

  Widget _buildSubmissionGradingCard(Map<String, dynamic> submission, int index) {
    final id = submission['id'];
    final isComplete = _gradingComplete[id] ?? false;
    final isLate = submission['lateSubmission'] as bool;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(
              color: isComplete 
                  ? AppTheme.successColor.withOpacity(0.3)
                  : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student Header
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
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
                          color: AppTheme.primaryColor,
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
                        Row(
                          children: [
                            Text(
                              'ID: ${submission['studentId']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            if (isLate) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
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
                  ),
                  if (isComplete)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: AppTheme.successColor,
                        size: 20,
                      ),
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

              // Submission Text Preview
              if (submission['submissionText'] != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    submission['submissionText'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Grading Section
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _gradeControllers[id],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Grade',
                        hintText: '/${widget.assignment['points']}',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onChanged: (value) => _updateGradingStatus(id),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _feedbackControllers[id],
                      decoration: InputDecoration(
                        labelText: 'Feedback',
                        hintText: 'Optional feedback...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      maxLines: 1,
                      onChanged: (value) => _updateGradingStatus(id),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Quick Actions
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => _viewFullSubmission(submission),
                    icon: const Icon(Icons.visibility_rounded, size: 16),
                    label: const Text('View Full'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _quickGrade(id, widget.assignment['points']),
                    icon: const Icon(Icons.star_rounded, size: 16),
                    label: const Text('Full Points'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.successColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _saveDraft,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: BorderSide(color: AppTheme.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save Draft'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _saveAllGrades,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Save All Grades ($_completedCount/$_totalCount)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Action Methods
  void _updateGradingStatus(String id) {
    setState(() {
      final grade = _gradeControllers[id]?.text ?? '';
      _gradingComplete[id] = grade.isNotEmpty;
    });
  }

  void _quickGrade(String id, int maxPoints) {
    _gradeControllers[id]?.text = maxPoints.toString();
    _updateGradingStatus(id);
  }

  void _applyGradeToAll() {
    showDialog(
      context: context,
      builder: (context) {
        final gradeController = TextEditingController();
        final feedbackController = TextEditingController();
        
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Apply Grade to All'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: gradeController,
                decoration: InputDecoration(
                  labelText: 'Grade (out of ${widget.assignment['points']})',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: feedbackController,
                decoration: InputDecoration(
                  labelText: 'Feedback (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final grade = gradeController.text;
                final feedback = feedbackController.text;
                
                if (grade.isNotEmpty) {
                  for (var id in _gradeControllers.keys) {
                    _gradeControllers[id]?.text = grade;
                    _feedbackControllers[id]?.text = feedback;
                    _gradingComplete[id] = true;
                  }
                  setState(() {});
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: const Text('Apply', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _clearAllGrades() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear All Grades'),
        content: const Text('Are you sure you want to clear all grades and feedback?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              for (var id in _gradeControllers.keys) {
                _gradeControllers[id]?.clear();
                _feedbackControllers[id]?.clear();
                _gradingComplete[id] = false;
              }
              setState(() {});
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Clear All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _viewFullSubmission(Map<String, dynamic> submission) {
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

  void _saveDraft() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Grades saved as draft'),
        backgroundColor: AppTheme.warningColor,
      ),
    );
  }

  void _saveAllGrades() {
    final gradedCount = _gradingComplete.values.where((v) => v).length;
    
    if (gradedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please grade at least one submission'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Save All Grades'),
        content: Text('Save grades for $gradedCount submissions?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$gradedCount grades saved successfully!'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Save All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _gradeControllers.values) {
      controller.dispose();
    }
    for (var controller in _feedbackControllers.values) {
      controller.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }
} 