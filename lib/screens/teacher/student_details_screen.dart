import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class StudentDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> student;
  final String selectedClass;
  final String selectedSubject;
  final String selectedTerm;

  const StudentDetailsScreen({
    Key? key,
    required this.student,
    required this.selectedClass,
    required this.selectedSubject,
    required this.selectedTerm,
  }) : super(key: key);

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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

  double _calculateCumulativeGrade() {
    final assessments = widget.student['assessments'] as Map<String, dynamic>;
    final weights = widget.student['weights'] as Map<String, dynamic>;
    
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

  double _calculateAverage(dynamic scores) {
    if (scores is List && scores.isNotEmpty) {
      final numList = scores.cast<num>();
      return numList.reduce((a, b) => a + b) / numList.length;
    }
    return 0.0;
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

  @override
  Widget build(BuildContext context) {
    final cumulativeGrade = _calculateCumulativeGrade();
    final letterGrade = _getLetterGrade(cumulativeGrade);
    final gradeColor = _getGradeColor(cumulativeGrade);
    final assessments = widget.student['assessments'] as Map<String, dynamic>;
    final trends = widget.student['trends'] as List<dynamic>;

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
                  // Student Header
                  SliverToBoxAdapter(child: _buildStudentHeader(cumulativeGrade, letterGrade, gradeColor)),

                  // Action Buttons
                  SliverToBoxAdapter(child: _buildActionButtons()),

                  // Assessment Overview
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        _buildSectionTitle('Assessment Overview'),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // Assessment Cards
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _buildDetailedAssessmentCard('Quizzes', assessments['quizzes'], 0.20, Icons.quiz_rounded, AppTheme.primaryColor),
                        const SizedBox(height: 12),
                        _buildDetailedAssessmentCard('Assignments', assessments['assignments'], 0.25, Icons.assignment_rounded, AppTheme.warningColor),
                        const SizedBox(height: 12),
                        _buildDetailedAssessmentCard('Tests', assessments['tests'], 0.35, Icons.assignment_turned_in_rounded, AppTheme.errorColor),
                        const SizedBox(height: 12),
                        _buildDetailedAssessmentCard('Projects', assessments['projects'], 0.15, Icons.folder_special_rounded, AppTheme.successColor),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),

                  // Participation & Attendance
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
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
                    ),
                  ),

                  // Progress Trend
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        _buildSectionTitle('Progress Trend'),
                        const SizedBox(height: 16),
                        _buildProgressTrend(trends, gradeColor),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  // Grade Calculation
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _buildSectionTitle('Grade Calculation'),
                        const SizedBox(height: 16),
                        _buildGradeCalculation(assessments, cumulativeGrade, letterGrade, gradeColor),
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
      title: Text(
        widget.student['name'],
        style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2D3748)),
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
            Icons.print_rounded,
            color: Color(0xFF2D3748),
          ),
          onPressed: _printStudentReport,
        ),
        IconButton(
          icon: const Icon(
            Icons.download_rounded,
            color: Color(0xFF2D3748),
          ),
          onPressed: _exportStudentReport,
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

  Widget _buildStudentHeader(double cumulativeGrade, String letterGrade, Color gradeColor) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gradeColor.withOpacity(0.1), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: gradeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                widget.student['avatar'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: gradeColor,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.student['name'],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Roll No: ${widget.student['rollNumber']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.selectedClass} • ${widget.selectedSubject} • ${widget.selectedTerm}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: gradeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  letterGrade,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: gradeColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${cumulativeGrade.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: gradeColor,
                ),
              ),
            ],
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
              onPressed: _printStudentReport,
              icon: const Icon(Icons.print_rounded, size: 18),
              label: const Text('Print Report'),
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
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _exportStudentReport,
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text('Export PDF'),
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
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _emailToParent,
              icon: const Icon(Icons.email_rounded, size: 18),
              label: const Text('Email Parent'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.successColor,
                side: BorderSide(color: AppTheme.successColor),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildDetailedAssessmentCard(String title, dynamic scores, double weight, IconData icon, Color color) {
    final scoresList = scores is List ? scores.cast<num>() : <num>[];
    final average = scoresList.isEmpty ? 0.0 : scoresList.reduce((a, b) => a + b) / scoresList.length;
    
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
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${(weight * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Average: ${average.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Count: ${scoresList.length} assessments',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (scoresList.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Range: ${scoresList.reduce((a, b) => a < b ? a : b).toInt()}% - ${scoresList.reduce((a, b) => a > b ? a : b).toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (scoresList.isNotEmpty)
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.end,
                    children: scoresList.map((score) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getGradeColor(score.toDouble()).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${score.toInt()}%',
                          style: TextStyle(
                            fontSize: 14,
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
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${scoreValue.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Weight: ${(weight * 100).toInt()}%',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTrend(List<dynamic> trends, Color gradeColor) {
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
          Row(
            children: [
              Icon(Icons.trending_up_rounded, color: _getTrendColor(trends), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getTrendDirection(trends),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _getTrendColor(trends),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
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
          SizedBox(
            height: 70,
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
                        Text(
                          '${value.toInt()}%',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: isLast ? gradeColor : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 2),
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
    );
  }

  Widget _buildGradeCalculation(Map<String, dynamic> assessments, double cumulativeGrade, String letterGrade, Color gradeColor) {
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
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              Text(
                '${cumulativeGrade.toStringAsFixed(1)}% ($letterGrade)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: gradeColor,
                ),
              ),
            ],
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
            flex: 3,
            child: Text(
              title,
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

  // Action Methods
  void _printStudentReport() {
    HapticFeedback.lightImpact();
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
            Text('Print detailed assessment report for ${widget.student['name']}?'),
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
                  Text('Student: ${widget.student['name']}'),
                  Text('Roll No: ${widget.student['rollNumber']}'),
                  Text('Class: ${widget.selectedClass}'),
                  Text('Subject: ${widget.selectedSubject}'),
                  Text('Grade: ${_calculateCumulativeGrade().toStringAsFixed(1)}% (${_getLetterGrade(_calculateCumulativeGrade())})'),
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
                  content: Text('Printing ${widget.student['name']} report...'),
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

  void _exportStudentReport() {
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
              'Export ${widget.student['name']} Report',
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
                    content: Text('Exporting ${widget.student['name']} report as PDF...'),
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
                    content: Text('Sharing ${widget.student['name']} report...'),
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

  void _emailToParent() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Emailing ${widget.student['name']} report to parent...'),
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
              'More Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            _buildExportOption(
              Icons.edit_rounded,
              'Edit Student Info',
              'Update student details and information',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Edit student info...'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
            _buildExportOption(
              Icons.history_rounded,
              'Grade History',
              'View complete grading history',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening grade history...'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
            _buildExportOption(
              Icons.add_rounded,
              'Add Assessment',
              'Add new grade for this student',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Add new assessment...'),
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