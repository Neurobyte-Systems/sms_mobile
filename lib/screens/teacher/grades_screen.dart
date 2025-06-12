import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
// import '../../utils/constants.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({Key? key}) : super(key: key);

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedClass = 'Class 10A - Mathematics';
  String _selectedAssignment = 'Algebra Quiz';

  final List<String> _classes = [
    'Class 10A - Mathematics',
    'Class 10B - Physics',
    'Class 11A - Chemistry',
    'Class 12A - Advanced Math',
  ];

  final List<String> _assignments = [
    'Algebra Quiz',
    'Geometry Test',
    'Statistics Assignment',
    'Calculus Midterm',
  ];

  final List<Map<String, dynamic>> _grades = [
    {
      'id': '1',
      'studentName': 'John Doe',
      'rollNumber': '001',
      'grade': 85,
      'letterGrade': 'B+',
      'status': 'graded',
      'submittedDate': '2024-01-15',
      'gradedDate': '2024-01-18',
      'feedback':
          'Good work on problem solving. Need to improve on showing work.',
    },
    {
      'id': '2',
      'studentName': 'Jane Smith',
      'rollNumber': '002',
      'grade': 92,
      'letterGrade': 'A-',
      'status': 'graded',
      'submittedDate': '2024-01-15',
      'gradedDate': '2024-01-18',
      'feedback': 'Excellent understanding of concepts. Well done!',
    },
    {
      'id': '3',
      'studentName': 'Mike Johnson',
      'rollNumber': '003',
      'grade': 78,
      'letterGrade': 'C+',
      'status': 'graded',
      'submittedDate': '2024-01-15',
      'gradedDate': '2024-01-18',
      'feedback': 'Needs more practice with complex problems.',
    },
    {
      'id': '4',
      'studentName': 'Sarah Wilson',
      'rollNumber': '004',
      'grade': 0,
      'letterGrade': '',
      'status': 'pending',
      'submittedDate': '2024-01-15',
      'gradedDate': null,
      'feedback': '',
    },
    {
      'id': '5',
      'studentName': 'David Brown',
      'rollNumber': '005',
      'grade': 88,
      'letterGrade': 'B+',
      'status': 'graded',
      'submittedDate': '2024-01-15',
      'gradedDate': '2024-01-18',
      'feedback': 'Good understanding. Minor calculation errors.',
    },
    {
      'id': '6',
      'studentName': 'Emily Davis',
      'rollNumber': '006',
      'grade': 95,
      'letterGrade': 'A',
      'status': 'graded',
      'submittedDate': '2024-01-15',
      'gradedDate': '2024-01-18',
      'feedback': 'Outstanding work! Perfect execution.',
    },
    {
      'id': '7',
      'studentName': 'Alex Garcia',
      'rollNumber': '007',
      'grade': 0,
      'letterGrade': '',
      'status': 'pending',
      'submittedDate': '2024-01-15',
      'gradedDate': null,
      'feedback': '',
    },
    {
      'id': '8',
      'studentName': 'Lisa Martinez',
      'rollNumber': '008',
      'grade': 91,
      'letterGrade': 'A-',
      'status': 'graded',
      'submittedDate': '2024-01-15',
      'gradedDate': '2024-01-18',
      'feedback': 'Very good work. Keep it up!',
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

  int get _gradedCount => _grades.where((g) => g['status'] == 'graded').length;
  int get _pendingCount =>
      _grades.where((g) => g['status'] == 'pending').length;
  double get _averageGrade {
    final gradedGrades = _grades.where((g) => g['status'] == 'graded').toList();
    if (gradedGrades.isEmpty) return 0;
    return gradedGrades.map((g) => g['grade'] as int).reduce((a, b) => a + b) /
        gradedGrades.length;
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
                  _buildHeader(),
                  _buildSelectors(),
                  _buildStatsCards(),
                  _buildActionButtons(),
                  Expanded(child: _buildGradesList()),
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
        'Grades',
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
          icon: const Icon(Icons.analytics_rounded, color: Color(0xFF2D3748)),
          onPressed: _showAnalytics,
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
          colors: [AppTheme.warningColor.withOpacity(0.1), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grade Management',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Grade assignments and provide feedback',
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
              color: AppTheme.warningColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.grade_rounded,
              color: AppTheme.warningColor,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectors() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Class Selector
          Container(
            margin: const EdgeInsets.only(bottom: 16),
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
              value: _selectedClass,
              decoration: const InputDecoration(
                labelText: 'Select Class',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.class_rounded),
              ),
              items:
                  _classes.map((className) {
                    return DropdownMenuItem(
                      value: className,
                      child: Text(className),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedClass = value!;
                });
              },
            ),
          ),
          // Assignment Selector
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
              value: _selectedAssignment,
              decoration: const InputDecoration(
                labelText: 'Select Assignment',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.assignment_rounded),
              ),
              items:
                  _assignments.map((assignment) {
                    return DropdownMenuItem(
                      value: assignment,
                      child: Text(assignment),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedAssignment = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Graded',
              _gradedCount.toString(),
              Icons.check_circle_rounded,
              AppTheme.successColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Pending',
              _pendingCount.toString(),
              Icons.pending_rounded,
              AppTheme.warningColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Average',
              '${_averageGrade.toStringAsFixed(1)}%',
              Icons.trending_up_rounded,
              AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Total',
              _grades.length.toString(),
              Icons.people_rounded,
              AppTheme.studentColor,
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

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _bulkGrading,
              icon: const Icon(Icons.auto_fix_high_rounded, size: 16),
              label: const Text('Bulk Grade'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
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
              onPressed: _exportGrades,
              icon: const Icon(Icons.download_rounded, size: 16),
              label: const Text('Export'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.teacherColor,
                side: BorderSide(color: AppTheme.teacherColor),
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

  Widget _buildGradesList() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Student Grades',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _sortGrades,
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
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _grades.length,
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
                        child: _buildGradeCard(_grades[index], index),
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

  Widget _buildGradeCard(Map<String, dynamic> gradeData, int index) {
    final status = gradeData['status'] as String;
    final grade = gradeData['grade'] as int;
    Color statusColor;
    Color gradeColor;

    if (status == 'pending') {
      statusColor = AppTheme.warningColor;
      gradeColor = Colors.grey;
    } else {
      statusColor = AppTheme.successColor;
      if (grade >= 90) {
        gradeColor = AppTheme.successColor;
      } else if (grade >= 80) {
        gradeColor = AppTheme.primaryColor;
      } else if (grade >= 70) {
        gradeColor = AppTheme.warningColor;
      } else {
        gradeColor = AppTheme.errorColor;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _editGrade(gradeData),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              border: Border.all(
                color: statusColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Student Avatar
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          gradeData['studentName']
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

                    // Student Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            gradeData['studentName'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Roll No: ${gradeData['rollNumber']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Grade Display
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (status == 'graded') ...[
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  gradeColor,
                                  gradeColor.withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${gradeData['grade']}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    gradeData['letterGrade'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.warningColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'PENDING',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.warningColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),

                if (status == 'graded' && gradeData['feedback'].isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.feedback_rounded,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            gradeData['feedback'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _editGrade(gradeData),
                        icon: Icon(
                          status == 'graded'
                              ? Icons.edit_rounded
                              : Icons.grade_rounded,
                          size: 16,
                        ),
                        label: Text(status == 'graded' ? 'Edit' : 'Grade'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: gradeColor,
                          side: BorderSide(color: gradeColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _sendFeedback(gradeData),
                        icon: const Icon(Icons.send_rounded, size: 16),
                        label: const Text('Send'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
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

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _createRubric,
      backgroundColor: AppTheme.teacherColor,
      icon: const Icon(Icons.rule_rounded, color: Colors.white),
      label: const Text(
        'Create Rubric',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Action Methods
  void _editGrade(Map<String, dynamic> gradeData) {
    showDialog(
      context: context,
      builder: (context) => _buildGradeDialog(gradeData),
    );
  }

  Widget _buildGradeDialog(Map<String, dynamic> gradeData) {
    final TextEditingController gradeController = TextEditingController(
      text:
          gradeData['status'] == 'graded' ? gradeData['grade'].toString() : '',
    );
    final TextEditingController feedbackController = TextEditingController(
      text: gradeData['feedback'],
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.grade_rounded, color: AppTheme.warningColor),
          const SizedBox(width: 8),
          Text('Grade ${gradeData['studentName']}'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: gradeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Grade (0-100)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.grade_rounded),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Feedback',
                hintText: 'Enter your feedback for the student...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.feedback_rounded),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final grade = int.tryParse(gradeController.text) ?? 0;
            setState(() {
              gradeData['grade'] = grade;
              gradeData['letterGrade'] = _getLetterGrade(grade);
              gradeData['status'] = 'graded';
              gradeData['feedback'] = feedbackController.text;
              gradeData['gradedDate'] = DateTime.now().toString().split(' ')[0];
            });
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Grade saved for ${gradeData['studentName']}'),
                backgroundColor: AppTheme.successColor,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.warningColor,
          ),
          child: const Text(
            'Save Grade',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  String _getLetterGrade(int grade) {
    if (grade >= 97) return 'A+';
    if (grade >= 93) return 'A';
    if (grade >= 90) return 'A-';
    if (grade >= 87) return 'B+';
    if (grade >= 83) return 'B';
    if (grade >= 80) return 'B-';
    if (grade >= 77) return 'C+';
    if (grade >= 73) return 'C';
    if (grade >= 70) return 'C-';
    if (grade >= 67) return 'D+';
    if (grade >= 65) return 'D';
    return 'F';
  }

  void _sendFeedback(Map<String, dynamic> gradeData) {
    if (gradeData['status'] != 'graded') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please grade the assignment first'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.send_rounded, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                const Text('Send Grade'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Send grade to ${gradeData['studentName']} and parent?'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Grade: ${gradeData['grade']} (${gradeData['letterGrade']})',
                      ),
                      if (gradeData['feedback'].isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text('Feedback: ${gradeData['feedback']}'),
                      ],
                    ],
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
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Grade sent to ${gradeData['studentName']}',
                      ),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
                child: const Text(
                  'Send',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _bulkGrading() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.auto_fix_high_rounded, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                const Text('Bulk Grading'),
              ],
            ),
            content: const Text(
              'Apply the same grade to multiple students at once.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Implement bulk grading functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _exportGrades() {
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
                const Text(
                  'Export Grades',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 20),
                _buildExportOption(
                  Icons.table_chart_rounded,
                  'Export as Excel',
                  () {},
                ),
                _buildExportOption(
                  Icons.picture_as_pdf_rounded,
                  'Export as PDF',
                  () {},
                ),
                _buildExportOption(Icons.share_rounded, 'Share Report', () {}),
                const SizedBox(height: 10),
              ],
            ),
          ),
    );
  }

  Widget _buildExportOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.teacherColor),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _showAnalytics() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GradeAnalyticsScreen(grades: _grades),
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
                _buildOptionItem(Icons.history_rounded, 'Grade History', () {}),
                _buildOptionItem(
                  Icons.settings_rounded,
                  'Grading Settings',
                  () {},
                ),
                _buildOptionItem(Icons.backup_rounded, 'Backup Grades', () {}),
                const SizedBox(height: 10),
              ],
            ),
          ),
    );
  }

  Widget _buildOptionItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.teacherColor),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _sortGrades() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Sort Grades'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('By Name'),
                  onTap: () {
                    setState(() {
                      _grades.sort(
                        (a, b) => a['studentName'].compareTo(b['studentName']),
                      );
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('By Grade (High to Low)'),
                  onTap: () {
                    setState(() {
                      _grades.sort((a, b) => b['grade'].compareTo(a['grade']));
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('By Status'),
                  onTap: () {
                    setState(() {
                      _grades.sort(
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

  void _createRubric() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.rule_rounded, color: AppTheme.teacherColor),
                const SizedBox(width: 8),
                const Text('Create Rubric'),
              ],
            ),
            content: const Text(
              'Create a grading rubric for this assignment to ensure consistent grading.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to rubric creation screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.teacherColor,
                ),
                child: const Text(
                  'Create',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

// Grade Analytics Screen
class GradeAnalyticsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> grades;

  const GradeAnalyticsScreen({Key? key, required this.grades})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gradedGrades = grades.where((g) => g['status'] == 'graded').toList();
    final averageGrade =
        gradedGrades.isEmpty
            ? 0.0
            : gradedGrades
                    .map((g) => g['grade'] as int)
                    .reduce((a, b) => a + b) /
                gradedGrades.length;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Grade Analytics',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF2D3748),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFF2D3748),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Cards
            Row(
              children: [
                Expanded(
                  child: _buildAnalyticsCard(
                    'Average Grade',
                    '${averageGrade.toStringAsFixed(1)}%',
                    Icons.trending_up_rounded,
                    AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAnalyticsCard(
                    'Highest Grade',
                    gradedGrades.isEmpty
                        ? '0%'
                        : '${gradedGrades.map((g) => g['grade'] as int).reduce((a, b) => a > b ? a : b)}%',
                    Icons.star_rounded,
                    AppTheme.successColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildAnalyticsCard(
                    'Lowest Grade',
                    gradedGrades.isEmpty
                        ? '0%'
                        : '${gradedGrades.map((g) => g['grade'] as int).reduce((a, b) => a < b ? a : b)}%',
                    Icons.trending_down_rounded,
                    AppTheme.errorColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAnalyticsCard(
                    'Pass Rate',
                    gradedGrades.isEmpty
                        ? '0%'
                        : '${(gradedGrades.where((g) => g['grade'] >= 70).length / gradedGrades.length * 100).toStringAsFixed(1)}%',
                    Icons.check_circle_rounded,
                    AppTheme.warningColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Grade Distribution
            const Text(
              'Grade Distribution',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            Container(
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
              child: Column(
                children: [
                  _buildGradeDistributionBar(
                    'A (90-100)',
                    gradedGrades.where((g) => g['grade'] >= 90).length,
                    gradedGrades.length,
                    AppTheme.successColor,
                  ),
                  const SizedBox(height: 12),
                  _buildGradeDistributionBar(
                    'B (80-89)',
                    gradedGrades
                        .where((g) => g['grade'] >= 80 && g['grade'] < 90)
                        .length,
                    gradedGrades.length,
                    AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 12),
                  _buildGradeDistributionBar(
                    'C (70-79)',
                    gradedGrades
                        .where((g) => g['grade'] >= 70 && g['grade'] < 80)
                        .length,
                    gradedGrades.length,
                    AppTheme.warningColor,
                  ),
                  const SizedBox(height: 12),
                  _buildGradeDistributionBar(
                    'D (60-69)',
                    gradedGrades
                        .where((g) => g['grade'] >= 60 && g['grade'] < 70)
                        .length,
                    gradedGrades.length,
                    AppTheme.errorColor,
                  ),
                  const SizedBox(height: 12),
                  _buildGradeDistributionBar(
                    'F (0-59)',
                    gradedGrades.where((g) => g['grade'] < 60).length,
                    gradedGrades.length,
                    Colors.red.shade700,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
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
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeDistributionBar(
    String grade,
    int count,
    int total,
    Color color,
  ) {
    final percentage = total == 0 ? 0.0 : count / total;

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            grade,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 40,
          child: Text(
            '$count',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
