import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';
import 'assignments_screen.dart';

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

  String _selectedClass = 'Class 10A';
  String _selectedSubject = 'Mathematics';
  String _selectedTerm = 'Term 1';

  final List<String> _classes = ['Class 10A', 'Class 10B', 'Class 11A', 'Class 12A'];
  final List<String> _subjects = ['Mathematics', 'Physics', 'Chemistry', 'Biology', 'English'];
  final List<String> _terms = ['Term 1', 'Term 2', 'Term 3', 'Full Year'];

  // Class-specific data
  final Map<String, List<Map<String, dynamic>>> _classData = {
    'Class 10A': [
      {
        'id': '1',
        'name': 'Alice Johnson',
        'rollNumber': '001',
        'avatar': 'AJ',
        'assessments': {
          'quizzes': [85, 90, 78, 92],
          'assignments': [88, 85, 90],
          'tests': [82, 89],
          'projects': [95],
          'participation': 85,
          'attendance': 95,
        },
        'weights': {
          'quizzes': 0.20,
          'assignments': 0.25,
          'tests': 0.35,
          'projects': 0.15,
          'participation': 0.03,
          'attendance': 0.02,
        },
        'trends': [75, 78, 82, 85, 87, 89],
      },
      {
        'id': '2',
        'name': 'Bob Smith',
        'rollNumber': '002',
        'avatar': 'BS',
        'assessments': {
          'quizzes': [78, 82, 85, 88],
          'assignments': [80, 78, 85],
          'tests': [85, 82],
          'projects': [88],
          'participation': 82,
          'attendance': 92,
        },
        'weights': {
          'quizzes': 0.20,
          'assignments': 0.25,
          'tests': 0.35,
          'projects': 0.15,
          'participation': 0.03,
          'attendance': 0.02,
        },
        'trends': [70, 75, 78, 80, 82, 84],
      },
    ],
    'Class 10B': [
      {
        'id': '3',
        'name': 'Carol Davis',
        'rollNumber': '003',
        'avatar': 'CD',
        'assessments': {
          'quizzes': [92, 88, 90, 95],
          'assignments': [90, 92, 88],
          'tests': [88, 92],
          'projects': [92],
          'participation': 90,
          'attendance': 98,
        },
        'weights': {
          'quizzes': 0.20,
          'assignments': 0.25,
          'tests': 0.35,
          'projects': 0.15,
          'participation': 0.03,
          'attendance': 0.02,
        },
        'trends': [85, 87, 88, 90, 91, 92],
      },
      {
        'id': '4',
        'name': 'David Wilson',
        'rollNumber': '004',
        'avatar': 'DW',
        'assessments': {
          'quizzes': [75, 78, 82, 80],
          'assignments': [82, 80, 78],
          'tests': [78, 82],
          'projects': [85],
          'participation': 78,
          'attendance': 88,
        },
        'weights': {
          'quizzes': 0.20,
          'assignments': 0.25,
          'tests': 0.35,
          'projects': 0.15,
          'participation': 0.03,
          'attendance': 0.02,
        },
        'trends': [68, 70, 75, 78, 79, 80],
      },
      {
        'id': '5',
        'name': 'Emma Johnson',
        'rollNumber': '005',
        'avatar': 'EJ',
        'assessments': {
          'quizzes': [86, 89, 84, 91],
          'assignments': [87, 85, 89],
          'tests': [85, 88],
          'projects': [90],
          'participation': 87,
          'attendance': 94,
        },
        'weights': {
          'quizzes': 0.20,
          'assignments': 0.25,
          'tests': 0.35,
          'projects': 0.15,
          'participation': 0.03,
          'attendance': 0.02,
        },
        'trends': [81, 83, 85, 86, 87, 88],
      },
    ],
    'Class 11A': [
      {
        'id': '5',
        'name': 'Eva Brown',
        'rollNumber': '005',
        'avatar': 'EB',
        'assessments': {
          'quizzes': [88, 85, 90, 92],
          'assignments': [85, 88, 90],
          'tests': [90, 88],
          'projects': [90],
          'participation': 88,
          'attendance': 95,
        },
        'weights': {
          'quizzes': 0.20,
          'assignments': 0.25,
          'tests': 0.35,
          'projects': 0.15,
          'participation': 0.03,
          'attendance': 0.02,
        },
        'trends': [80, 82, 85, 87, 88, 89],
      },
      {
        'id': '6',
        'name': 'Grace Wilson',
        'rollNumber': '006',
        'avatar': 'GW',
        'assessments': {
          'quizzes': [92, 89, 94, 90],
          'assignments': [91, 88, 93],
          'tests': [89, 92],
          'projects': [94],
          'participation': 91,
          'attendance': 97,
        },
        'weights': {
          'quizzes': 0.20,
          'assignments': 0.25,
          'tests': 0.35,
          'projects': 0.15,
          'participation': 0.03,
          'attendance': 0.02,
        },
        'trends': [83, 85, 88, 90, 91, 92],
      },
      {
        'id': '7',
        'name': 'Henry Clark',
        'rollNumber': '007',
        'avatar': 'HC',
        'assessments': {
          'quizzes': [76, 82, 79, 85],
          'assignments': [78, 82, 80],
          'tests': [80, 84],
          'projects': [82],
          'participation': 79,
          'attendance': 89,
        },
        'weights': {
          'quizzes': 0.20,
          'assignments': 0.25,
          'tests': 0.35,
          'projects': 0.15,
          'participation': 0.03,
          'attendance': 0.02,
        },
        'trends': [72, 75, 78, 80, 81, 82],
      },
    ],
    'Class 12A': [
      {
        'id': '8',
        'name': 'Frank Miller',
        'rollNumber': '008',
        'avatar': 'FM',
        'assessments': {
          'quizzes': [95, 92, 88, 94],
          'assignments': [92, 95, 90],
          'tests': [90, 94],
          'projects': [95],
          'participation': 92,
          'attendance': 98,
        },
        'weights': {
          'quizzes': 0.20,
          'assignments': 0.25,
          'tests': 0.35,
          'projects': 0.15,
          'participation': 0.03,
          'attendance': 0.02,
        },
        'trends': [88, 90, 91, 92, 93, 94],
      },
      {
        'id': '9',
        'name': 'Isabella Martinez',
        'rollNumber': '009',
        'avatar': 'IM',
        'assessments': {
          'quizzes': [89, 91, 87, 93],
          'assignments': [88, 90, 92],
          'tests': [87, 91],
          'projects': [89],
          'participation': 90,
          'attendance': 96,
        },
        'weights': {
          'quizzes': 0.20,
          'assignments': 0.25,
          'tests': 0.35,
          'projects': 0.15,
          'participation': 0.03,
          'attendance': 0.02,
        },
        'trends': [82, 84, 86, 88, 89, 90],
      },
      {
        'id': '10',
        'name': 'Jack Thompson',
        'rollNumber': '010',
        'avatar': 'JT',
        'assessments': {
          'quizzes': [84, 87, 82, 89],
          'assignments': [85, 83, 88],
          'tests': [83, 87],
          'projects': [86],
          'participation': 85,
          'attendance': 93,
        },
        'weights': {
          'quizzes': 0.20,
          'assignments': 0.25,
          'tests': 0.35,
          'projects': 0.15,
          'participation': 0.03,
          'attendance': 0.02,
        },
        'trends': [78, 80, 82, 84, 85, 86],
      },
      {
        'id': '11',
        'name': 'Katherine Lee',
        'rollNumber': '011',
        'avatar': 'KL',
        'assessments': {
          'quizzes': [97, 94, 96, 98],
          'assignments': [95, 97, 94],
          'tests': [94, 96],
          'projects': [97],
          'participation': 96,
          'attendance': 99,
        },
        'weights': {
          'quizzes': 0.20,
          'assignments': 0.25,
          'tests': 0.35,
          'projects': 0.15,
          'participation': 0.03,
          'attendance': 0.02,
        },
        'trends': [92, 93, 94, 95, 96, 97],
      },
    ],
  };

  // Get current class students
  List<Map<String, dynamic>> get _students => _classData[_selectedClass] ?? [];

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

  double _calculateCumulativeGrade(Map<String, dynamic> student) {
    final assessments = student['assessments'] as Map<String, dynamic>;
    final weights = student['weights'] as Map<String, dynamic>;
    
    double totalScore = 0.0;
    
    // Calculate weighted average for each assessment type
    assessments.forEach((key, value) {
      if (key == 'participation' || key == 'attendance') {
        totalScore += (value as num) * (weights[key] as num);
      } else if (value is List && value.isNotEmpty) {
        double average = value.cast<num>().reduce((a, b) => a + b) / value.length;
        totalScore += average * (weights[key] as num);
      }
    });
    
    return totalScore;
  }

  String _getLetterGrade(double score) {
    if (score >= 97) return 'A+';
    if (score >= 93) return 'A';
    if (score >= 90) return 'A-';
    if (score >= 87) return 'B+';
    if (score >= 83) return 'B';
    if (score >= 80) return 'B-';
    if (score >= 77) return 'C+';
    if (score >= 73) return 'C';
    if (score >= 70) return 'C-';
    if (score >= 67) return 'D+';
    if (score >= 65) return 'D';
    return 'F';
  }

  Color _getGradeColor(double score) {
    if (score >= 90) return AppTheme.successColor;
    if (score >= 80) return AppTheme.primaryColor;
    if (score >= 70) return AppTheme.warningColor;
    if (score >= 60) return Colors.orange;
    return AppTheme.errorColor;
  }

  double get _classAverage {
    if (_students.isEmpty) return 0.0;
    final grades = _students.map((s) => _calculateCumulativeGrade(s)).toList();
    double total = grades.reduce((a, b) => a + b);
    return total / _students.length;
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

                  // Class Selection
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildClassSelection(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // Overview Stats
                  SliverToBoxAdapter(child: _buildOverviewStats()),

                  // Grade Distribution Chart
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildGradeDistribution(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // Assessment Weights
                  SliverToBoxAdapter(child: _buildAssessmentWeights()),

                  // Students List Header
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildStudentsListHeader(),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),

                  // Students List
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 300 + (index * 100)),
                          tween: Tween(begin: 0.0, end: 1.0),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: Opacity(
                                opacity: value,
                                child: _buildStudentCard(_students[index], index),
                              ),
                            );
                          },
                        );
                      },
                      childCount: _students.length,
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
        'Continuous Assessment',
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
            icon: const Icon(
              Icons.print_rounded,
              color: Color(0xFF2D3748),
            ),
            onPressed: _printClassReport,
          ),
          IconButton(
            icon: const Icon(
              Icons.download_rounded,
              color: Color(0xFF2D3748),
            ),
            onPressed: _exportClassReport,
          ),
          IconButton(
            icon: const Icon(
              Icons.analytics_rounded,
              color: Color(0xFF2D3748),
            ),
            onPressed: _showAnalytics,
          ),
          IconButton(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Color(0xFF2D3748),
            ),
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
                  'Continuous Assessment',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cumulative grades and progress tracking',
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
              Icons.assessment_rounded,
              color: AppTheme.primaryColor,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassSelection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Class Selection Row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedClass,
                      isExpanded: true,
                      menuMaxHeight: 200,
                      items: _classes.map((className) {
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
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedSubject,
                      isExpanded: true,
                      menuMaxHeight: 200,
                      items: _subjects.map((subject) {
                        return DropdownMenuItem(
                          value: subject,
                          child: Text(subject),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSubject = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Term Selection Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedTerm,
                isExpanded: true,
                menuMaxHeight: 200,
                items: _terms.map((term) {
                  return DropdownMenuItem(
                    value: term,
                    child: Text(term),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTerm = value!;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Class Average',
              '${_classAverage.toStringAsFixed(1)}%',
              Icons.trending_up_rounded,
              AppTheme.primaryColor,
              _getLetterGrade(_classAverage),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Students',
              '${_students.length}',
              Icons.group_rounded,
              AppTheme.successColor,
              'Total',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Assessments',
              '${_getTotalAssessments()}',
              Icons.assignment_rounded,
              AppTheme.warningColor,
              'Completed',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String subtitle) {
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
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGradeDistribution() {
    final gradeRanges = {
      'A (90-100)': _students.where((s) => _calculateCumulativeGrade(s) >= 90).length,
      'B (80-89)': _students.where((s) => _calculateCumulativeGrade(s) >= 80 && _calculateCumulativeGrade(s) < 90).length,
      'C (70-79)': _students.where((s) => _calculateCumulativeGrade(s) >= 70 && _calculateCumulativeGrade(s) < 80).length,
      'D (60-69)': _students.where((s) => _calculateCumulativeGrade(s) >= 60 && _calculateCumulativeGrade(s) < 70).length,
      'F (0-59)': _students.where((s) => _calculateCumulativeGrade(s) < 60).length,
    };

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grade Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),
          ...gradeRanges.entries.map((entry) {
            final percentage = _students.isEmpty ? 0.0 : entry.value / _students.length;
            return _buildDistributionItem(entry.key, entry.value, percentage);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildDistributionItem(String grade, int count, double percentage) {
    final color = _getGradeColor(grade.contains('A') ? 95 : 
                                grade.contains('B') ? 85 : 
                                grade.contains('C') ? 75 : 
                                grade.contains('D') ? 65 : 55);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              grade,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentWeights() {
    // Use standard weights if no students or use first student's weights
    final Map<String, dynamic> weights = _students.isNotEmpty 
        ? _students.first['weights'] as Map<String, dynamic>
        : {
            'quizzes': 0.20,
            'assignments': 0.25,
            'tests': 0.35,
            'projects': 0.15,
            'participation': 0.03,
            'attendance': 0.02,
          };
    
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Assessment Weights',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: weights.entries.map((entry) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getAssessmentIcon(entry.key),
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${entry.key.toUpperCase()}: ${(entry.value * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsListHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const Text(
            'Student Performance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.sort_rounded),
            onPressed: _showSortOptions,
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student, int index) {
    final cumulativeGrade = _calculateCumulativeGrade(student);
    final letterGrade = _getLetterGrade(cumulativeGrade);
    final gradeColor = _getGradeColor(cumulativeGrade);
    final assessments = student['assessments'] as Map<String, dynamic>;
    final trends = student['trends'] as List<dynamic>;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _showStudentDetails(student),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
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
                        color: gradeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          student['avatar'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: gradeColor,
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
                            student['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Roll No: ${student['rollNumber']}',
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
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: gradeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            letterGrade,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: gradeColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${cumulativeGrade.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: gradeColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Assessment Breakdown
                Row(
                  children: [
                    Expanded(
                      child: _buildAssessmentChip(
                        'Quizzes',
                        _calculateAverage(assessments['quizzes']),
                        Icons.quiz_rounded,
                        AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildAssessmentChip(
                        'Tests',
                        _calculateAverage(assessments['tests']),
                        Icons.assignment_rounded,
                        AppTheme.warningColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildAssessmentChip(
                        'Projects',
                        _calculateAverage(assessments['projects']),
                        Icons.folder_special_rounded,
                        AppTheme.successColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Progress Trend
                Row(
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Progress Trend:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 30,
                        child: Row(
                          children: trends.asMap().entries.map((entry) {
                            final index = entry.key;
                            final value = entry.value as num;
                            final height = (value / 100) * 20;
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 1),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: height,
                                      decoration: BoxDecoration(
                                        color: index == trends.length - 1 
                                            ? gradeColor 
                                            : gradeColor.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getTrendDirection(trends),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getTrendColor(trends),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showStudentDetails(student),
                        icon: const Icon(Icons.visibility_rounded, size: 16),
                        label: const Text('View Details'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          side: BorderSide(color: AppTheme.primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _addAssessment(student),
                        icon: const Icon(Icons.add_rounded, size: 16),
                        label: const Text('Add Grade'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.successColor,
                          side: BorderSide(color: AppTheme.successColor),
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

  Widget _buildAssessmentChip(String title, double average, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            '${average.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      heroTag: "grades_fab", // Add unique hero tag
      onPressed: _addNewAssessment,
      backgroundColor: AppTheme.primaryColor,
      icon: const Icon(Icons.add_rounded, color: Colors.white),
      label: const Text(
        'New Assessment',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Helper Methods
  double _calculateAverage(dynamic scores) {
    if (scores is List && scores.isNotEmpty) {
      final numList = scores.cast<num>();
      return numList.reduce((a, b) => a + b) / numList.length;
    }
    return 0.0;
  }

  int _getTotalAssessments() {
    if (_students.isEmpty) return 0;
    final assessments = _students.first['assessments'] as Map<String, dynamic>;
    int total = 0;
    assessments.forEach((key, value) {
      if (value is List) {
        total += value.length;
      } else if (key == 'participation' || key == 'attendance') {
        total += 1;
      }
    });
    return total;
  }

  IconData _getAssessmentIcon(String assessment) {
    switch (assessment) {
      case 'quizzes':
        return Icons.quiz_rounded;
      case 'assignments':
        return Icons.assignment_rounded;
      case 'tests':
        return Icons.assignment_turned_in_rounded;
      case 'projects':
        return Icons.folder_special_rounded;
      case 'participation':
        return Icons.record_voice_over_rounded;
      case 'attendance':
        return Icons.event_available_rounded;
      default:
        return Icons.assessment_rounded;
    }
  }

  String _getTrendDirection(List<dynamic> trends) {
    if (trends.length < 2) return 'N/A';
    final first = trends.first as num;
    final last = trends.last as num;
    final diff = last - first;
    if (diff > 5) return '↗ Rising';
    if (diff < -5) return '↘ Falling';
    return '→ Stable';
  }

  Color _getTrendColor(List<dynamic> trends) {
    if (trends.length < 2) return Colors.grey;
    final first = trends.first as num;
    final last = trends.last as num;
    final diff = last - first;
    if (diff > 5) return AppTheme.successColor;
    if (diff < -5) return AppTheme.errorColor;
    return AppTheme.warningColor;
  }

  // Action Methods
  void _showStudentDetails(Map<String, dynamic> student) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          final cumulativeGrade = _calculateCumulativeGrade(student);
          final letterGrade = _getLetterGrade(cumulativeGrade);
          final gradeColor = _getGradeColor(cumulativeGrade);
          final assessments = student['assessments'] as Map<String, dynamic>;
          final trends = student['trends'] as List<dynamic>;

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
                
                // Student Header
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: gradeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          student['avatar'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: gradeColor,
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
                            student['name'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Roll No: ${student['rollNumber']} • $_selectedClass • $_selectedSubject',
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
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: gradeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            letterGrade,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: gradeColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${cumulativeGrade.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: gradeColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _printStudentReport(student),
                        icon: const Icon(Icons.print_rounded, size: 16),
                        label: const Text('Print Report'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _exportStudentReport(student),
                        icon: const Icon(Icons.download_rounded, size: 16),
                        label: const Text('Export PDF'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          side: BorderSide(color: AppTheme.primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Assessment Overview
                        const Text(
                          'Assessment Overview',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Assessment Cards
                        _buildDetailedAssessmentCard('Quizzes', assessments['quizzes'], 0.20, Icons.quiz_rounded, AppTheme.primaryColor),
                        const SizedBox(height: 12),
                        _buildDetailedAssessmentCard('Assignments', assessments['assignments'], 0.25, Icons.assignment_rounded, AppTheme.warningColor),
                        const SizedBox(height: 12),
                        _buildDetailedAssessmentCard('Tests', assessments['tests'], 0.35, Icons.assignment_turned_in_rounded, AppTheme.errorColor),
                        const SizedBox(height: 12),
                        _buildDetailedAssessmentCard('Projects', assessments['projects'], 0.15, Icons.folder_special_rounded, AppTheme.successColor),
                        const SizedBox(height: 12),
                        
                        // Participation & Attendance
                        Row(
                          children: [
                            Expanded(
                              child: _buildSimpleAssessmentCard('Participation', assessments['participation'], 0.03, Icons.record_voice_over_rounded, Colors.purple),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSimpleAssessmentCard('Attendance', assessments['attendance'], 0.02, Icons.event_available_rounded, Colors.blue),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Progress Trend
                        const Text(
                          'Progress Trend',
                          style: TextStyle(
                            fontSize: 18,
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
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.trending_up_rounded, color: _getTrendColor(trends), size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    _getTrendDirection(trends),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: _getTrendColor(trends),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${trends.first}% → ${trends.last}%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 60,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: trends.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final value = entry.value as num;
                                    final height = (value / 100) * 50;
                                    final isLast = index == trends.length - 1;
                                    
                                    return Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 2),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              height: height,
                                              decoration: BoxDecoration(
                                                color: isLast ? gradeColor : gradeColor.withOpacity(0.6),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'M${index + 1}',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Grade Calculation
                        const Text(
                          'Grade Calculation',
                          style: TextStyle(
                            fontSize: 18,
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
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildCalculationRow('Quizzes', _calculateAverage(assessments['quizzes']), 0.20),
                              _buildCalculationRow('Assignments', _calculateAverage(assessments['assignments']), 0.25),
                              _buildCalculationRow('Tests', _calculateAverage(assessments['tests']), 0.35),
                              _buildCalculationRow('Projects', _calculateAverage(assessments['projects']), 0.15),
                              _buildCalculationRow('Participation', assessments['participation'], 0.03),
                              _buildCalculationRow('Attendance', assessments['attendance'], 0.02),
                              const Divider(height: 32),
                              Row(
                                children: [
                                  const Text(
                                    'Final Grade:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${cumulativeGrade.toStringAsFixed(1)}% ($letterGrade)',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: gradeColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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

  void _addAssessment(Map<String, dynamic> student) {
    // Add assessment logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Add assessment for ${student['name']}'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _addNewAssessment() {
    // Navigate to assignments screen to create new assessment
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AssignmentsScreen(),
      ),
    );
  }

  void _showAnalytics() {
    // Show analytics
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Analytics view'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _showMoreOptions() {
    // Show more options
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('More options'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _showSortOptions() {
    // Show sort options
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sort options'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  // Helper methods for detailed student view
  Widget _buildDetailedAssessmentCard(String title, dynamic scores, double weight, IconData icon, Color color) {
    final scoresList = scores is List ? scores.cast<num>() : <num>[];
    final average = scoresList.isEmpty ? 0.0 : scoresList.reduce((a, b) => a + b) / scoresList.length;
    
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(weight * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Average: ${average.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Count: ${scoresList.length}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (scoresList.isNotEmpty)
                Expanded(
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    alignment: WrapAlignment.end,
                    children: scoresList.map((score) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getGradeColor(score.toDouble()).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${score.toInt()}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getGradeColor(score.toDouble()),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleAssessmentCard(String title, dynamic score, double weight, IconData icon, Color color) {
    final scoreValue = score is num ? score.toDouble() : 0.0;
    
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
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${scoreValue.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Weight: ${(weight * 100).toInt()}%',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationRow(String title, dynamic score, double weight) {
    final scoreValue = score is num ? score.toDouble() : 0.0;
    final contribution = scoreValue * weight;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          Expanded(
            child: Text(
              '${scoreValue.toStringAsFixed(1)}%',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4A5568),
              ),
            ),
          ),
          Expanded(
            child: Text(
              '×${(weight * 100).toInt()}%',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4A5568),
              ),
            ),
          ),
          Expanded(
            child: Text(
              '${contribution.toStringAsFixed(2)}',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Export and Print Methods
  void _printClassReport() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.print_rounded, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text('Print Class Report'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Print cumulative assessment report for $_selectedClass?'),
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
                  Text('Class: $_selectedClass'),
                  Text('Subject: $_selectedSubject'),
                  Text('Term: $_selectedTerm'),
                  Text('Students: ${_students.length}'),
                  Text('Average: ${_classAverage.toStringAsFixed(1)}%'),
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
                  content: Text('Printing $_selectedClass report...'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text(
              'Print',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _exportClassReport() {
    HapticFeedback.lightImpact();
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
            Text(
              'Export $_selectedClass Report',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            _buildExportOption(
              Icons.picture_as_pdf_rounded,
              'Export as PDF',
              'Complete assessment report with charts',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Exporting $_selectedClass report as PDF...'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
            ),
            _buildExportOption(
              Icons.table_chart_rounded,
              'Export as Excel',
              'Spreadsheet with all student data',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Exporting $_selectedClass report as Excel...'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
            ),
            _buildExportOption(
              Icons.share_rounded,
              'Share Report',
              'Share via email or messaging',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sharing $_selectedClass report...'),
                    backgroundColor: AppTheme.successColor,
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

  void _printStudentReport(Map<String, dynamic> student) {
    HapticFeedback.lightImpact();
    Navigator.pop(context); // Close the student details modal
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.print_rounded, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text('Print Student Report'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Print detailed assessment report for ${student['name']}?'),
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
                  Text('Student: ${student['name']}'),
                  Text('Roll No: ${student['rollNumber']}'),
                  Text('Class: $_selectedClass'),
                  Text('Subject: $_selectedSubject'),
                  Text('Grade: ${_calculateCumulativeGrade(student).toStringAsFixed(1)}% (${_getLetterGrade(_calculateCumulativeGrade(student))})'),
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
                  content: Text('Printing ${student['name']} report...'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text(
              'Print',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _exportStudentReport(Map<String, dynamic> student) {
    HapticFeedback.lightImpact();
    Navigator.pop(context); // Close the student details modal
    
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
            Text(
              'Export ${student['name']} Report',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            _buildExportOption(
              Icons.picture_as_pdf_rounded,
              'Export as PDF',
              'Complete assessment report with progress charts',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Exporting ${student['name']} report as PDF...'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
            ),
            _buildExportOption(
              Icons.email_rounded,
              'Email to Parent',
              'Send report directly to parent\'s email',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Emailing ${student['name']} report to parent...'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
            ),
            _buildExportOption(
              Icons.share_rounded,
              'Share Report',
              'Share via messaging or other apps',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sharing ${student['name']} report...'),
                    backgroundColor: AppTheme.successColor,
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

  Widget _buildExportOption(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primaryColor),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D3748),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
