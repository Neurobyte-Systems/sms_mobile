import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class StudentGradesScreen extends StatefulWidget {
  const StudentGradesScreen({Key? key}) : super(key: key);

  @override
  State<StudentGradesScreen> createState() => _StudentGradesScreenState();
}

class _StudentGradesScreenState extends State<StudentGradesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedSemester = 'Current Semester';
  String _selectedSubject = 'All Subjects';
  String _selectedView = 'Overview';

  final List<String> _semesters = ['Current Semester', 'Previous Semester', 'Full Year'];
  final List<String> _subjects = ['All Subjects', 'Mathematics', 'Physics', 'Chemistry', 'English', 'History'];
  final List<String> _views = ['Overview', 'Detailed', 'Trends'];

  final Map<String, dynamic> _overallStats = {
    'currentGPA': 3.75,
    'previousGPA': 3.62,
    'totalCredits': 24,
    'completedAssignments': 45,
    'totalAssignments': 48,
    'averageScore': 87.5,
    'rank': 12,
    'totalStudents': 150,
  };

  final List<Map<String, dynamic>> _subjectGrades = [
    {
      'subject': 'Mathematics',
      'currentGrade': 'A-',
      'percentage': 88.5,
      'credits': 4,
      'assignments': 12,
      'completedAssignments': 12,
      'trend': 'up',
      'color': AppTheme.primaryColor,
      'recentScores': [85, 90, 88, 92, 87],
      'categories': {
        'Homework': {'weight': 20, 'score': 92},
        'Quizzes': {'weight': 30, 'score': 85},
        'Midterm': {'weight': 25, 'score': 88},
        'Final': {'weight': 25, 'score': 90},
      },
    },
    {
      'subject': 'Physics',
      'currentGrade': 'B+',
      'percentage': 85.2,
      'credits': 4,
      'assignments': 10,
      'completedAssignments': 9,
      'trend': 'stable',
      'color': AppTheme.successColor,
      'recentScores': [82, 88, 85, 84, 86],
      'categories': {
        'Labs': {'weight': 25, 'score': 88},
        'Homework': {'weight': 20, 'score': 85},
        'Tests': {'weight': 35, 'score': 82},
        'Final': {'weight': 20, 'score': 87},
      },
    },
    {
      'subject': 'Chemistry',
      'currentGrade': 'A',
      'percentage': 91.8,
      'credits': 3,
      'assignments': 8,
      'completedAssignments': 8,
      'trend': 'up',
      'color': AppTheme.warningColor,
      'recentScores': [88, 92, 94, 90, 95],
      'categories': {
        'Labs': {'weight': 30, 'score': 93},
        'Homework': {'weight': 15, 'score': 95},
        'Quizzes': {'weight': 25, 'score': 89},
        'Exams': {'weight': 30, 'score': 92},
      },
    },
    {
      'subject': 'English',
      'currentGrade': 'B',
      'percentage': 82.4,
      'credits': 3,
      'assignments': 9,
      'completedAssignments': 8,
      'trend': 'down',
      'color': AppTheme.teacherColor,
      'recentScores': [85, 80, 82, 78, 84],
      'categories': {
        'Essays': {'weight': 40, 'score': 80},
        'Participation': {'weight': 20, 'score': 88},
        'Quizzes': {'weight': 20, 'score': 82},
        'Final Project': {'weight': 20, 'score': 85},
      },
    },
    {
      'subject': 'History',
      'currentGrade': 'A-',
      'percentage': 89.1,
      'credits': 3,
      'assignments': 7,
      'completedAssignments': 7,
      'trend': 'up',
      'color': AppTheme.parentColor,
      'recentScores': [86, 88, 92, 90, 89],
      'categories': {
        'Research Papers': {'weight': 35, 'score': 91},
        'Exams': {'weight': 35, 'score': 87},
        'Participation': {'weight': 20, 'score': 92},
        'Final Project': {'weight': 10, 'score': 88},
      },
    },
  ];

  final List<Map<String, dynamic>> _recentGrades = [
    {
      'subject': 'Mathematics',
      'assignment': 'Calculus Test',
      'grade': 'A-',
      'score': 88,
      'maxScore': 100,
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'feedback': 'Excellent work on integration problems!',
      'category': 'Test',
    },
    {
      'subject': 'Chemistry',
      'assignment': 'Organic Chemistry Lab',
      'grade': 'A',
      'score': 95,
      'maxScore': 100,
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'feedback': 'Perfect lab technique and analysis.',
      'category': 'Lab',
    },
    {
      'subject': 'Physics',
      'assignment': 'Mechanics Quiz',
      'grade': 'B+',
      'score': 85,
      'maxScore': 100,
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'feedback': 'Good understanding, review force diagrams.',
      'category': 'Quiz',
    },
    {
      'subject': 'English',
      'assignment': 'Literary Analysis Essay',
      'grade': 'B',
      'score': 82,
      'maxScore': 100,
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'feedback': 'Strong thesis, expand on character development.',
      'category': 'Essay',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
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
                  Expanded(
                    child: _selectedView == 'Overview' 
                        ? _buildOverviewTab()
                        : _selectedView == 'Detailed' 
                            ? _buildDetailedTab()
                            : _buildTrendsTab(),
                  ),
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
        'My Grades',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.analytics_rounded),
          onPressed: _showAnalytics,
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
                child: _buildDropdown('Semester', _selectedSemester, _semesters, (value) {
                  setState(() => _selectedSemester = value);
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdown('Subject', _selectedSubject, _subjects, (value) {
                  setState(() => _selectedSubject = value);
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDropdown('View', _selectedView, _views, (value) {
                  setState(() => _selectedView = value);
                }),
              ),
              const SizedBox(width: 12),
              Expanded(child: Container()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options, Function(String) onChanged) {
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

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildGPACard(),
          const SizedBox(height: 16),
          _buildStatsCards(),
          const SizedBox(height: 16),
          _buildSubjectGradesGrid(),
          const SizedBox(height: 16),
          _buildRecentGradesCard(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildGPACard() {
    final currentGPA = _overallStats['currentGPA'];
    final previousGPA = _overallStats['previousGPA'];
    final gpaChange = currentGPA - previousGPA;
    final isPositive = gpaChange > 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.studentColor, AppTheme.studentColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.studentColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current GPA',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentGPA.toStringAsFixed(2),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isPositive ? AppTheme.successColor : AppTheme.errorColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${isPositive ? '+' : ''}${gpaChange.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'vs last semester',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildGPAInfo('Credits', '${_overallStats['totalCredits']}'),
              ),
              Expanded(
                child: _buildGPAInfo('Rank', '${_overallStats['rank']}/${_overallStats['totalStudents']}'),
              ),
              Expanded(
                child: _buildGPAInfo('Average', '${_overallStats['averageScore']}%'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGPAInfo(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Completed',
            '${_overallStats['completedAssignments']}/${_overallStats['totalAssignments']}',
            AppTheme.successColor,
            Icons.assignment_turned_in_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Progress',
            '${((_overallStats['completedAssignments'] / _overallStats['totalAssignments']) * 100).toInt()}%',
            AppTheme.primaryColor,
            Icons.trending_up_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectGradesGrid() {
    final filteredSubjects = _selectedSubject == 'All Subjects' 
        ? _subjectGrades 
        : _subjectGrades.where((s) => s['subject'] == _selectedSubject).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Subject Grades',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.grey.shade800,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: _showAllSubjects,
              child: Text(
                'View All',
                style: TextStyle(
                  color: AppTheme.studentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...filteredSubjects.map((subject) => _buildSubjectGradeCard(subject)),
      ],
    );
  }

  Widget _buildSubjectGradeCard(Map<String, dynamic> subject) {
    final trendIcon = subject['trend'] == 'up' 
        ? Icons.trending_up_rounded 
        : subject['trend'] == 'down' 
            ? Icons.trending_down_rounded 
            : Icons.trending_flat_rounded;
    
    final trendColor = subject['trend'] == 'up' 
        ? AppTheme.successColor 
        : subject['trend'] == 'down' 
            ? AppTheme.errorColor 
            : AppTheme.warningColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: InkWell(
        onTap: () => _showSubjectDetails(subject),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: subject['color'],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject['subject'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${subject['completedAssignments']}/${subject['assignments']} assignments',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          subject['currentGrade'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: subject['color'],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          trendIcon,
                          color: trendColor,
                          size: 20,
                        ),
                      ],
                    ),
                    Text(
                      '${subject['percentage']}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: subject['percentage'] / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(subject['color']),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentGradesCard() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Recent Grades',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade800,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _showAllGrades,
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: AppTheme.studentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._recentGrades.take(3).map((grade) => _buildRecentGradeItem(grade)),
        ],
      ),
    );
  }

  Widget _buildRecentGradeItem(Map<String, dynamic> grade) {
    final gradeColor = _getGradeColor(grade['score']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: gradeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                grade['grade'],
                style: TextStyle(
                  color: gradeColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  grade['assignment'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  grade['subject'],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${grade['score']}/${grade['maxScore']}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                _formatDate(grade['date']),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(int score) {
    if (score >= 90) return AppTheme.successColor;
    if (score >= 80) return AppTheme.warningColor;
    if (score >= 70) return AppTheme.primaryColor;
    return AppTheme.errorColor;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '$difference days ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildDetailedTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ..._subjectGrades.map((subject) => _buildDetailedSubjectCard(subject)),
        ],
      ),
    );
  }

  Widget _buildDetailedSubjectCard(Map<String, dynamic> subject) {
    final categories = subject['categories'] as Map<String, dynamic>;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                subject['subject'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                subject['currentGrade'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: subject['color'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Grade Breakdown',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          ...categories.entries.map((entry) => _buildCategoryItem(
            entry.key,
            entry.value['weight'],
            entry.value['score'],
            subject['color'],
          )),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String category, int weight, int score, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              category,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '$weight%',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$score%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsTab() {
    return const Center(
      child: Text(
        'Trends analysis coming soon!',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showAnalytics() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Grade Analytics'),
        content: const Text('Detailed analytics coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
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
              leading: const Icon(Icons.download_rounded),
              title: const Text('Export Grades'),
              onTap: () {
                Navigator.pop(context);
                _exportGrades();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share_rounded),
              title: const Text('Share Progress'),
              onTap: () {
                Navigator.pop(context);
                _shareProgress();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: const Text('Grade Settings'),
              onTap: () {
                Navigator.pop(context);
                _showGradeSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSubjectDetails(Map<String, dynamic> subject) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubjectDetailsScreen(subject: subject),
      ),
    );
  }

  void _showAllSubjects() {
    setState(() {
      _selectedSubject = 'All Subjects';
      _selectedView = 'Detailed';
    });
  }

  void _showAllGrades() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllGradesScreen(grades: _recentGrades),
      ),
    );
  }

  void _exportGrades() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export functionality coming soon!'),
        backgroundColor: AppTheme.studentColor,
      ),
    );
  }

  void _shareProgress() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon!'),
        backgroundColor: AppTheme.studentColor,
      ),
    );
  }

  void _showGradeSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Grade settings coming soon!'),
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

// Subject Details Screen
class SubjectDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> subject;

  const SubjectDetailsScreen({Key? key, required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject['subject']),
        backgroundColor: subject['color'],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewCard(),
            const SizedBox(height: 16),
            _buildGradeBreakdownCard(),
            const SizedBox(height: 16),
            _buildRecentScoresCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: subject['color'],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem('Current Grade', subject['currentGrade']),
                ),
                Expanded(
                  child: _buildInfoItem('Percentage', '${subject['percentage']}%'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem('Credits', '${subject['credits']}'),
                ),
                Expanded(
                  child: _buildInfoItem('Assignments', '${subject['completedAssignments']}/${subject['assignments']}'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildGradeBreakdownCard() {
    final categories = subject['categories'] as Map<String, dynamic>;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Grade Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: subject['color'],
              ),
            ),
            const SizedBox(height: 16),
            ...categories.entries.map((entry) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    '${entry.value['weight']}%',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: subject['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${entry.value['score']}%',
                      style: TextStyle(
                        color: subject['color'],
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentScoresCard() {
    final scores = subject['recentScores'] as List<int>;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Scores',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: subject['color'],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: scores.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: subject['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${scores[index]}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: subject['color'],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Test ${index + 1}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// All Grades Screen
class AllGradesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> grades;

  const AllGradesScreen({Key? key, required this.grades}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Grades'),
        backgroundColor: AppTheme.studentColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: grades.length,
        itemBuilder: (context, index) {
          final grade = grades[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getGradeColor(grade['score']),
                child: Text(
                  grade['grade'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              title: Text(grade['assignment']),
              subtitle: Text(grade['subject']),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${grade['score']}/${grade['maxScore']}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    _formatDate(grade['date']),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getGradeColor(int score) {
    if (score >= 90) return AppTheme.successColor;
    if (score >= 80) return AppTheme.warningColor;
    if (score >= 70) return AppTheme.primaryColor;
    return AppTheme.errorColor;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 