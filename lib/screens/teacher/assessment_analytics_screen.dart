import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class AssessmentAnalyticsScreen extends StatefulWidget {
  final String selectedClass;
  final String selectedSubject;
  final String selectedTerm;
  final List<Map<String, dynamic>> studentsData;

  const AssessmentAnalyticsScreen({
    Key? key,
    required this.selectedClass,
    required this.selectedSubject,
    required this.selectedTerm,
    required this.studentsData,
  }) : super(key: key);

  @override
  State<AssessmentAnalyticsScreen> createState() => _AssessmentAnalyticsScreenState();
}

class _AssessmentAnalyticsScreenState extends State<AssessmentAnalyticsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String _selectedPeriod = 'This Term';
  String _selectedMetric = 'Overall';

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

  Map<String, dynamic> _calculateAdvancedStats() {
    final grades = widget.studentsData.map((student) => _calculateCumulativeGrade(student)).toList();
    final average = grades.isNotEmpty ? grades.reduce((a, b) => a + b) / grades.length : 0.0;
    final highest = grades.isNotEmpty ? grades.reduce((a, b) => a > b ? a : b) : 0.0;
    final lowest = grades.isNotEmpty ? grades.reduce((a, b) => a < b ? a : b) : 0.0;
    
    // Calculate standard deviation
    final variance = grades.isNotEmpty ? 
      grades.map((grade) => (grade - average) * (grade - average)).reduce((a, b) => a + b) / grades.length : 0.0;
    final standardDeviation = variance > 0 ? (variance * variance).abs() : 0.0;
    
    // Grade distribution
    final gradeDistribution = <String, int>{};
    final letterGrades = grades.map((grade) => _getLetterGrade(grade)).toList();
    for (final grade in letterGrades) {
      gradeDistribution[grade] = (gradeDistribution[grade] ?? 0) + 1;
    }
    
    // Performance levels
    final excellent = grades.where((g) => g >= 90).length;
    final good = grades.where((g) => g >= 80 && g < 90).length;
    final satisfactory = grades.where((g) => g >= 70 && g < 80).length;
    final needsImprovement = grades.where((g) => g < 70).length;
    
    // Assessment type averages
    final assessmentAverages = <String, double>{};
    final assessmentTypes = ['quizzes', 'assignments', 'tests', 'projects'];
    
    for (final type in assessmentTypes) {
      final allScores = <num>[];
      for (final student in widget.studentsData) {
        final scores = student['assessments'][type] as List<dynamic>?;
        if (scores != null && scores.isNotEmpty) {
          allScores.addAll(scores.cast<num>());
        }
      }
      assessmentAverages[type] = allScores.isNotEmpty ? 
        allScores.reduce((a, b) => a + b) / allScores.length : 0.0;
    }
    
    return {
      'average': average,
      'highest': highest,
      'lowest': lowest,
      'standardDeviation': standardDeviation,
      'totalStudents': widget.studentsData.length,
      'gradeDistribution': gradeDistribution,
      'performanceLevels': {
        'excellent': excellent,
        'good': good,
        'satisfactory': satisfactory,
        'needsImprovement': needsImprovement,
      },
      'assessmentAverages': assessmentAverages,
    };
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

  @override
  Widget build(BuildContext context) {
    final stats = _calculateAdvancedStats();
    
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
                  // Header with filters
                  SliverToBoxAdapter(child: _buildHeader()),
                  
                  // Key Metrics Overview
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        _buildSectionTitle('Key Metrics'),
                        const SizedBox(height: 16),
                        _buildKeyMetrics(stats),
                      ],
                    ),
                  ),

                  // Performance Distribution
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        _buildSectionTitle('Performance Distribution'),
                        const SizedBox(height: 16),
                        _buildPerformanceDistribution(stats['performanceLevels']),
                      ],
                    ),
                  ),

                  // Assessment Type Analysis
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        _buildSectionTitle('Assessment Type Analysis'),
                        const SizedBox(height: 16),
                        _buildAssessmentTypeAnalysis(stats['assessmentAverages']),
                      ],
                    ),
                  ),

                  // Grade Distribution Chart
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        _buildSectionTitle('Grade Distribution'),
                        const SizedBox(height: 16),
                        _buildGradeDistributionChart(stats['gradeDistribution']),
                      ],
                    ),
                  ),

                  // Trend Analysis
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        _buildSectionTitle('Trend Analysis'),
                        const SizedBox(height: 16),
                        _buildTrendAnalysis(),
                      ],
                    ),
                  ),

                  // Top Performers
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        _buildSectionTitle('Top Performers'),
                        const SizedBox(height: 16),
                        _buildTopPerformers(),
                        const SizedBox(height: 100),
                      ],
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text(
        'Assessment Analytics',
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
          icon: const Icon(
            Icons.refresh_rounded,
            color: Color(0xFF2D3748),
          ),
          onPressed: _refreshData,
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
      margin: const EdgeInsets.all(24),
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
              Icon(Icons.analytics_rounded, color: AppTheme.primaryColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${widget.selectedClass} Analytics',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${widget.selectedSubject} • ${widget.selectedTerm}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  'Period',
                  _selectedPeriod,
                  ['This Term', 'Last Term', 'This Year', 'Last Year'],
                  (value) => setState(() => _selectedPeriod = value!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterDropdown(
                  'Metric',
                  _selectedMetric,
                  ['Overall', 'Assessments', 'Participation', 'Attendance'],
                  (value) => setState(() => _selectedMetric = value!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A5568),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          items: options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyMetrics(Map<String, dynamic> stats) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Class Average',
                  '${(stats['average'] as double).toStringAsFixed(1)}%',
                  Icons.analytics_rounded,
                  AppTheme.primaryColor,
                  '${_getLetterGrade(stats['average'])}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Highest Score',
                  '${(stats['highest'] as double).toStringAsFixed(1)}%',
                  Icons.trending_up_rounded,
                  AppTheme.successColor,
                  '${_getLetterGrade(stats['highest'])}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Lowest Score',
                  '${(stats['lowest'] as double).toStringAsFixed(1)}%',
                  Icons.trending_down_rounded,
                  AppTheme.errorColor,
                  '${_getLetterGrade(stats['lowest'])}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Total Students',
                  '${stats['totalStudents']}',
                  Icons.people_rounded,
                  AppTheme.warningColor,
                  'Active',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color, String subtitle) {
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
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
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
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceDistribution(Map<String, dynamic> levels) {
    final total = levels.values.fold<int>(0, (sum, count) => sum + (count as int));
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
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
                  _buildPerformanceLevel(
          'Excellent (90%+)',
          levels['excellent'],
          total,
          AppTheme.successColor,
          Icons.star_rounded,
        ),
        const SizedBox(height: 12),
        _buildPerformanceLevel(
          'Good (80-89%)',
          levels['good'],
          total,
          AppTheme.primaryColor,
          Icons.thumb_up_rounded,
        ),
        const SizedBox(height: 12),
        _buildPerformanceLevel(
          'Satisfactory (70-79%)',
          levels['satisfactory'],
          total,
          AppTheme.warningColor,
          Icons.check_circle_rounded,
        ),
        const SizedBox(height: 12),
        _buildPerformanceLevel(
          'Needs Improvement (<70%)',
          levels['needsImprovement'],
          total,
          AppTheme.errorColor,
          Icons.warning_rounded,
        ),
        ],
      ),
    );
  }

  Widget _buildPerformanceLevel(String label, int count, int total, Color color, IconData icon) {
    final percentage = total > 0 ? (count / total) * 100 : 0.0;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '$count (${percentage.toStringAsFixed(1)}%)',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentTypeAnalysis(Map<String, double> averages) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildAssessmentTypeCard('Quizzes', averages['quizzes'] ?? 0.0, Icons.quiz_rounded, AppTheme.primaryColor),
          const SizedBox(height: 12),
          _buildAssessmentTypeCard('Assignments', averages['assignments'] ?? 0.0, Icons.assignment_rounded, AppTheme.warningColor),
          const SizedBox(height: 12),
          _buildAssessmentTypeCard('Tests', averages['tests'] ?? 0.0, Icons.assignment_turned_in_rounded, AppTheme.errorColor),
          const SizedBox(height: 12),
          _buildAssessmentTypeCard('Projects', averages['projects'] ?? 0.0, Icons.folder_special_rounded, AppTheme.successColor),
        ],
      ),
    );
  }

  Widget _buildAssessmentTypeCard(String title, double average, IconData icon, Color color) {
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Class Average',
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
              Text(
                '${average.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getLetterGrade(average),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGradeDistributionChart(Map<String, int> distribution) {
    final grades = ['A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'F'];
    final maxCount = distribution.values.isEmpty ? 1 : distribution.values.reduce((a, b) => a > b ? a : b);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Distribution by Letter Grade',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Total: ${distribution.values.fold(0, (sum, count) => sum + count)} students',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: grades.map((grade) {
                final count = distribution[grade] ?? 0;
                final height = maxCount > 0 ? (count / maxCount) * 120 : 0.0;
                final color = _getGradeColor(_getGradeScore(grade));
                
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (count > 0)
                          Text(
                            '$count',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        SizedBox(height: count > 0 ? 2 : 0),
                        Container(
                          height: height,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          grade,
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
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
    );
  }

  double _getGradeScore(String grade) {
    switch (grade) {
      case 'A+': return 98;
      case 'A': return 95;
      case 'A-': return 92;
      case 'B+': return 88;
      case 'B': return 85;
      case 'B-': return 82;
      case 'C+': return 78;
      case 'C': return 75;
      case 'C-': return 72;
      case 'D+': return 68;
      case 'D': return 66;
      case 'F': return 50;
      default: return 0;
    }
  }

  Widget _buildTrendAnalysis() {
    // Mock trend data - in real app, this would come from historical data
    final trendData = <Map<String, dynamic>>[
      {'month': 'Sep', 'average': 78.5},
      {'month': 'Oct', 'average': 81.2},
      {'month': 'Nov', 'average': 83.8},
      {'month': 'Dec', 'average': 82.1},
      {'month': 'Jan', 'average': 85.3},
      {'month': 'Feb', 'average': 87.2},
    ];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Performance Trend',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.trending_up_rounded, color: AppTheme.successColor, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '+8.7% improvement',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.successColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: trendData.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                final average = data['average'] as double;
                final height = (average / 100) * 50;
                final isLast = index == trendData.length - 1;
                
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${average.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            color: isLast ? AppTheme.primaryColor : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          height: height,
                          decoration: BoxDecoration(
                            color: isLast ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data['month'] as String,
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
    );
  }

  Widget _buildTopPerformers() {
    final sortedStudents = List<Map<String, dynamic>>.from(widget.studentsData);
    sortedStudents.sort((a, b) => _calculateCumulativeGrade(b).compareTo(_calculateCumulativeGrade(a)));
    final topPerformers = sortedStudents.take(5).toList();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
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
            'Top 5 Performers',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 20),
          ...topPerformers.asMap().entries.map((entry) {
            final index = entry.key;
            final student = entry.value;
            final grade = _calculateCumulativeGrade(student);
            final letterGrade = _getLetterGrade(grade);
            final gradeColor = _getGradeColor(grade);
            
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _getRankColor(index + 1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: _getRankColor(index + 1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: gradeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        student['avatar'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: gradeColor,
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
                          student['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
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
                      Text(
                        letterGrade,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: gradeColor,
                        ),
                      ),
                      Text(
                        '${grade.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return const Color(0xFFFFD700); // Gold
    if (rank == 2) return const Color(0xFFC0C0C0); // Silver
    if (rank == 3) return const Color(0xFFCD7F32); // Bronze
    return AppTheme.primaryColor;
  }

  // Action Methods
  void _refreshData() {
    HapticFeedback.lightImpact();
    setState(() {
      _animationController.reset();
      _animationController.forward();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Analytics data refreshed'),
        backgroundColor: AppTheme.successColor,
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
            const Text(
              'Analytics Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            _buildExportOption(
              Icons.download_rounded,
              'Export Analytics',
              'Download detailed analytics report',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Exporting analytics report...'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
            ),
            _buildExportOption(
              Icons.settings_rounded,
              'Customize View',
              'Adjust metrics and display options',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening customization options...'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
            _buildExportOption(
              Icons.schedule_rounded,
              'Schedule Report',
              'Set up automatic analytics reports',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening report scheduler...'),
                    backgroundColor: AppTheme.primaryColor,
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